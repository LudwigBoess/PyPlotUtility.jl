function scale_annotation(ax, xmax, ymin, offset, length, width, scale_text, text_offset, annotation_color, fontsize = 15)

    # Line 
    ax.arrow(xmax - length - offset, ymin + offset, length, 0.0, width = width, color = annotation_color,
        length_includes_head = true, head_width = 0.0)

    # x label
    text_x = xmax - 0.5 * length - offset
    text_y = ymin + text_offset

    ax.text(text_x, text_y, scale_text, color = annotation_color, fontsize = fontsize, horizontalalignment = "center", verticalalignment = "center")
end


function time_annotation(ax, xmin, ymax, offset, z_text, annotation_color)

    # x label
    text_x = xmin + offset
    text_y = ymax - offset

    ax.text(text_x, text_y, z_text, color = annotation_color, fontsize = 20, horizontalalignment = "left", verticalalignment = "top")
end


function text_annotation(ax, xmin, ymax, offset, z_text, annotation_color)

    # x label
    text_x = xmin - offset
    text_y = ymax - offset

    ax.text(text_x, text_y, z_text, color = annotation_color, fontsize = 20, horizontalalignment = "right", verticalalignment = "top")
end


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
function propaganda_plot_columns(Nrows, Ncols, files, im_cmap, cb_labels, vmin_arr, vmax_arr, plot_name;
                                map_arr = nothing, par_arr = nothing,
                                contour_arr = nothing, contour_par_arr = nothing,
                                log_map = trues(Ncols),
                                colorbar_bottom = false,
                                colorbar_single = false,
                                smooth_col = falses(Ncols),
                                smooth_sizes = 0.0,
                                annotate_smoothing = falses(Ncols),
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
                                scale_label = L"1 \: h^{-1} c" * "Mpc",
                                scale_kpc = 1000.0,
                                r_circles = nothing,
                                shift_colorbar_labels_inward = trues(Ncols),
                                upscale = Ncols + 0.5,
                                read_mode = 1,
                                image_num = ones(Int64, Ncols),
                                transparent = false,
                                ticks_color = "k"
                            )

    axes_grid1 = pyimport("mpl_toolkits.axes_grid1")

    axis_label_font_size = 20
    tick_label_size = 15

    fig = figure(figsize = (6 * upscale * Nrows, 6.5 * upscale * Ncols))
    plot_styling!(color=ticks_color)

    grid = axes_grid1.ImageGrid(fig, 111,          # as in plt.subplot(111)
        nrows_ncols = (Nrows, Ncols),
        axes_pad = 0.0,
        direction = "column",
        cbar_location = "top",
        cbar_mode = "edge",
        cbar_size = "7%",
        cbar_pad = 0.0,
    )

    Nfile = 1
    Ncontour = 1
    time_label_num = 1
    
    for col = 1:Ncols

        for i = 1:Nrows

            @info "Column $col, Plot $i"

            ax = grid[(col-1)*Nrows+i]

            if isnothing(map_arr)

                image_name = files[Nfile]

                # read SPHtoGrid image
                if read_mode == 1
                    map, par, snap_num, units = read_fits_image(image_name)

                    # read Smac1 binary image
                elseif read_mode == 2
                    map = read_smac1_binary_image(image_name)
                    smac1_info = read_smac1_binary_info(image_name)
                    smac1_center = [smac1_info.xcm, smac1_info.ycm, smac1_info.zcm]
                    par = mappingParameters(center = smac1_center,
                        x_size = smac1_info.boxsize_kpc,
                        y_size = smac1_info.boxsize_kpc,
                        z_size = smac1_info.boxsize_kpc,
                        Npixels = smac1_info.boxsize_pix)

                elseif read_mode == 3
                    map = read_smac2_image(image_name, image_num[Nfile])
                    par = read_smac2_info(image_name)
                end
            else
                map = map_arr[Nfile]
                par = par_arr[Nfile]
            end

            if smooth_col[col]
                pixelSideLength = (par.x_lim[2] - par.x_lim[1]) / par.Npixels[1]
                smooth_pixel = smooth_sizes[col] ./ pixelSideLength
                map = imfilter(map, reflect(Kernel.gaussian((smooth_pixel[1], smooth_pixel[2]), (par.Npixels[1] - 1, par.Npixels[1] - 1))))
            end

            if !isnothing(cutoffs)
                map[map.<cutoffs[Nfile]] .= NaN
            end

            if mask_bad[col]
                # get colormap object
                cmap = plt.get_cmap(im_cmap[col])
                # set invalid pixels to bad color
                cmap.set_bad(bad_colors[col])
            else
                # get colormap object
                cmap = plt.get_cmap(im_cmap[col])
                # set invalid pixels to minimum
                if im_cmap[col][end-1:end] == "_r"
                    cmap.set_bad(cmap(vmax_arr[col]))
                else
                    cmap.set_bad(cmap(vmin_arr[col]))
                end
            end

            if log_map[col]

                im = ax.imshow(map, norm = matplotlib.colors.LogNorm(),
                    vmin = vmin_arr[col], vmax = vmax_arr[col],
                    cmap = im_cmap[col],
                    origin = "lower"
                )
            else
                im = ax.imshow(map,
                    vmin = vmin_arr[col], vmax = vmax_arr[col],
                    cmap = im_cmap[col],
                    origin = "lower"
                )
            end

            if contours[col]
                image_name = contour_files[Nfile]

                if isnothing(contour_arr)
                    if read_mode == 1
                        map, par, snap_num, units = read_fits_image(image_name)

                        # read Smac1 binary image
                    elseif read_mode == 2
                        map = read_smac1_binary_image(image_name)
                        smac1_info = read_smac1_binary_info(image_name)
                        smac1_center = [smac1_info.xcm, smac1_info.ycm, smac1_info.zcm] ./ 3.085678e21
                        par = mappingParameters(center = smac1_center,
                            x_size = smac1_info.boxsize_kpc,
                            y_size = smac1_info.boxsize_kpc,
                            z_size = smac1_info.boxsize_kpc,
                            Npixels = smac1_info.boxsize_pix)

                    elseif read_mode == 3

                        map = read_smac2_image(image_name, image_num[Nfile])
                        par = read_smac2_info(image_name)

                    end
                else
                    map = contour_arr[Nfile]
                    par = contour_par_arr[Nfile]
                end

                if smooth_contour_col[col]
                    pixelSideLength = (par.x_lim[2] - par.x_lim[1]) / par.Npixels[1]
                    smooth_pixel    = smooth_sizes[col] ./ pixelSideLength
                    map = imfilter(map, reflect(Kernel.gaussian((smooth_pixel[1], smooth_pixel[2]), (par.Npixels[1] - 1, par.Npixels[1] - 1))))
                end

                if isnothing(contour_levels)
                    ax.contour(map, colors = contour_color, linewidth = 1.2, linestyle = "--", alpha = alpha_contours[col])
                else
                    ax.contour(map, contour_levels, colors = contour_color, linewidth = 1.2, linestyle = "--", alpha = alpha_contours[col])
                end

                Ncontour += 1
            end

            if streamlines[col]
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

                ax.add_artist(matplotlib.patches.Rectangle((0.1par.Npixels[1] - 1.5*smooth_pixel[1],0.1par.Npixels[1] - 1.5*smooth_pixel[2]),           # anchor
                                                            3*smooth_pixel[1], # width
                                                            3*smooth_pixel[2], # height
                                                            linewidth=1,edgecolor="gray",facecolor="gray"))

                ax.add_artist(matplotlib.patches.Ellipse((0.1par.Npixels[1], 0.1par.Npixels[2]), smooth_pixel[1], smooth_pixel[2],
                    color = "w", fill = true, ls = "-"))
            end

            ax.set_axis_off()

            if i == 1 || ((i == Nrows) && colorbar_bottom)

                if colorbar_single
                    if !(i == 1 || ((i == Nrows) && colorbar_bottom))
                        Nfile += 1
                        continue
                    end
                    #cax,kw = make_axes([grid[cax_i].cax for cax_i ∈ 1:Ncols])
                    cb = colorbar(im, cax = grid[1], orientation = "horizontal")
                else
                    cb = colorbar(im, cax = grid[(col-1)*Nrows+1].cax, orientation = "horizontal")
                end

                cb.set_label(cb_labels[col], fontsize = axis_label_font_size)
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


                grid[(col-1)*Nrows+1].cax.xaxis.set_ticks_position("top")
                grid[(col-1)*Nrows+1].cax.xaxis.set_label_position("top")

                if shift_colorbar_labels_inward[col]
                    shift_colorbar_label!(grid[(col-1)*Nrows+1].cax, "left")
                    shift_colorbar_label!(grid[(col-1)*Nrows+1].cax, "right")
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


