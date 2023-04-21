using Healpix
using Unitful, UnitfulAstro


"""
    plot_single_allsky( filename::String, 
                        im_cmap, cb_label::AbstractString, clim::Vector{<:Real}, 
                        plot_name::String;
                        Npixels::Integer=2048,
                        log_map::Bool=true,
                        cutoff=nothing,
                        annotate_time::Bool=true,
                        time_label::AbstractString="",
                        upscale::Real=3,
                        ticks_color::String = "k",
                        mask_bad::Bool=true,
                        bad_color::String="w",
                        transparent::Bool=false )

Reads and plots an allsky fits image created with Smac1.
"""
function plot_single_allsky(filename::String, 
                            im_cmap, cb_label::AbstractString, clim::Vector{<:Real}, 
                            plot_name::String;
                            Npixels::Integer=1024,
                            log_map::Bool=true,
                            cutoff=clim[1],
                            annotate_time::Bool=true,
                            time_label::AbstractString="",
                            upscale::Real=3,
                            ticks_color::String = "k",
                            mask_bad::Bool=true,
                            bad_color::String="w",
                            bad_alpha::Real=0.0,
                            transparent::Bool=false,
                            smooth_image::Bool=false,
                            smooth_size::Real=2.0,
                            contour_file=nothing,
                            contour_levels::Vector{<:Real}=[0.5, 1.0],
                            contour_color::String="w",
                            contour_alpha::Real=0.8,
                            contour_linestyle::String="dotted",
                            annotations=nothing,
                            dpi=400,
                            per_sr::Bool=false,
                            origin="lower")


    # read healpix image
    m = Healpix.readMapFromFITS(filename, 1, Float64)

    println(maximum(m))

    if per_sr
        sr = 4π / length(m)
        m ./= sr
    end
    
    if !isnothing(cutoff)
        m[m[:].<cutoff] .= NaN
    end

    if mask_bad 
        m[findall(isnan.(m[:]))] .= clim[1]
        m[findall(isinf.(m[:]))] .= clim[1]
    end    
    
    # construct 2D array by deprojecting
    image, mask, maskflag = project(mollweideprojinv, m, 2Npixels, Npixels, 
                                Dict(:desttype => Float64))

    if smooth_image
        image = imfilter(image, reflect(Kernel.gaussian(smooth_size)))
    end

    if !isnothing(contour_file)
        # read healpix image
        c_m = Healpix.readMapFromFITS(contour_file, 1, Float64)

        # construct 2D array by deprojecting
        contour_image, mask, maskflag = project(mollweideprojinv, c_m, 2Npixels, Npixels)
    end

    fig = get_figure( 1.8 , x_pixels = upscale*300)
    plot_styling!(upscale*300, axis_label_font_size=upscale*4, legend_font_size=5, color=ticks_color)
    gs = plt.GridSpec(2, 8, figure = fig,
                      height_ratios = [0.04, 1], hspace=0.0
                      )

    subplot(get_gs(gs, 1, 0:7))
    ax = gca()

    

    if mask_bad
        # get colormap object
        cmap = plt.get_cmap(im_cmap)
        # set invalid pixels to bad color
        cmap.set_bad(bad_color, bad_alpha)
    end

    if log_map
        im = ax.imshow(image, norm=matplotlib.colors.LogNorm(vmin=clim[1], vmax=clim[2]),
                       cmap = im_cmap,
                       origin = origin
                      )
    else
        im = ax.imshow(image,
                       vmin = clim[1], vmax = clim[2],
                       cmap = im_cmap,
                        origin=origin
                        )
    end

    println("before contours")
    # add contours if requested
    if !isnothing(contour_file)
        println("contours")
        ax.contour(contour_image,
                    levels = contour_levels,
                    alpha = contour_alpha,
                    colors = contour_color,
                    linestyles = contour_linestyle,
                    origin=origin
                    )
    end

    # add annotations for cluster names 
    if !isnothing(annotations)
        for ann ∈ annotations
            txt = ax.text(ann.xpix, ann.ypix, ann.name, color=contour_color, fontsize=10)
            #txt.set_path_effects([PE.withStroke(linewidth=1, foreground="k")])
        end
    end

    if annotate_time
        time_annotation(ax, 1.0, 0.05 * Npixels, 0.0,
                        time_label, ticks_color)
    end


    ax.set_axis_off()

    # color bar
    subplot(get_gs(gs, 0, 1:6))
    cax = gca()

    if log_map
        sm = plt.cm.ScalarMappable(cmap = im_cmap, norm = matplotlib.colors.LogNorm(vmin = clim[1], vmax = clim[2]))
    else
        sm = plt.cm.ScalarMappable(cmap = im_cmap, plt.Normalize(vmin = clim[1], vmax = clim[2]) )
    end

    sm.set_array([])
    cb = colorbar(sm, cax=cax, fraction = 0.046, orientation = "horizontal")

    cb.set_label(cb_label)

    cb_ticks_styling!(cb, color=ticks_color)

    cb.ax.xaxis.set_ticks_position("top")
    cb.ax.xaxis.set_label_position("top")

    #color_spines(cb.ax, ticks_color)

    cb.ax.xaxis.set_label_coords(0.5, 2.5)

    @info "saving $plot_name"
    savefig(plot_name, bbox_inches = "tight", transparent=transparent, dpi = dpi)

    close(fig)
