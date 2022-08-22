function plot_diffusion(path_in, snap_range, bins, plot_name)


    fig = figure(figsize=(6*upscale*Nbins, 6.5*upscale*Nfiles))
	grid = axes_grid1.ImageGrid(fig, 111,          # as in plt.subplot(111)
					nrows_ncols=(Nbins,Nfiles),
					axes_pad=0.0,
					direction="column",
					cbar_location="top",
					cbar_mode="single",
					cbar_size="2%",
                    label_mode="L",
					cbar_pad=0.0,
					)

    for col = 1:Nfiles

        fi = path_in * "snap_$(@sprintf("%03i", snap_range[col]))"
        #data = read_data_for_map(fi)
        h = read_header(fi)
        t = h.time * GU.t_Myr

		for i = 1:Nbins

			@info "Column $col, Plot $i"

			ax = grid[(col-1)*Nbins+i]
            axis_ticks_styling!(ax, color="white")

            ax.set_xlim(x_lim)
            ax.set_ylim(y_lim)

            if col != 1
                ax.set_yticklabels([])
            end
            if i != Nbins
                ax.set_xticklabels([])
            end

            ax.set_xlabel(L"x", fontsize=axis_label_font_size)
            ax.set_ylabel(L"y", fontsize=axis_label_font_size)

            # read map 
            image_name = path_in * "maps/snap_$(@sprintf("%03i", snap_range[col]))_bin_$(@sprintf("%03i", bins[i])).fits"
            map, par, snap_num, units = read_fits_image(image_name)

            # get colormap object
            cmap = plt.get_cmap("plasma")
            # set invalid pixels to white
            cmap.set_bad(cmap(c_lim[1]))

            im = ax.imshow(map, 
                    vmin=c_lim[1], vmax=c_lim[2], 
                    cmap = "plasma",
                    origin="lower",
                    extent= [x_lim[1],
                            x_lim[2],
                            y_lim[1],
                            y_lim[2]]
                        )

            cf = ax.contour(map,# vmin=c_lim[1], vmax=c_lim[2],
                    colors="white", 
                    #locator=matplotlib.ticker.LogLocator(base=10, numticks=6),
                    levels=c_lines,
                    linestyles="--",
                    origin="lower",
                    extent= [x_lim[1],
                            x_lim[2],
                            y_lim[1],
                            y_lim[2]])

            if ( i == 1 && col == 1)
                cb = colorbar(im, cax=grid.cbar_axes[1], orientation="horizontal")
                #cb = grid.cbar_axes[1].colorbar(im)
                cb.set_label("log " * L"E_{cr}", fontsize=axis_label_font_size)
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
                grid[1].cax.xaxis.set_ticks_position("top")
                grid[1].cax.xaxis.set_label_position("top")

                cb.add_lines(cf)
                for line ∈ cb.lines
                    line.set_linestyles(cf.linestyles)
                end
            end

            if col == 1
                ax.text(0.1, 0.1, "bin $(bins[i]-1)", color="white", fontsize=20, horizontalalignment="left", verticalalignment="bottom")
            end

            if i == 1
                ax.text(0.1, 0.9, "t = $(@sprintf("%0.2f", t)) Myrs", color="white", fontsize=20, horizontalalignment="left", verticalalignment="top")
            end
        end
    end    

    savefig(plot_name, bbox_inches="tight")
	close(fig)

end
