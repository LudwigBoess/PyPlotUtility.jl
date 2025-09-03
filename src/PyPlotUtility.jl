module PyPlotUtility

    using PyCall
    using PyPlot
    using SPHtoGrid
    using ProgressMeter
    using ImageFiltering
    
    # utility for plot-centered calculations
    include(joinpath("calc_utility", "bin_1D.jl"))
    include(joinpath("calc_utility", "bin_2D.jl"))
    # utility for plots
    include(joinpath("plot_utility", "annotations.jl"))
    include(joinpath("plot_utility", "colorbar.jl"))
    include(joinpath("plot_utility", "gridspec.jl"))
    include(joinpath("plot_utility", "imshow.jl"))
    include(joinpath("plot_utility", "linestyles.jl"))
    include(joinpath("plot_utility", "pcolormesh.jl"))
    include(joinpath("plot_utility", "plot_styling.jl"))
    include(joinpath("plot_utility", "streamlines.jl"))
    include(joinpath("plot_utility", "arrows.jl"))
    include(joinpath("plot_utility", "secondary_axis.jl"))
    include(joinpath("plot_utility", "allsky.jl"))
    include(joinpath("plot_utility", "image_grid", "utility.jl"))
    include(joinpath("plot_utility", "image_grid", "2rows.jl"))
    include(joinpath("plot_utility", "image_grid", "rows.jl"))
    include(joinpath("plot_utility", "image_grid", "columns.jl"))
    include(joinpath("plot_utility", "image_grid", "shared_colorbar.jl"))
    include(joinpath("plot_utility", "image_grid", "image_grid.jl"))

    export  axis_ticks_styling!, cb_ticks_styling!, plot_styling!,
            get_figure,
            get_z_secondary_axis!, get_cr_energy_axis!,
            get_gs,
            linestyle, ls,
            pixel_size,
            get_imshow, get_imshow_log,
            get_pcolormesh, get_pcolormesh_log,
            get_colorbar_top,
            get_colorbar_left,
            get_colorbar_right,
            shift_colorbar_label!,
            get_streamlines, get_arrows,
            bin_1D, bin_1D!, bin_1D_log, bin_1D_log!, bin_1D_quantity!, bin_1D_quantity_log!,
            bin_2D, bin_2D!, bin_2D_log, bin_2D_log!, bin_2D_quantity!, bin_2D_quantity_log!,
            propaganda_plot_columns,
            propaganda_plot_rows,
            propaganda_plot_double_row,
            plot_single_allsky,
            plot_multiple_allsky,
            plot_image_grid

end # module