end




"""
    plot_single_allsky( filename::String, 
                        im_cmap, cb_label::AbstractString, clim::Vector{<:Real}, 
                        plot_name::String;
                        Npixels::Integer=2048,
                        log_map::Bool=true,
                        cutoff=nothing,
                        annotate_time::Bool=true,
                        time_label::AbstractString="",
                        upscale::Real=3,
                        ticks_color::String = "k",
                        mask_bad::Bool=true,
                        bad_color::String="w",
                        transparent::Bool=false )

Reads and plots an allsky fits image created with Smac1.
"""
function plot_multiple_allsky(filenames::Vector{String},
                            im_cmap, cb_label::AbstractString, clim::Vector{<:Real},
                            plot_name::String;
                            Ncols::Int64=2,
                            Nrows::Int64=2,
                            Npixels::Integer=1024,
                            log_map::Bool=true,
                            cutoff=clim[1],
                            annotate_time::Bool=true,
                            time_labels::Vector{<:AbstractString}=[L"" for i = 1:length(filenames)],
                            upscale::Real=3,
                            ticks_color::String="k",
                            mask_bad::Bool=true,
                            bad_color::String="w",
                            bad_alpha::Real=0.0,
                            transparent::Bool=false,
                            smooth_image::Bool=false,
                            smooth_size::Real=2.0,
                            per_sr::Bool=false,
                            per_beam::Bool=false,
                            beam_size=5.0, # in arcsec
                            contour_file=nothing,
                            contour_levels::Vector{<:Real}=[0.5, 1.0],
                            contour_color::String="w",
                            contour_alpha::Real=0.8,
                            contour_linestyle::String="dotted",
                            annotations=nothing,
                            dpi=400,
                            origin="lower")


    if !isnothing(contour_file)
        # read healpix image
        c_m = Healpix.readMapFromFITS(contour_file, 1, Float64)
        # construct 2D array by deprojecting
        contour_image, mask, maskflag = project(mollweideprojinv, c_m, 2Npixels, Npixels)
    end

    height_ratios = ones(Nrows+1)
    height_ratios[1] = 0.08

    if Nrows == 2
        fig_scale = 1.9
    elseif Nrows == 3
        fig_scale = 1.3
    else
        fig_scale = 1
    end


    fig = get_figure(fig_scale, x_pixels=upscale * 300)
    plot_styling!(upscale * 300, axis_label_font_size=12, 
                legend_font_size=5, color=ticks_color)
    gs = plt.GridSpec(1 + Nrows, 4*Ncols, figure=fig,
        height_ratios=height_ratios, hspace=0.05, wspace=0.0 )


    Nfile = 1

    for row = 1:Nrows, col = 1:Ncols

        println(Nfile)

        if col == 1
            cols = 0:4
        elseif col == 2
            cols = 4:8
        else
            cols = 8:12
        end

        subplot(get_gs(gs, row, cols))
        ax = gca()

        # read healpix image
        m = Healpix.readMapFromFITS(filenames[Nfile], 1, Float64)

        if per_sr
            sr = 4π / length(m)
            m ./= sr
        end

        if per_beam
            pixel_area = 4π / length(m)
            beam_area = π * beam_size^2 |> u"sr"
            factor = pixel_area / beam_area |> u"sr" |> ustrip
            m .*= factor
        end

        if !isnothing(cutoff)
            m[m[:].<cutoff] .= NaN
        end

        if mask_bad
            m[findall(isnan.(m[:]))] .= clim[1]
            m[findall(isinf.(m[:]))] .= clim[1]
        end

        # construct 2D array by deprojecting
        image, mask, maskflag = project(mollweideprojinv, m, 2Npixels, Npixels,
            Dict(:desttype => Float64))

        image[ findall(isnan.(mask)) ] .= clim[1]
        image[ findall(isinf.(mask)) ] .= clim[1]

        if smooth_image
            image = imfilter(image, reflect(Kernel.gaussian(smooth_size)))
        end

        if mask_bad
            # get colormap object
            cmap = plt.get_cmap(im_cmap)
            # set invalid pixels to bad color
            cmap.set_bad(bad_color, bad_alpha)
        end

        if log_map
            im = ax.imshow(image, norm=matplotlib.colors.LogNorm(vmin=clim[1], vmax=clim[2]),
                cmap=im_cmap,
                origin=origin
            )
        else
            im = ax.imshow(image,
                vmin=clim[1], vmax=clim[2],
                cmap=im_cmap,
                origin=origin
            )
        end

        # add contours if requested
        if !isnothing(contour_file)
            ax.contour(contour_image,
                levels=contour_levels,
                alpha=contour_alpha,
                colors=contour_color,
                linestyles=contour_linestyle,
                origin="lower"
            )
        end

        # add annotations for cluster names 
        if !isnothing(annotations)
            for ann ∈ annotations
                txt = ax.text(ann.xpix, ann.ypix, ann.name, color=contour_color, fontsize=10)
                #txt.set_path_effects([PE.withStroke(linewidth=1, foreground="k")])
            end
        end

        if annotate_time
            if origin == "lower"
                time_annotation(ax, 1.0, 0.95 * Npixels, 0.0,
                    time_labels[Nfile], ticks_color)
            else
                time_annotation(ax, 1.0, 0.05 * Npixels, 0.0,
                    time_labels[Nfile], ticks_color)
            end
        end

        ax.set_axis_off()

        Nfile += 1
    end

    # color bar
    if Ncols == 1
        cols = 1:7
    elseif Ncols == 2
        cols = 1:7
    elseif Ncols == 3
        cols = 3:9
    end

    subplot(get_gs(gs, 0, cols))
    cax = gca()

    if log_map
        sm = plt.cm.ScalarMappable(cmap=im_cmap, norm=matplotlib.colors.LogNorm(vmin=clim[1], vmax=clim[2]))
    else
        sm = plt.cm.ScalarMappable(cmap=im_cmap, plt.Normalize(vmin=clim[1], vmax=clim[2]))
    end

    sm.set_array([])
    cb = colorbar(sm, cax=cax, fraction=0.046, orientation="horizontal")

    cb.set_label(cb_label)

    cb_ticks_styling!(cb, color=ticks_color)

    cb.ax.xaxis.set_ticks_position("top")
    cb.ax.xaxis.set_label_position("top")

    cb.ax.xaxis.set_label_coords(0.5, 2.8)

    subplots_adjust(hspace=0.0, wspace=0.0)

    @info "saving $plot_name"
    savefig(plot_name, bbox_inches="tight", transparent=transparent, dpi=dpi)

    close(fig)
end