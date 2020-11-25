module PyPlotUtility

    using PyCall
    using PyPlot
    using SPHtoGrid
    

    export axis_ticks_styling!, get_gs,
        linestyle, ls,
        pixel_size,
        get_imshow, get_imshow_log,
        get_colorbar_top,
        shift_colorbar_label!,
        get_streamlines,
        pixel_size


    function axis_ticks_styling!(ax::PyCall.PyObject; size_minor_ticks::Int64=6, tick_label_size::Int64=15, color::String="k")

        ax.tick_params(reset=true, direction="in", axis="both", labelsize=tick_label_size,
                        which="major", size=size_minor_ticks<<1, width=1, color=color)
        ax.tick_params(reset=true, direction="in", axis="both", labelsize=tick_label_size,
                        which="minor", size=size_minor_ticks, width=1, color=color)

        ax.minorticks_on()

        return ax
    end

    function pixel_size(fig::Figure)
        return (72.0/fig.dpi)*(72.0/fig.dpi)
    end

    function slice(rng::UnitRange)
        pycall(pybuiltin("slice"), PyObject, first(rng), last(rng))
    end


    function get_gs(gs::PyObject, row, col)

        if (typeof(row) <: UnitRange && typeof(col) <: UnitRange )
            return get(gs, (slice(row), slice(col)))
        elseif typeof(row) <: UnitRange
            return get(gs, (slice(row), col))
        elseif typeof(col) <: UnitRange
            return get(gs, (row, slice(col)))
        else
            return get(gs, (row, col))
        end
    end


    function linestyle(sequence::String="";
                    dash::Float64=3.7, dot::Float64=1.0, space::Float64=3.7,
                    buffer::Bool=false, offset::Int64=0)


        if ( count(i-> (i=='.'), sequence) > 0 ) || ( count(i-> (i==':'), sequence) > 0)
            dash = 6.4
        end

        if (sequence == "" || sequence == "-" || sequence == "_")
            return (offset, [ dash ])
        elseif sequence == ":"
            return (offset, [dot, space, dot, space, dot, space] )
        else
            reftype = Dict( '-' => [  dash, space ],
                            '_' => [ 2dash, space ],
                            '.' => [   dot, space ],
                            ':' => [   dot, space, dot, space, dot, space ] )

            onoffseq = Vector{Float64}(undef, 0)

            for c ∈ sequence
                onoffseq = [onoffseq; reftype[c]]
            end

            if buffer
                onoffseq[end] = 1.0
            end

            return (offset, onoffseq)
        end

    end

    function ls(sequence::String="";
                dash::Float64=3.7, dot::Float64=1.0, space::Float64=3.7,
                buffer::Bool=false, offset::Int64=0)

        return linestyle(sequence, dash=dash, dot=dot, space=space, buffer=buffer, offset=offset)
    end

    function pixel_size(fig::Figure)
        (72.0/fig.dpi)*(72.0/fig.dpi)
    end


    function get_imshow(ax::PyCall.PyObject, image::Array{<:Real}, 
                            x_lim::Array{<:Real}=zeros(2), y_lim::Array{<:Real}=zeros(2), 
                            vmin::Real=0.0, vmax::Real=0.0; 
                            cmap::String="viridis", ticks_color::String="white")

        if vmin == 0.0 && vmax == 0.0
            vmin = minimum(image)
            vmax = maximum(image)
        end

        if x_lim == zeros(2) && y_lim == zeros(2)
            x_lim = [1, length(image[:,1])]
            y_lim = [1, length(image[1,:])]
        end
        
        im = ax.imshow(image,
                        vmin=vmin, vmax=vmax, 
                        cmap = cmap,
                        origin="lower",
                        extent= [x_lim[1],
                                x_lim[2],
                                y_lim[1],
                                y_lim[2]]
                            )

        for spine in values(ax.spines)
            spine.set_edgecolor(ticks_color)
        end

        return im
    end

    function get_imshow_log(ax::PyCall.PyObject, image::Array{<:Real}, 
                            x_lim::Array{<:Real}=zeros(2), y_lim::Array{<:Real}=zeros(2), 
                            vmin::Real=0.0, vmax::Real=0.0; 
                            cmap::String="viridis", ticks_color::String="white")

        if vmin == 0.0 || vmax == 0.0
            vmin = minimum(image)
            vmax = maximum(image)
        end

        if x_lim == zeros(2) && y_lim == zeros(2)
            x_lim = [1, length(image[:,1])]
            y_lim = [1, length(image[1,:])]
        end

        im = ax.imshow( image, norm=matplotlib.colors.LogNorm(),
                        vmin=vmin, vmax=vmax, 
                        cmap = cmap,
                        origin="lower",
                        extent= [x_lim[1],
                                x_lim[2],
                                y_lim[1],
                                y_lim[2]]
                            )

        for spine in values(ax.spines)
            spine.set_edgecolor(ticks_color)
        end

        return im
    end

    function get_streamlines( ax::PyCall.PyObject, 
                              image_x::Array{<:Real}, image_y::Array{<:Real}, 
                              par::mappingParameters;
                              scale::Real=1.0, density::Real=2.0, color::String="grey")

        ax.set_xlim(scale .* par.x_lim)
        ax.set_ylim(scale .* par.y_lim)
    
        x_grid, y_grid = get_map_grid_2D(par)

        x_grid .*= scale
        y_grid .*= scale

        stream = ax.streamplot( x_grid, y_grid,
                                image_x, image_y, 
                                density = density, 
                                color = color
                              )

        return stream
    end


    function get_colorbar_top(ax::PyCall.PyObject, im::PyCall.PyObject, 
                              label::AbstractString, 
                              axis_label_font_size::Integer, 
                              tick_label_size::Integer)

        axes_divider = pyimport("mpl_toolkits.axes_grid1.axes_divider")
        
        ax_divider = axes_divider.make_axes_locatable(ax)
        cax = ax_divider.append_axes("top", size="7%", pad="2%")
        cb = colorbar(im, cax=cax, orientation="horizontal")#, fraction=0.046, pad=0.5)#, cax=cbaxis1)
        cb.set_label(label, fontsize=axis_label_font_size)
        cb.ax.tick_params(
                            direction="in",
                            which="major",
                            labelsize=tick_label_size,
                            size=6, width=1
                            )
        cb.ax.tick_params(
                            direction="in",
                            which="minor",
                            labelsize=tick_label_size,
                            size=3, width=1
                            )

        cax.xaxis.set_ticks_position("top")
        cax.xaxis.set_label_position("top")

        return cax
    end

    function shift_colorbar_label!(cax1::PyCall.PyObject, shift::String)

        if shift ∈ ["left", "l"]
            label1 = cax1.xaxis.get_majorticklabels()
            label1[end].set_horizontalalignment("right")
        elseif  shift ∈ ["right", "r"]
            label1 = cax1.xaxis.get_majorticklabels()
            label1[1].set_horizontalalignment("left")
        else
            error("Shift needs to be 'left'/'l' or 'right'/'r' !")
        end

    end

    """
        Propaganda Plot
    """
    function annotate_arrows(ax, xmin, ymin, offset, length, x_text, y_text, text_offset)

        # arrow in x-direction
        ax.arrow(xmin+offset, ymin+offset, length, 0.0, width = 0.1, color="white", length_includes_head=true)

        # arrow in y-direction
        ax.arrow(xmin+offset, ymin+offset, 0.0, length, width = 0.1, color="white", length_includes_head=true)

        # x label
        text_x = xmin+offset+length+text_offset
        text_y = ymin+offset

        ax.text(text_x, text_y, x_text, color="white", fontsize=15, horizontalalignment="center", verticalalignment="center")

        # y label
        text_x = xmin+offset
        text_y = ymin+offset+length+text_offset

        ax.text(text_x, text_y, y_text, color="white", fontsize=15, horizontalalignment="center", verticalalignment="center")
    end

    function annotate_scale(ax, xmax, ymin, offset, length, scale_text, text_offset)

        # Line 
        ax.arrow(xmax-length-offset, ymin+offset, length, 0.0, width = 0.1, color="white", 
            length_includes_head=true, head_width=0.0)

        # x label
        text_x = xmax-0.5*length-offset
        text_y = ymin+text_offset

        ax.text(text_x, text_y, scale_text, color="white", fontsize=15, horizontalalignment="center", verticalalignment="center")
    end

    function annotate_redshift(ax, xmin, ymax, offset, z_text)

        # x label
        text_x = xmin+offset
        text_y = ymax-offset

        ax.text(text_x, text_y, z_text, color="white", fontsize=20, horizontalalignment="left", verticalalignment="top")
    end


end # module
