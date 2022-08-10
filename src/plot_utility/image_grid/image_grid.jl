"""
    propaganda_plot_columns(Nrows, Ncols, files, im_cmap, cb_labels, vmin_arr, vmax_arr, plot_name;
                            map_arr = nothing, par_arr = nothing,
                            contour_arr = nothing, contour_par_arr = nothing,
                            log_map = trues(Ncols),
                            colorbar_bottom = false,
                            colorbar_single = false,
                            smooth_col = falses(Ncols),
                            smooth_size = 0.0,
                            streamline_files = nothing,
                            streamlines = falses(Ncols),
                            contour_files = nothing,
                            contours = falses(Ncols),
                            contour_levels = nothing,
                            contour_color = "white",
                            smooth_contour_col = falses(Ncols),
                            alpha_contours = ones(Ncols),
                            cutoffs = nothing,
                            mask_bad = trues(Ncols),
                            bad_colors = ["k" for _ = 1:Ncols],
                            annotate_time = falses(Nrows * Ncols),
                            time_labels = nothing,
                            annotate_text = falses(Nrows * Ncols),
                            text_labels = nothing,
                            annotate_scale = trues(Nrows * Ncols),
                            annotation_color = "w",
                            scale_label = L"1 \\: h^{-1} c" * "Mpc",
                            scale_kpc = 1000.0,
                            r_circles = nothing,
                            shift_colorbar_labels_inward = trues(Ncols),
                            upscale = Ncols + 0.5,
                            read_mode = 1,
                            image_num = ones(Int64, Ncols),
                            transparent = false,
                            ticks_color = "k"
                            )

Creates an `image_grid` plot with `Ncols` and `Nrows` with colorbars on top.

"""
function plot_image_grid(Nrows, Ncols, files, im_cmap, cb_labels, vmin_arr, vmax_arr, plot_name;
                                map_arr = nothing, par_arr = nothing,
                                contour_arr = nothing, contour_par_arr = nothing,
                                log_map = trues(Nrows*Ncols),
                                smooth_file = falses(Nrows*Ncols),
                                smooth_sizes = 0.0,
                                annotate_smoothing = falses(Nrows*Ncols),
                                smooth_col = falses(Ncols),
                                streamline_files = nothing,
                                streamlines = falses(Nrows*Ncols),
                                contour_files = nothing,
                                contours = falses(Nrows*Ncols),
                                contour_levels = nothing,
                                contour_color = "white",
                                smooth_contour_file = falses(Nrows*Ncols),
                                alpha_contours = ones(Nrows*Ncols),
                                cutoffs = nothing,
                                mask_bad = falses(Nrows*Ncols),
                                bad_colors = ["k" for _ = 1:Nrows*Ncols],
                                annotate_time = falses(Nrows*Ncols),
                                time_labels = nothing,
                                annotate_text = falses(Nrows*Ncols),
                                text_labels = nothing,
                                annotate_scale = trues(Nrows*Ncols),
                                scale_label = L"1 \: h^{-1} c" * "Mpc",
                                scale_kpc = 1000.0,
                                r_circles = nothing,
                                smooth_contour_col = falses(Ncols),
                                shift_colorbar_labels_inward = trues(Nrows*Ncols),
                                upscale = Ncols,
                                read_mode = 1,
                                transparent = false,
                                ticks_color = "k",
                                annotation_color = "w",
                                colorbar_location="top",
                                colorbar_mode="edge",
                                grid_direction="column"
                            )


    if colorbar_location == "top"
        colorbar_orientation = "horizontal"
    elseif colorbar_location == "right"
        colorbar_orientation = "vertical"
    end

    if colorbar_mode == "single"
        colorbar_size = "2%"
    else
        colorbar_size = "7%"
    end

    axes_grid1 = pyimport("mpl_toolkits.axes_grid1")

    axis_label_font_size = 20
    tick_label_size = 15

    fig = figure(figsize = (6 * upscale * Nrows, 6.5 * upscale * Ncols))
    plot_styling!(color=ticks_color)

    grid = axes_grid1.ImageGrid(fig, 111,          # as in plt.subplot(111)
                                nrows_ncols = (Nrows, Ncols),
                                axes_pad = 0.0,
                                direction = grid_direction,
                                cbar_location = colorbar_location,
                                cbar_mode = colorbar_mode,
                                cbar_size = colorbar_size,
                                cbar_pad = 0.0,
                                )


    if grid_direction == "row"
        # switch variables
        Ncols, Nrows = Nrows, Ncols
    end


    Nfile = 1
    Ncontour = 1
    time_label_num = 1
    
    for col = 1:Ncols

        for i = 1:Nrows

            @info "Column $col, Plot $i"

            ax = grid[(col-1)*Nrows+i]

            # read map and parameters
            println("image")
            map, par = read_map_par(read_mode, Nfile, files, map_arr, par_arr)

            if smooth_file[Nfile]
                smooth_map!(map, smooth_sizes[Nfile], par)
            end

            if smooth_col[col]
                pixelSideLength = (par.x_lim[2] - par.x_lim[1]) / par.Npixels[1]
                smooth_pixel = smooth_sizes[col] ./ pixelSideLength
                map = imfilter(map, reflect(Kernel.gaussian((smooth_pixel[1], smooth_pixel[2]), (par.Npixels[1] - 1, par.Npixels[1] - 1))))
            end

            if !isnothing(cutoffs)
                map[map.<cutoffs[Nfile]] .= NaN
            end

            if colorbar_mode == "single"
                selected = 1
            else
                selected = col
            end

            if mask_bad[selected]
                # get colormap object
                cmap = plt.get_cmap(im_cmap[selected])
                # set invalid pixels to bad color
                cmap.set_bad(bad_colors[selected])
            else
                # get colormap object
                cmap = plt.get_cmap(im_cmap[selected])
                # set invalid pixels to minimum
                if im_cmap[selected][end-1:end] == "_r"
                    cmap.set_bad(cmap(vmin_arr[selected]))
                else
                    cmap.set_bad(cmap(vmin_arr[selected]))
                end
            end

            if log_map[selected]

                im = ax.imshow(map, norm = matplotlib.colors.LogNorm(),
                    vmin = vmin_arr[selected], vmax = vmax_arr[selected],
                    cmap = im_cmap[selected],
                    origin = "lower"
                )
            else
                im = ax.imshow(map,
                    vmin = vmin_arr[selected], vmax = vmax_arr[selected],
                    cmap = im_cmap[selected],
                    origin = "lower"
                )
            end

            if contours[selected]

                println("contours")
                map, par = read_map_par(read_mode, Nfile, contour_files, contour_arr, contour_par_arr)

                if smooth_contour_file[Nfile]
                    println("smoothing")
                    map = smooth_map!(map, smooth_sizes[col], par)

                    println(maximum(map))
                end


                if isnothing(contour_levels)
                    ax.contour(map, colors = contour_color, linewidth = 1.2, linestyle = "--", alpha = alpha_contours[selected])
                else
                    ax.contour(map, contour_levels, colors = contour_color, linewidth = 1.2, linestyle = "--", alpha = alpha_contours[selected])
                end

                Ncontour += 1
            end

            if streamlines[selected]
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

            annotate_now = false

            if grid_direction == "column"
                if col == 1
                    annotate_now = true
                end
            else
                if i == 1
                    annotate_now = true
                end
            end
            if annotate_now

                map_x_pixels = size(map,2)

                pixelSideLength = (par.x_lim[2] - par.x_lim[1]) / map_x_pixels


                # annotate_arrows(ax, 1.0, 1.0, 300.0/4.0, 500.0/4.0, 
                # 		x_arrow_text[i], y_arrow_text[i], 200.0/4.0)

                if annotate_scale[i]
                    # annotate_scale(ax, par.Npixels[1], 1.0, 300.0/4.0, 1000.0/pixelSideLength, 
                    # 	L"1 \: h^{-1} c" * "Mpc", 500.0/4.0)

                    scale_annotation(ax, map_x_pixels, 1.0,map_x_pixels / 14, 
                        scale_kpc / pixelSideLength, 0.1,
                        scale_label,
                        map_x_pixels / 8,
                        annotation_color
                    )
                end

            end

            if annotate_time[Nfile]
                time_annotation(ax, 1.0, par.Npixels[1], 0.075 * par.Npixels[1],
                                time_labels[Nfile], annotation_color)
            end

            if annotate_text[Nfile]
                text_annotation(ax, par.Npixels[1], par.Npixels[1], 0.075 * par.Npixels[1],
                                text_labels[Nfile], annotation_color)
            end

            pixelSideLength = (par.x_lim[2] - par.x_lim[1]) / par.Npixels[1]

            if !isnothing(r_circles)
                ax.add_artist(plt.Circle((0.5par.Npixels[1], 0.5par.Npixels[2]), r_circles[1] / pixelSideLength,
                        color = "w", fill = false, ls = ":", alpha=0.5))
                ax.add_artist(plt.Circle((0.5par.Npixels[1], 0.5par.Npixels[2]), r_circles[1] / pixelSideLength,
                        color = "w", fill = false, ls = "--", alpha=0.5))
            end

            # draw smoothing beam
            if smooth_col[col] || smooth_contour_col[col] || annotate_smoothing[col]
                pixelSideLength = (par.x_lim[2] - par.x_lim[1]) / par.Npixels[1]
                smooth_pixel    = smooth_sizes[col] ./ pixelSideLength

                # ax.add_artist(matplotlib.patches.Rectangle((0.1par.Npixels[1] - 1.5*smooth_pixel[1],0.1par.Npixels[1] - 1.5*smooth_pixel[2]),           # anchor
                #                                             3*smooth_pixel[1], # width
                #                                             3*smooth_pixel[2], # height
                #                                             linewidth=1,edgecolor="gray",facecolor="gray"))

                ax.add_artist(matplotlib.patches.Ellipse((0.1par.Npixels[1], 0.1par.Npixels[2]), smooth_pixel[1], smooth_pixel[2],
                    color = "w", fill = true, ls = "-"))
            end

            ax.set_axis_off()

            if i == 1 || ((i == Nrows))

                # if colorbar_single
                #     if !(i == 1 || ((i == Nrows) && colorbar_bottom))
                #         Nfile += 1
                #         continue
                #     end
                #     #cax,kw = make_axes([grid[cax_i].cax for cax_i ∈ 1:Ncols])
                #     cb = colorbar(im, cax = grid[1], orientation = colorbar_orientation)
                # else
                    cb = colorbar(im, cax = grid[(col-1)*Nrows+1].cax, orientation = colorbar_orientation)
                    
                    if shift_colorbar_labels_inward[col]
                        shift_colorbar_label!(grid[(col-1)*Nrows+1].cax, "left")
                        shift_colorbar_label!(grid[(col-1)*Nrows+1].cax, "right")
                    end
                #end

                cb.set_label(cb_labels[selected], fontsize = axis_label_font_size)
                cb.ax.tick_params(
                    direction = "in",
                    which = "major",
                    labelsize = tick_label_size,
                    size = 6, width = 1
                )
                cb.ax.tick_params(
                    direction = "in",
                    which = "minor",
                    labelsize = tick_label_size,
                    size = 3, width = 1
                )
                # cb_ticks_styling!(cb.ax, color=ticks_color)


                if colorbar_location == "top"
                    grid[(col-1)*Nrows+1].cax.xaxis.set_ticks_position("top")
                    grid[(col-1)*Nrows+1].cax.xaxis.set_label_position("top")
                end


            end

            for spine in values(ax.spines)
                spine.set_edgecolor(ticks_color)
            end

            # count up file
            Nfile += 1
        end

    end

    @info "saving $plot_name"
    savefig(plot_name, bbox_inches = "tight", transparent=transparent)

    close(fig)

end