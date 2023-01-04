using Healpix

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
                            cutoff=nothing,
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
                            dpi=400)


    # read healpix image
    m = Healpix.readMapFromFITS(filename, 1, Float64)

    if !isnothing(cutoff)
        m[m[:].<cutoff] .= NaN
    end

    if mask_bad 
        m[findall(isnan.(m[:]))] .= clim[1]
    end
    
    # construct 2D array by deprojecting
    image, mask, maskflag = project(mollweideprojinv, m, 2Npixels, Npixels)

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
        im = ax.imshow(image, norm = matplotlib.colors.LogNorm(),
                       vmin = clim[1], vmax = clim[2],
                       cmap = im_cmap,
                       origin = "upper"
                      )
    else
        im = ax.imshow(image,
                       vmin = clim[1], vmax = clim[2],
                       cmap = im_cmap,
                       origin = "upper"
                        )
    end

    # add contours if requested
    if !isnothing(contour_file)
        ax.contour(contour_image,
                    levels = contour_levels,
                    alpha = contour_alpha,
                    colors = contour_color,
                    linestyles = contour_linestyle,
                    origin = "lower"
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

    cb_ticks_styling!(cb.ax, color=ticks_color)

    cb.ax.xaxis.set_ticks_position("top")
    cb.ax.xaxis.set_label_position("top")

    for spine in values(cb.ax.spines)
        spine.set_edgecolor(ticks_color)
    end

    cb.ax.xaxis.set_label_coords(0.5, 2.5)

    @info "saving $plot_name"
    savefig(plot_name, bbox_inches = "tight", transparent=transparent, dpi = dpi)

    close(fig)
end