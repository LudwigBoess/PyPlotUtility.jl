"""
    propaganda_plot_double_row(Ncols, files, im_cmap, cb_labels, vmin_arr, vmax_arr, plot_name;
                                map_arr = nothing, par_arr = nothing,
                                contour_arr = nothing, contour_par_arr = nothing,
                                log_map = trues(2Ncols),
                                smooth_file = falses(2Ncols),
                                smooth_sizes = 0.0,
                                annotate_smoothing = falses(2Ncols),
                                streamline_files = nothing,
                                streamlines = falses(2Ncols),
                                contour_files = nothing,
                                contours = falses(2Ncols),
                                contour_levels = nothing,
                                contour_color = "white",
                                smooth_contour_file = falses(2Ncols),
                                alpha_contours = ones(2Ncols),
                                cutoffs = nothing,
                                mask_bad = trues(2Ncols),
                                bad_colors = ["k" for _ = 1:2Ncols],
                                annotate_time = falses(2Ncols),
                                time_labels = nothing,
                                annotate_text = falses(2Ncols),
                                text_labels = nothing,
                                annotate_scale = trues(2Ncols),
                                scale_label = L"1 \\: h^{-1} c" * "Mpc",
                                scale_kpc = 1000.0,
                                r_circles = nothing,
                                shift_colorbar_labels_inward = trues(2Ncols),
                                upscale = Ncols,
                                aspect_ratio = 1.42,
                                read_mode = 1,
                                image_num = ones(Int64, 2Ncols),
                                transparent = false,
                                ticks_color = "k"
                                )

Creates an `image_grid` plot with `Ncols` and `Nrows` with colorbars on top.

"""
function propaganda_plot_double_row(Ncols, files, im_cmap, cb_labels, vmin_arr, vmax_arr, plot_name;
                                map_arr = nothing, par_arr = nothing,
                                contour_arr = nothing, contour_par_arr = nothing,
                                log_map = trues(2Ncols),
                                smooth_file = falses(2Ncols),
                                smooth_sizes = 0.0,
                                annotate_smoothing = falses(2Ncols),
                                streamline_files = nothing,
                                streamlines = falses(2Ncols),
                                contour_files = nothing,
                                contours = falses(2Ncols),
                                contour_levels = nothing,
                                contour_color = "white",
                                smooth_contour_file = falses(2Ncols),
                                alpha_contours = ones(2Ncols),
                                cutoffs = nothing,
                                mask_bad = trues(2Ncols),
                                bad_colors = ["k" for _ = 1:2Ncols],
                                annotate_time = falses(2Ncols),
                                time_labels = nothing,
                                annotate_text = falses(2Ncols),
                                text_labels = nothing,
                                annotate_scale = trues(2Ncols),
                                scale_label = L"1 \: h^{-1} c" * "Mpc",
                                scale_kpc = 1000.0,
                                r_circles = nothing,
                                shift_colorbar_labels_inward = trues(2Ncols),
                                upscale = Ncols,
                                aspect_ratio = 1.42,
                                read_mode = 1,
                                image_num = ones(Int64, 2Ncols),
                                transparent = false,
                                ticks_color = "k",
                                annotation_color = "w"
                            )


    fig = get_figure( aspect_ratio , x_pixels = upscale*300)
    plot_styling!(upscale*300, axis_label_font_size=8, legend_font_size=5, color=ticks_color)

    gs = plt.GridSpec(4, Ncols, figure = fig, 
                      width_ratios = ones(Ncols), wspace = 0.0,
                      height_ratios = [0.05, 1, 1, 0.05], hspace=0.0
                      )

    Nfile = 1
    Ncontour = 1
    
    for row = 1:2, col = 1:Ncols

            @info "Column $col, Plot $row"

            subplot(get_gs(gs, row, (col-1)))
            ax = gca()

            # read map and parameters
            map, par = read_map_par(read_mode, Nfile, files, map_arr, par_arr)

            if smooth_file[Nfile]
                smooth_map!(map, smooth_sizes[Nfile], par)
            end

            if !isnothing(cutoffs)
                map[map.<cutoffs[Nfile]] .= NaN
            end

            if mask_bad[Nfile]
                # get colormap object
                cmap = plt.get_cmap(im_cmap[Nfile])
                # set invalid pixels to bad color
                cmap.set_bad(bad_colors[Nfile])
            end

            if log_map[Nfile]

                im = ax.imshow(map, norm = matplotlib.colors.LogNorm(),
                    vmin = vmin_arr[Nfile], vmax = vmax_arr[Nfile],
                    cmap = im_cmap[Nfile],
                    origin = "lower"
                )
            else
                im = ax.imshow(map,
                    vmin = vmin_arr[Nfile], vmax = vmax_arr[Nfile],
                    cmap = im_cmap[Nfile],
                    origin = "lower"
                )
            end

            if contours[Nfile]

                par, map = read_map_par(read_mode, Nfile, contour_files, contour_arr, contour_par_arr)


                if smooth_contour_file[Nfile]
                    smooth_map!(map, smooth_sizes[Nfile], par)
                end

                if isnothing(contour_levels)
                    ax.contour(map, colors = contour_color, linewidth = 1.2, linestyle = "--", alpha = alpha_contours[col])
                else
                    ax.contour(map, contour_levels, colors = contour_color, linewidth = 1.2, linestyle = "--", alpha = alpha_contours[col])
                end

                Ncontour += 1
            end

            if streamlines[Nfile]
                image_name = streamline_files[Nfile]
                vx, par, snap_num, units = read_fits_image(image_name)
                image_name = streamline_files[Nfile+1]
                vy, par, snap_num, units = read_fits_image(image_name)

                x_grid = collect(1:par.Npixels[1])
                y_grid = collect(1:par.Npixels[1])

                ax.streamplot(x_grid, y_grid,
                    vx, vy,
                    density = 2,
                    color = "white"
                )

                Ncontour += 1
            end

            if col == 1

                pixelSideLength = (par.x_lim[2] - par.x_lim[1]) / par.Npixels[1]


                # annotate_arrows(ax, 1.0, 1.0, 300.0/4.0, 500.0/4.0, 
                # 		x_arrow_text[i], y_arrow_text[i], 200.0/4.0)

                if annotate_scale[row]
                    # annotate_scale(ax, par.Npixels[1], 1.0, 300.0/4.0, 1000.0/pixelSideLength, 
                    # 	L"1 \: h^{-1} c" * "Mpc", 500.0/4.0)

                    scale_annotation(ax, par.Npixels[1], 1.0, par.Npixels[1] / 14, #scale_pixel_offset, 
                        scale_kpc / pixelSideLength, 0.1,
                        scale_label,
                        par.Npixels[1] / 8,
                        annotation_color
                    )
                end

            end

            if annotate_time[Nfile]
                time_annotation(ax, 1.0, par.Npixels[1], 0.075 * par.Npixels[1],
                                time_labels[Nfile],
                                annotation_color)
            end

            if annotate_text[Nfile]
                text_annotation(ax, par.Npixels[1], par.Npixels[1], 0.075 * par.Npixels[1],
                                text_labels[Nfile],
                                annotation_color)
            end

            pixelSideLength = (par.x_lim[2] - par.x_lim[1]) / par.Npixels[1]

            if !isnothing(r_circles)
                ax.add_artist(plt.Circle((0.5par.Npixels[1], 0.5par.Npixels[2]), r_circles[1] / pixelSideLength,
                        color = "w", fill = false, ls = ":", alpha=0.5))
                ax.add_artist(plt.Circle((0.5par.Npixels[1], 0.5par.Npixels[2]), r_circles[1] / pixelSideLength,
                        color = "w", fill = false, ls = "--", alpha=0.5))
            end

            # draw smoothing beam
            if smooth_file[Nfile] || smooth_contour_file[Nfile] || annotate_smoothing[Nfile]
                pixelSideLength = (par.x_lim[2] - par.x_lim[1]) / par.Npixels[1]
                smooth_pixel    = smooth_sizes[Nfile] ./ pixelSideLength

                ax.add_artist(matplotlib.patches.Rectangle((0.1par.Npixels[1] - 1.5*smooth_pixel[1],0.1par.Npixels[1] - 1.5*smooth_pixel[2]),           # anchor
                                                            3*smooth_pixel[1], # width
                                                            3*smooth_pixel[2], # height
                                                            linewidth=1,edgecolor="gray",facecolor="gray"))

                ax.add_artist(matplotlib.patches.Ellipse((0.1par.Npixels[1], 0.1par.Npixels[2]), smooth_pixel[1], smooth_pixel[2],
                    color = "w", fill = true, ls = "-"))
            end

            ax.set_axis_off()

            for spine in values(ax.spines)
                spine.set_edgecolor(ticks_color)
            end

            if row == 1
                loc = "top"
                cax_row = 0
            else
                loc = "bottom"
                cax_row = 3
            end

            subplot(get_gs(gs, cax_row, (col-1)))
            cax = gca()

            if log_map[Nfile]
                sm = plt.cm.ScalarMappable(cmap = im_cmap[Nfile], norm = matplotlib.colors.LogNorm(vmin = vmin_arr[Nfile], vmax = vmax_arr[Nfile]))
            else
                sm = plt.cm.ScalarMappable(cmap = im_cmap[Nfile], plt.Normalize(vmin = vmin_arr[Nfile], vmax = vmax_arr[Nfile]) )
            end

            sm.set_array([])
            cb = colorbar(sm, cax=cax, fraction = 0.046, orientation = "horizontal")

            cb.set_label(cb_labels[Nfile])
            cb.ax.tick_params(
                direction = "in",
                which = "major",
                size = 6, width = 1
            )
            cb.ax.tick_params(
                direction = "in",
                which = "minor",
                size = 3, width = 1
            )

            #cb_ticks_styling!(cb.ax, color=ticks_color)

            cb.ax.xaxis.set_ticks_position(loc)
            cb.ax.xaxis.set_label_position(loc)

            if shift_colorbar_labels_inward[Nfile]
                shift_colorbar_label!(cb.ax, "left")
                shift_colorbar_label!(cb.ax, "right")
            end
            

            # count up file
            Nfile += 1
        end

    #gs.tight_layout(fig, pad = 0.0, h_pad = -10.0, w_pad= 0.0)

    @info "saving $plot_name"
    savefig(plot_name, bbox_inches = "tight", transparent=transparent)

    close(fig)

end