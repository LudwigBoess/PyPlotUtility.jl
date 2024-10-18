PE = pyimport("matplotlib.patheffects")

"""
    plot_image_grid(Nrows, Ncols, files, im_cmap, cb_labels, vmin_arr, vmax_arr, plot_name;
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
                                colorbar_bottom=false,
                                smooth_file = falses(Nrows*Ncols),
                                smooth_sizes = 0.0,
                                annotate_smoothing = falses(Nrows*Ncols),
                                smooth_col=falses(Nrows*Ncols),
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
                                circle_color = "w",
                                circle_alpha = 0.5,
                                circle_lines = [":", "--", "-.", "_"],
                                smooth_contour_col=falses(Nrows*Ncols),
                                shift_colorbar_labels_inward = trues(Nrows*Ncols),
                                upscale = Ncols,
                                read_mode = 1,
                                transparent = false,
                                ticks_color = "k",
                                annotation_color = "w",
                                colorbar_location="top",
                                colorbar_mode="edge",
                                grid_direction="column",
                                cb_label_offset=0.0,
                                dpi=400,
                                overplotting_functions=nothing
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

        for row = 1:Nrows

            @info "Column $col, Plot $row"

            ax = grid[(col-1)*Nrows+row]

            # read map and parameters
            map, par = read_map_par(read_mode, Nfile, files, map_arr, par_arr)

            println("Maximum value of map: ", maximum(map))
            println("Minimum value of map: ", minimum(map))

            if smooth_file[Nfile]
                map = smooth_map!(map, smooth_sizes[Nfile], par)
            end

            if smooth_col[col]
                map = smooth_map!(map, smooth_sizes[col], par)
            end

            if !isnothing(cutoffs)
                map[map.<cutoffs[col]] .= cutoffs[col]
                map[isnan.(map)] .= cutoffs[col]
                map[isinf.(map)] .= cutoffs[col]

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
                # if im_cmap[selected][end-1:end] == "_r"
                #     cmap.set_bad(cmap(vmin_arr[selected]))
                # else
                    cmap.set_bad(cmap(vmin_arr[selected]))
                #end
            end

            if log_map[selected]
                im = ax.imshow(map, norm=matplotlib.colors.LogNorm(vmin=vmin_arr[selected], vmax=vmax_arr[selected]),
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

                map, par = read_map_par(read_mode, Nfile, contour_files, contour_arr, contour_par_arr)

                if smooth_contour_file[Nfile]
                    map = smooth_map!(map, smooth_sizes[Nfile], par)
                end


                if isnothing(contour_levels)
                    ax.contour(map, colors = contour_color, linewidth = 1.2, linestyle = "--", alpha = alpha_contours[selected])
                else
                    map[map.<contour_levels[1]] .= contour_levels[1]
                    map[isnan.(map)] .= contour_levels[1]
                    map[isinf.(map)] .= contour_levels[1]
                    ax.contour(map, contour_levels, colors = contour_color, linewidth = 1.2, linestyle = "--", alpha = alpha_contours[selected])
                end

                Ncontour += 1
            end

            if streamlines[selected]
                @info "streamlines"
                image_name = streamline_files[Nfile]
                vx, par, snap_num, units = read_fits_image(image_name)
                image_name = streamline_files[Nfile+1]
                vy, par, snap_num, units = read_fits_image(image_name)

                x_grid = collect(1:par.Npixels[1])
                y_grid = collect(1:par.Npixels[1])

                ax.streamplot(x_grid, y_grid,
                    vy, vx,
                    density = 8,
                    color=(209 / 255, 209 / 255, 224 / 255, 0.7),
                    arrowsize = 0,
                    linewidth = 0.5
                    )

                Ncontour += 1
            end

            # additional overplotting by custom functions
            if !isnothing(overplotting_functions)
                overplotting_functions[Nfile](ax)
            end

            annotate_now = true

            # if grid_direction == "column"
            #     if col == 1
            #         annotate_now = true
            #     end
            # else
            #     if row == 1
            #         annotate_now = true
            #     end
            # end
            if annotate_now

                map_x_pixels = size(map,2)

                pixelSideLength = (par.x_lim[2] - par.x_lim[1]) / map_x_pixels


                # annotate_arrows(ax, 1.0, 1.0, 300.0/4.0, 500.0/4.0, 
                # 		x_arrow_text[i], y_arrow_text[i], 200.0/4.0)

                if annotate_scale[Nfile]
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
                        color = circle_color, fill = false, ls = ":", alpha=circle_alpha))
                ax.add_artist(plt.Circle((0.5par.Npixels[1], 0.5par.Npixels[2]), r_circles[2] / pixelSideLength,
                        color = circle_color, fill = false, ls = "--", alpha=circle_alpha))
                #ax = get_circle_contours(ax, r_circles, circle_labels, circle_alpha, circle_lines, par)
            end


            # draw smoothing beam
            if smooth_col[Nfile] || smooth_contour_col[col] || annotate_smoothing[col]
                pixelSideLength = (par.x_lim[2] - par.x_lim[1]) / par.Npixels[1]
                smooth_pixel = smooth_sizes[Nfile] ./ pixelSideLength

                ax.add_artist(matplotlib.patches.Ellipse((0.1par.Npixels[1], 0.1par.Npixels[2]), smooth_pixel[1], smooth_pixel[2],
                    color = "w", fill = true, ls = "-"))
            end

            ax.set_axis_off()

            # add colorbar
            if ((row == 1) && ((colorbar_location == "single") || (colorbar_location == "top"))) ||
               ((col == Ncols) && (colorbar_location == "right"))

                if colorbar_mode == "single"
                    if !(row == 1 || ((row == Nrows) && colorbar_bottom))
                        Nfile += 1
                        continue
                    end
                    cax = grid.cbar_axes[1]
                    cb = colorbar(im, cax=cax, orientation=colorbar_orientation)
                else
                    cax = grid[(col-1)*Nrows+1].cax
                    cb = colorbar(im, cax = cax, 
                                    orientation = colorbar_orientation)
                    
                    # println("shifting labels")
                    # if shift_colorbar_labels_inward[col]
                    #     shift_colorbar_label!(cax, "left")
                    #     shift_colorbar_label!(cax, "right")
                    # end
                    # if shift_colorbar_labels_inward[col]
                    #     shift_colorbar_label!(grid[(col-1)*Nrows+1].cax, "t")
                    #     shift_colorbar_label!(grid[(col-1)*Nrows+1].cax, "b")
                    # end
                end

                cb.set_label(cb_labels[selected], fontsize = axis_label_font_size)

                cb_ticks_styling!(cb, color=ticks_color)

                if log_map[selected] && colorbar_location != "right"
                    locmin = plt.LogLocator(base=10.0, subs=(0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9), numticks=20)
                    cb.ax.xaxis.set_minor_locator(locmin)
                    cb.ax.xaxis.set_minor_formatter(matplotlib.ticker.NullFormatter())

                    locmaj = matplotlib.ticker.LogLocator(base=10, numticks=12)
                    cb.ax.xaxis.set_major_locator(locmaj)
                end

                if colorbar_location == "top"
                    grid[(col-1)*Nrows+1].cax.xaxis.set_ticks_position("top")
                    grid[(col-1)*Nrows+1].cax.xaxis.set_label_position("top")
                    cax.xaxis.set_label_coords(0.5, 2.0 + cb_label_offset)
                end

                if colorbar_location == "right"
                    grid[(col-1)*Nrows+1].cax.yaxis.set_ticks_position("right")
                    grid[(col-1)*Nrows+1].cax.yaxis.set_label_position("right")
                    #cax.yaxis.set_label_coords(0.5, 2.0 + cb_label_offset)
                end

            end

            # count up file
            Nfile += 1
        end

    end



    @info "saving $plot_name"
    savefig(plot_name, bbox_inches = "tight", transparent=transparent, dpi=dpi)

    close(fig)

end