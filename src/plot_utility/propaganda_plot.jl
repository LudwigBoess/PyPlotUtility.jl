
function scale_annotation(ax, xmax, ymin, offset, length, width, scale_text, text_offset, fontsize=15)

	# Line 
	ax.arrow(xmax-length-offset, ymin+offset, length, 0.0, width = width, color="white", 
		 length_includes_head=true, head_width=0.0)

	# x label
	text_x = xmax-0.5*length-offset
	text_y = ymin+text_offset

	ax.text(text_x, text_y, scale_text, color="white", fontsize=fontsize, horizontalalignment="center", verticalalignment="center")
end


function time_annotation(ax, xmin, ymax, offset, z_text)

	# x label
	text_x = xmin+offset
	text_y = ymax-offset

	ax.text(text_x, text_y, z_text, color="white", fontsize=20, horizontalalignment="left", verticalalignment="top")
end


# """
#     propaganda_plot_columns(Nrows, Ncols, files, im_cmap, cb_labels, vmin_arr, vmax_arr, plot_name;
#                                 log_map=trues(Ncols),
#                                 smooth_col=falses(Ncols),
#                                 streamline_files=nothing,
#                                 streamlines=falses(Ncols),
#                                 contour_files=nothing,
#                                 contours=falses(Ncols),                     
#                                 contour_levels=nothing,
#                                 smooth_contour_col=falses(Ncols),
#                                 mask_bad=falses(Ncols),
#                                 bad_colors=["k" for _ in 1:Ncols],
#                                 annotate_time=falses(Nrows),
#                                 time_labels=nothing,
#                                 annotate_scale=trues(Nrows),
#                                 scale_label=L"1 \: h^{-1} c" * "Mpc",
#                                 scale_kpc=1000.0,
#                                 r_circle=0.0,
#                                 shift_colorbar_labels_inward=falses(Ncols),
#                                 upscale=2.0,
#                                 scale_pixel_offset=75.0,
#                                 scale_text_pixel_offset=125.0
#                                 )