"""
    propaganda_plot_rows(Nrows, Ncols, files, im_cmap, cb_labels, vmin_arr, vmax_arr, plot_name;
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
function propaganda_plot_rows(Nrows, Ncols, files, im_cmap, cb_labels, vmin_arr, vmax_arr, plot_name;
                                map_arr = nothing, par_arr = nothing,
                                contour_arr = nothing, contour_par_arr = nothing,
                                log_map = trues(Nrows),
                                colorbar_bottom = false,
                                colorbar_single = false,
                                smooth_row = falses(Nrows),
                                smooth_sizes = 0.0,
                                annotate_smoothing = falses(Nrows),
                                streamline_files = nothing,
                                streamlines = falses(Nrows),
                                contour_files = nothing,
                                contours = falses(Nrows),
                                contour_levels = nothing,
                                contour_color = "white",
                                smooth_contour_row = falses(Nrows),
                                alpha_contours = ones(Nrows),
                                cutoffs = nothing,
                                mask_bad = trues(Nrows),
                                bad_colors = ["k" for _ = 1:Nrows],
                                annotate_time = falses(Nrows * Ncols),
                                time_labels = nothing,
                                annotate_text = falses(Nrows * Ncols),
                                text_labels = nothing,
                                annotate_scale = trues(Nrows * Ncols),
                                annotation_color = "w",
                                scale_label = L"1 \: h^{-1} c" * "Mpc",
                                scale_kpc = 1000.0,
                                r_circles = nothing,
                                shift_colorbar_labels_inward = trues(Nrows),
                                upscale = Ncols + 0.5,
                                read_mode = 1,
                                image_num = ones(Int64, Nrows),
                                transparent = false,
                                ticks_color = "k"
                            )

    axes_grid1 = pyimport("mpl_toolkits.axes_grid1")

    axis_label_font_size = 20
    tick_label_size = 15

    fig = figure(figsize = (6 * upscale * Nrows, 6.5 * upscale * Ncols))
    plot_styling!(color=ticks_color)

    grid = axes_grid1.ImageGrid(fig, 111,          # as in plt.subplot(111)
        nrows_ncols = (Nrows, Ncols),
        axes_pad = 0.0,
        direction = "column",
        cbar_location = "right",
        cbar_mode = "edge",
        cbar_size = "7%",
        cbar_pad = 0.0,
    )

    Nfile = 1
    Ncontour = 1
    time_label_num = 1
    
    for i = 1:Nrows
        for col = 1:Ncols

            @info "Column $col, Plot $i"

            ax = grid[(col-1)*Nrows+i]

            if isnothing(map_arr)

                image_name = files[Nfile]

                # read SPHtoGrid image
                if read_mode == 1
                    map, par, snap_num, units = read_fits_image(image_name)

                    # read Smac1 binary image
                elseif read_mode == 2
                    map = read_smac1_binary_image(image_name)
                    smac1_info = read_smac1_binary_info(image_name)
                    smac1_center = [smac1_info.xcm, smac1_info.ycm, smac1_info.zcm]
                    par = mappingParameters(center = smac1_center,
                        x_size = smac1_info.boxsize_kpc,
                        y_size = smac1_info.boxsize_kpc,
                        z_size = smac1_info.boxsize_kpc,
                        Npixels = smac1_info.boxsize_pix)

                elseif read_mode == 3
                    map = read_smac2_image(image_name, image_num[Nfile])
                    par = read_smac2_info(image_name)
                end
            else
                map = map_arr[Nfile]
                par = par_arr[Nfile]
            end

            if smooth_row[i]
                pixelSideLength = (par.x_lim[2] - par.x_lim[1]) / par.Npixels[1]
                smooth_pixel = smooth_sizes[i] ./ pixelSideLength
                map = imfilter(map, reflect(Kernel.gaussian((smooth_pixel[1], smooth_pixel[2]), (par.Npixels[1] - 1, par.Npixels[1] - 1))))
            end

            if !isnothing(cutoffs)
                map[map.<cutoffs[Nfile]] .= NaN
            end

            if mask_bad[i]
                # get colormap object
                cmap = plt.get_cmap(im_cmap[i])
                # set invalid pixels to bad color
                cmap.set_bad(bad_colors[i])
            else
                # get colormap object
                cmap = plt.get_cmap(im_cmap[i])
                # set invalid pixels to minimum
                cmap.set_bad(cmap(vmin_arr[i]))
            end

            if log_map[i]

                im = ax.imshow(map, norm = matplotlib.colors.LogNorm(),
                    vmin = vmin_arr[i], vmax = vmax_arr[i],
                    cmap = im_cmap[i],
                    origin = "lower"
                )
            else
                im = ax.imshow(map,
                    vmin = vmin_arr[i], vmax = vmax_arr[i],
                    cmap = im_cmap[i],
                    origin = "lower"
                )
            end

            if contours[i]
                image_name = contour_files[Nfile]

                if isnothing(contour_arr)
                    if read_mode == 1
                        map, par, snap_num, units = read_fits_image(image_name)

                        # read Smac1 binary image
                    elseif read_mode == 2
                        map = read_smac1_binary_image(image_name)
                        smac1_info = read_smac1_binary_info(image_name)
                        smac1_center = [smac1_info.xcm, smac1_info.ycm, smac1_info.zcm] ./ 3.085678e21
                        par = mappingParameters(center = smac1_center,
                            x_size = smac1_info.boxsize_kpc,
                            y_size = smac1_info.boxsize_kpc,
                            z_size = smac1_info.boxsize_kpc,
                            Npixels = smac1_info.boxsize_pix)

                    elseif read_mode == 3

                        map = read_smac2_image(image_name, image_num[Nfile])
                        par = read_smac2_info(image_name)

                    end
                else
                    map = contour_arr[Nfile]
                    par = contour_par_arr[Nfile]
                end

                if smooth_contour_row[i]
                    pixelSideLength = (par.x_lim[2] - par.x_lim[1]) / par.Npixels[1]
                    smooth_pixel    = smooth_sizes[i] ./ pixelSideLength
                    map = imfilter(map, reflect(Kernel.gaussian((smooth_pixel[1], smooth_pixel[2]), (par.Npixels[1] - 1, par.Npixels[1] - 1))))
                end

                if isnothing(contour_levels)
                    ax.contour(map, colors = contour_color, linewidth = 1.2, linestyle = "--", alpha = alpha_contours[i])
                else
                    ax.contour(map, contour_levels, colors = contour_color, linewidth = 1.2, linestyle = "--", alpha = alpha_contours[i])
                end

                Ncontour += 1
            end

            if streamlines[i]
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

                if annotate_scale[i]
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
            if smooth_row[i] || smooth_contour_row[i] || annotate_smoothing[i]
                pixelSideLength = (par.x_lim[2] - par.x_lim[1]) / par.Npixels[1]
                smooth_pixel    = smooth_sizes[i] ./ pixelSideLength

                ax.add_artist(matplotlib.patches.Rectangle((0.1par.Npixels[1] - 1.5*smooth_pixel[1],0.1par.Npixels[1] - 1.5*smooth_pixel[2]),           # anchor
                                                            3*smooth_pixel[1], # width
                                                            3*smooth_pixel[2], # height
                                                            linewidth=1,edgecolor="gray",facecolor="gray"))

                ax.add_artist(matplotlib.patches.Ellipse((0.1par.Npixels[1], 0.1par.Npixels[2]), smooth_pixel[1], smooth_pixel[2],
                    color = "w", fill = true, ls = "-"))
            end

            ax.set_axis_off()

            if col == Ncols

                if colorbar_single
                    # if !(i == 1 || ((i == Nrows) && colorbar_bottom))
                    #     Nfile += 1
                    #     continue
                    # end
                    # #cax,kw = make_axes([grid[cax_i].cax for cax_i ∈ 1:Ncols])
                    # cb = colorbar(im, cax = grid[1])
                else
                    cb = colorbar(im, cax = grid[i+Ncols-1].cax)
                end

                cb.set_label(cb_labels[i], fontsize = axis_label_font_size)
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


                if shift_colorbar_labels_inward[i]
                    shift_colorbar_label!(grid[i+Ncols-1].cax, "bottom")
                    shift_colorbar_label!(grid[i+Ncols-1].cax, "top")
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

            if isnothing(map_arr)

                image_name = files[Nfile]

                # read SPHtoGrid image
                if read_mode == 1
                    map, par, snap_num, units = read_fits_image(image_name)

                    # read Smac1 binary image
                elseif read_mode == 2
                    map = read_smac1_binary_image(image_name)
                    smac1_info = read_smac1_binary_info(image_name)
                    smac1_center = [smac1_info.xcm, smac1_info.ycm, smac1_info.zcm] ./ 3.085678e21
                    par = mappingParameters(center = smac1_center,
                        x_size = smac1_info.boxsize_kpc,
                        y_size = smac1_info.boxsize_kpc,
                        z_size = smac1_info.boxsize_kpc,
                        Npixels = smac1_info.boxsize_pix)

                elseif read_mode == 3
                    map = read_smac2_image(image_name, image_num[Nfile])
                    par = read_smac2_info(image_name)
                end
            else
                map = map_arr[Nfile]
                par = par_arr[Nfile]
            end

            if smooth_file[Nfile]
                pixelSideLength = (par.x_lim[2] - par.x_lim[1]) / par.Npixels[1]
                smooth_pixel    = smooth_sizes[Nfile] ./ pixelSideLength
                map = imfilter(map, reflect(Kernel.gaussian((smooth_pixel[1], smooth_pixel[2]), (par.Npixels[1] - 1, par.Npixels[1] - 1))))
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
                image_name = contour_files[Nfile]

                if isnothing(contour_arr)
                    if read_mode == 1
                        map, par, snap_num, units = read_fits_image(image_name)

                        # read Smac1 binary image
                    elseif read_mode == 2
                        map = read_smac1_binary_image(image_name)
                        smac1_info = read_smac1_binary_info(image_name)
                        smac1_center = [smac1_info.xcm, smac1_info.ycm, smac1_info.zcm] ./ 3.085678e21
                        par = mappingParameters(center = smac1_center,
                            x_size = smac1_info.boxsize_kpc,
                            y_size = smac1_info.boxsize_kpc,
                            z_size = smac1_info.boxsize_kpc,
                            Npixels = smac1_info.boxsize_pix)

                    elseif read_mode == 3

                        map = read_smac2_image(image_name, image_num[Nfile])
                        par = read_smac2_info(image_name)

                    end
                else
                    map = contour_arr[Nfile]
                    par = contour_par_arr[Nfile]
                end

                if smooth_contour_file[Nfile]
                    #println("smooth size = $smooth_size kpc")
                    pixelSideLength = (par.x_lim[2] - par.x_lim[1]) / par.Npixels[1]
                    smooth_pixel    = smooth_sizes[Nfile] ./ pixelSideLength
                    #println("smooth size = $smooth_size pix")
                    map = imfilter(map, reflect(Kernel.gaussian((smooth_pixel[1], smooth_pixel[2]), (par.Npixels[1] - 1, par.Npixels[1] - 1))))
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