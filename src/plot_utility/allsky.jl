using Healpix


"""
    plot_single_allsky( filename::String, 
                        im_cmap::String, cb_label::AbstractString, clim::Vector{<:Real}, 
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
                            im_cmap::String, cb_label::AbstractString, clim::Vector{<:Real}, 
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
                            transparent::Bool=false)

    # read healpix image
    m = Healpix.readMapFromFITS(filename, 1, Float64)
    # construct 2D array by deprojecting
    image, mask, maskflag = project(mollweideprojinv, m, 2Npixels, Npixels)


    fig = get_figure( 1.8 , x_pixels = upscale*300)
    plot_styling!(upscale*300, axis_label_font_size=upscale*4, legend_font_size=5, color=ticks_color)
    gs = plt.GridSpec(2, 8, figure = fig,
                      height_ratios = [0.04, 1], hspace=0.0
                      )

    subplot(get_gs(gs, 1, 0:7))
    ax = gca()

    if !isnothing(cutoff)
        image[image.<cutoff] .= NaN
    end

    if mask_bad
        # get colormap object
        cmap = plt.get_cmap(im_cmap)
        # set invalid pixels to bad color
        cmap.set_bad(bad_color)
    end

    if log_map
        im = ax.imshow(image, norm = matplotlib.colors.LogNorm(),
                       vmin = clim[1], vmax = clim[2],
                       cmap = im_cmap,
                       origin = "lower"
                      )
    else
        im = ax.imshow(image,
                       vmin = clim[1], vmax = clim[2],
                       cmap = im_cmap,
                       origin = "lower"
                        )
    end

    if annotate_time
        time_annotation(ax, 1.0, Npixels, 0.075 * Npixels,
                        time_label, ticks_color)
    end

    # if annotate_text
    #     text_annotation(ax, par.Npixels[1], par.Npixels[1], 0.075 * par.Npixels[1],
    #                     text_labels)
    # end

    ax.set_axis_off()

    for spine in values(ax.spines)
        spine.set_edgecolor(ticks_color)
    end

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

    @info "saving $plot_name"
    savefig(plot_name, bbox_inches = "tight", transparent=transparent)

    close(fig)
end