# Creates an `image_grid` plot with `Ncols` and `Nrows` with colorbars on top.
# """
function propaganda_plot_columns(Nrows, Ncols, files, im_cmap, cb_labels, vmin_arr, vmax_arr, plot_name;
                                log_map=trues(Ncols),
                                smooth_col=falses(Ncols),
                                streamline_files=nothing,
                                streamlines=falses(Ncols),
                                contour_files=nothing,
                                contours=falses(Ncols),                     
                                contour_levels=nothing,
                                smooth_contour_col=falses(Ncols),
                                mask_bad=trues(Ncols),
                                bad_colors=["k" for _ in 1:Ncols],
                                annotate_time=falses(Nrows),
                                time_labels=nothing,
                                annotate_scale=trues(Nrows),
                                scale_label=L"1 \: h^{-1} c" * "Mpc",
                                scale_kpc=1000.0,
                                r_circle=0.0,
                                shift_colorbar_labels_inward=trues(Ncols),
                                upscale=Ncols+0.5,
                                scale_pixel_offset=75.0,
                                scale_text_pixel_offset=125.0,
								read_mode=1,
								image_num=ones(Int64,Ncols)
                                )

    axes_grid1 = pyimport("mpl_toolkits.axes_grid1")

	axis_label_font_size = 20
	legend_font_size = 20
	tick_label_size = 15
	rc("font", family="serif")
	rc("mathtext", fontset="stix")

	fig = figure(figsize=(6*upscale*Nrows, 6.5*upscale*Ncols))
	grid = axes_grid1.ImageGrid(fig, 111,          # as in plt.subplot(111)
					nrows_ncols=(Nrows,Ncols),
					axes_pad=0.0,
					direction="column",
					cbar_location="top",
					cbar_mode="edge",
					cbar_size="7%",
					cbar_pad=0.0,
					)

    Nfile = 1
    Ncontour = 1

	for col = 1:Ncols

		for i = 1:Nrows

			@info "Column $col, Plot $i"

			ax = grid[(col-1)*Nrows+i]

			image_name = files[Nfile]

			# read SPHtoGrid image
			if read_mode == 1
				map, par, snap_num, units = read_fits_image(image_name)

			# read Smac1 binary image
			elseif read_mode == 2
				map = read_smac1_binary_image(image_name)
				smac1_info = read_smac1_binary_info(image_name)
				smac1_center = [smac1_info.xcm, smac1_info.ycm, smac1_info.zcm] ./ 3.085678e21
				par = mappingParameters(center=smac1_center, 
										x_size=smac1_info.boxsize_kpc,
										y_size=smac1_info.boxsize_kpc,
										z_size=smac1_info.boxsize_kpc,
										Npixels=smac1_info.boxsize_pix)

			elseif read_mode == 3
				map = read_smac2_image(image_name, image_num[Nfile])
				par = read_smac2_info(image_name)
			end


			if smooth_col[col]
				map = imfilter(map, Kernel.gaussian(3))
			end

			if mask_bad[col]
				# get colormap object
				cmap = plt.get_cmap(im_cmap[col])
				# set invalid pixels to bad color
				cmap.set_bad(bad_colors[col])
			end

			if log_map[col]

				im = ax.imshow( map, norm=matplotlib.colors.LogNorm(),
                        vmin=vmin_arr[col], vmax=vmax_arr[col], 
                        cmap = im_cmap[col],
                        origin="lower"
                            )
			else
				im = ax.imshow( map,
                        vmin=vmin_arr[col], vmax=vmax_arr[col], 
                        cmap = im_cmap[col],
                        origin="lower"
                            )
			end

			if contours[col]
				image_name = contour_files[Nfile]
				
				if read_mode == 1
					map, par, snap_num, units = read_fits_image(image_name)

				# read Smac1 binary image
				elseif read_mode == 2
					map = read_smac1_binary_image(image_name)
					smac1_info = read_smac1_binary_info(image_name)
					smac1_center = [smac1_info.xcm, smac1_info.ycm, smac1_info.zcm] ./ 3.085678e21
					par = mappingParameters(center=smac1_center, 
											x_size=smac1_info.boxsize_kpc,
											y_size=smac1_info.boxsize_kpc,
											z_size=smac1_info.boxsize_kpc,
											Npixels=smac1_info.boxsize_pix)

				elseif read_mode == 3

					map = read_smac2_image(image_name, image_num[Nfile])
					par = read_smac2_info(image_name)

				end

				if smooth_contour_col[col]
					map = imfilter(map, Kernel.gaussian(3))
				end

				if isnothing(contour_levels)
					ax.contour(map, colors="white", linewidth=1.2, linestyle="--", alpha=0.8)
				else
					ax.contour(map, contour_levels, colors="white", linewidth=1.2, linestyle="--", alpha=0.8)
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

				ax.streamplot( x_grid, y_grid,
                            vx, vy, 
                            density = 2, 
                            color = "white"
                            )

                Ncontour += 1
			end

			if col == 1
				
				pixelSideLength = (par.x_lim[2] - par.x_lim[1])/par.Npixels[1]


				# annotate_arrows(ax, 1.0, 1.0, 300.0/4.0, 500.0/4.0, 
				# 		x_arrow_text[i], y_arrow_text[i], 200.0/4.0)
				
				if annotate_scale[i]
					# annotate_scale(ax, par.Npixels[1], 1.0, 300.0/4.0, 1000.0/pixelSideLength, 
					# 	L"1 \: h^{-1} c" * "Mpc", 500.0/4.0)

					scale_annotation(ax, par.Npixels[1], 1.0, scale_pixel_offset, scale_kpc/pixelSideLength, 0.1,
						scale_label, scale_text_pixel_offset)
				end

				if annotate_time[i]
					time_annotation(ax, 1.0, par.Npixels[1], 300.0/4.0, 
									  time_labels[i])
				end

				
			end

			pixelSideLength = (par.x_lim[2] - par.x_lim[1])/par.Npixels[1]
			ax.add_artist(plt.Circle( (0.5par.Npixels[1], 0.5par.Npixels[2]), r_circle/pixelSideLength, 
								color="w", fill=false, ls="--"))

			
			ax.set_axis_off()

			if i == 1
				cb = colorbar(im, cax=grid[(col-1)*Nrows+1].cax, orientation="horizontal")
				cb.set_label(cb_labels[col], fontsize=axis_label_font_size)
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
				grid[(col-1)*Nrows+1].cax.xaxis.set_ticks_position("top")
				grid[(col-1)*Nrows+1].cax.xaxis.set_label_position("top")

				if shift_colorbar_labels_inward[col]
					shift_colorbar_label!(grid[(col-1)*Nrows+1].cax, "left")
					shift_colorbar_label!(grid[(col-1)*Nrows+1].cax, "right")
				end
			end

            # count up file
            Nfile += 1
		end

	end

	@info "saving $plot_name"
	savefig(plot_name, bbox_inches="tight")

	close(fig)

end