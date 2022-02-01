var documenterSearchIndex = {"docs":
[{"location":"propaganda_plot/","page":"Propaganda Plots","title":"Propaganda Plots","text":"CurrentModule = PyPlotUtility\nDocTestSetup = quote\n    using PyPlotUtility\nend","category":"page"},{"location":"propaganda_plot/#Propaganda-Plot","page":"Propaganda Plots","title":"Propaganda Plot","text":"","category":"section"},{"location":"propaganda_plot/","page":"Propaganda Plots","title":"Propaganda Plots","text":"I like to make paneled imshow plots. This is a bit of a pain to do every time, so I tried to introduce a kind of Swiss Army Knife plotting function for streamlining this. You can find an example of this e.g. in Steinwandel, Böss, et al (2021).","category":"page"},{"location":"propaganda_plot/","page":"Propaganda Plots","title":"Propaganda Plots","text":"(Image: Propaganda Examples)","category":"page"},{"location":"propaganda_plot/","page":"Propaganda Plots","title":"Propaganda Plots","text":"propaganda_plot_columns","category":"page"},{"location":"propaganda_plot/#PyPlotUtility.propaganda_plot_columns","page":"Propaganda Plots","title":"PyPlotUtility.propaganda_plot_columns","text":"propaganda_plot_columns(Nrows, Ncols, files, im_cmap, cb_labels, vmin_arr, vmax_arr, plot_name;\n                        map_arr = nothing, par_arr = nothing,\n                        contour_arr = nothing, contour_par_arr = nothing,\n                        log_map = trues(Ncols),\n                        colorbar_bottom = false,\n                        colorbar_single = false,\n                        smooth_col = falses(Ncols),\n                        smooth_size = 0.0,\n                        streamline_files = nothing,\n                        streamlines = falses(Ncols),\n                        contour_files = nothing,\n                        contours = falses(Ncols),\n                        contour_levels = nothing,\n                        contour_color = \"white\",\n                        smooth_contour_col = falses(Ncols),\n                        alpha_contours = ones(Ncols),\n                        cutoffs = nothing,\n                        mask_bad = trues(Ncols),\n                        bad_colors = [\"k\" for _ = 1:Ncols],\n                        annotate_time = falses(Nrows * Ncols),\n                        time_labels = nothing,\n                        annotate_text = falses(Nrows * Ncols),\n                        text_labels = nothing,\n                        annotate_scale = trues(Nrows * Ncols),\n                        scale_label = L\"1 \\: h^{-1} c\" * \"Mpc\",\n                        scale_kpc = 1000.0,\n                        r_circles = [0.0, 0.0],\n                        shift_colorbar_labels_inward = trues(Ncols),\n                        upscale = Ncols + 0.5,\n                        read_mode = 1,\n                        image_num = ones(Int64, Ncols)\n                        )\n\nCreates an image_grid plot with Ncols and Nrows with colorbars on top.\n\n\n\n\n\n","category":"function"},{"location":"install/#Install","page":"Install","title":"Install","text":"","category":"section"},{"location":"install/","page":"Install","title":"Install","text":"As usual with Julia just run","category":"page"},{"location":"install/","page":"Install","title":"Install","text":"] add https://github.com/LudwigBoess/PyPlotUtility.jl","category":"page"},{"location":"calc_utility/","page":"Calculation Utility","title":"Calculation Utility","text":"CurrentModule = PyPlotUtility\nDocTestSetup = quote\n    using PyPlotUtility\nend","category":"page"},{"location":"calc_utility/#Binning","page":"Calculation Utility","title":"Binning","text":"","category":"section"},{"location":"calc_utility/#D","page":"Calculation Utility","title":"1D","text":"","category":"section"},{"location":"calc_utility/","page":"Calculation Utility","title":"Calculation Utility","text":"bin_1D","category":"page"},{"location":"calc_utility/#PyPlotUtility.bin_1D","page":"Calculation Utility","title":"PyPlotUtility.bin_1D","text":"bin_1D( quantity, bin_lim; \n        calc_mean::Bool=true, Nbins::Int=100,\n        show_progress::Bool=true)\n\nGet a 1D histogram of quantity in the limits bin_lim, over a number if bins Nbins. If calc_mean is set to true it will calculate the mean of the quantity per bin, otherwise the sum is returned.\n\n\n\n\n\n","category":"function"},{"location":"calc_utility/","page":"Calculation Utility","title":"Calculation Utility","text":"bin_1D!","category":"page"},{"location":"calc_utility/#PyPlotUtility.bin_1D!","page":"Calculation Utility","title":"PyPlotUtility.bin_1D!","text":"bin_1D!(count, quantity, bin_lim; \n        Nbins::Int=100, show_progress::Bool=true)\n\nGet a 1D histogram of quantity in the limits bin_lim, over a number if bins Nbins for pre-allocated arrays count and quantity_count. Should be used if computing a 1D histogram over multiple files.\n\n\n\n\n\n","category":"function"},{"location":"calc_utility/","page":"Calculation Utility","title":"Calculation Utility","text":"bin_1D_quantity!","category":"page"},{"location":"calc_utility/#PyPlotUtility.bin_1D_quantity!","page":"Calculation Utility","title":"PyPlotUtility.bin_1D_quantity!","text":"bin_1D_quantity!(count, quantity_count, \n                 quantity, bin_lim; \n                 Nbins::Int=100, show_progress::Bool=true)\n\nGet a 1D histogram of quantity in the limits bin_lim, over a number if bins Nbins for pre-allocated arrays count and quantity_count. Should be used if computing the mean over multiple files.\n\n\n\n\n\n","category":"function"},{"location":"calc_utility/","page":"Calculation Utility","title":"Calculation Utility","text":"bin_1D_log","category":"page"},{"location":"calc_utility/#PyPlotUtility.bin_1D_log","page":"Calculation Utility","title":"PyPlotUtility.bin_1D_log","text":"bin_1D_log( quantity, bin_lim; \n            calc_mean::Bool=true, Nbins::Int=100,\n            show_progress::Bool=true)\n\nGet a 1D histogram of quantity in the limits bin_lim, over a number if bins Nbins in log-space for pre-allocated arrays count and quantity_count. If calc_mean is set to true it will calculate the mean of the quantity per bin, otherwise the sum is returned.\n\n\n\n\n\n","category":"function"},{"location":"calc_utility/","page":"Calculation Utility","title":"Calculation Utility","text":"bin_1D_log!","category":"page"},{"location":"calc_utility/#PyPlotUtility.bin_1D_log!","page":"Calculation Utility","title":"PyPlotUtility.bin_1D_log!","text":"bin_1D_log!(count, quantity, bin_lim; \n            Nbins::Int=100, show_progress::Bool=true)\n\nGet a 1D histogram of quantity in the limits bin_lim, over a number if bins Nbins in log-space for pre-allocated arrays count and quantity_count. Should be used if computing a 1D histogram over multiple files.\n\n\n\n\n\n","category":"function"},{"location":"calc_utility/","page":"Calculation Utility","title":"Calculation Utility","text":"bin_1D_quantity_log!","category":"page"},{"location":"calc_utility/#PyPlotUtility.bin_1D_quantity_log!","page":"Calculation Utility","title":"PyPlotUtility.bin_1D_quantity_log!","text":"bin_1D_quantity_log!(count, quantity_count, \n                     quantity, bin_lim; \n                     Nbins::Int=100, show_progress::Bool=true)\n\nGet a 1D histogram of quantity in the limits bin_lim, over a number if bins Nbins in log-space for pre-allocated arrays count and quantity_count. Should be used if computing the mean over multiple files.\n\n\n\n\n\n","category":"function"},{"location":"calc_utility/","page":"Calculation Utility","title":"Calculation Utility","text":"σ_1D_quantity","category":"page"},{"location":"calc_utility/#PyPlotUtility.σ_1D_quantity","page":"Calculation Utility","title":"PyPlotUtility.σ_1D_quantity","text":"σ_1D_quantity(quantity_sum, bin_count)\n\nCompute the standard deviation per bin. From: https://math.stackexchange.com/questions/198336/how-to-calculate-standard-deviation-with-streaming-inputs\n\n\n\n\n\n","category":"function"},{"location":"calc_utility/#D-2","page":"Calculation Utility","title":"2D","text":"","category":"section"},{"location":"calc_utility/","page":"Calculation Utility","title":"Calculation Utility","text":"bin_2D","category":"page"},{"location":"calc_utility/#PyPlotUtility.bin_2D","page":"Calculation Utility","title":"PyPlotUtility.bin_2D","text":"bin_2D( x_q, y_q, x_lim, y_lim, bin_q=nothing; \n        calc_mean::Bool=true, Nbins::Int=100,\n        show_progress::Bool=true)\n\nGet a 2D histogram of x_q and y_q in the limits x_lim, y_lim over a number if bins Nbins. If you want to bin an additional quantity bin_q you can pass it as an optional argument.  If calc_mean is set to true it will calculate the mean of the quantity per bin, otherwise the sum is returned.\n\n\n\n\n\n","category":"function"},{"location":"calc_utility/","page":"Calculation Utility","title":"Calculation Utility","text":"bin_2D!","category":"page"},{"location":"calc_utility/#PyPlotUtility.bin_2D!","page":"Calculation Utility","title":"PyPlotUtility.bin_2D!","text":"bin_2D!( phase_map_count,  \n         x_q, y_q, x_lim, y_lim; \n         Nbins::Int=100,\n         show_progress::Bool=true)\n\nGet a 2D histogram of x_q and y_q in the limits x_lim, y_lim over a number if bins Nbins for pre-allocated array phase_map_count. Should be used if computing a 2D phase map over multiple files.\n\n\n\n\n\n","category":"function"},{"location":"calc_utility/","page":"Calculation Utility","title":"Calculation Utility","text":"bin_2D_quantity!","category":"page"},{"location":"calc_utility/#PyPlotUtility.bin_2D_quantity!","page":"Calculation Utility","title":"PyPlotUtility.bin_2D_quantity!","text":"bin_2D_quantity!( phase_map_count, phase_map, \n                  x_q, y_q, bin_q, x_lim, y_lim; \n                  Nbins::Int=100,\n                  show_progress::Bool=true )\n\nGet a 2D histogram of x_q and y_q in the limits x_lim, y_lim over a number of bins Nbins for pre-allocated arrays phase_map_count and phase_map. Should be used if computing a 2D phase map over multiple files.\n\n\n\n\n\n","category":"function"},{"location":"calc_utility/","page":"Calculation Utility","title":"Calculation Utility","text":"bin_2D_log","category":"page"},{"location":"calc_utility/#PyPlotUtility.bin_2D_log","page":"Calculation Utility","title":"PyPlotUtility.bin_2D_log","text":"bin_2D_log( x_q, y_q, x_lim, y_lim, bin_q=nothing; \n        calc_mean::Bool=true, Nbins::Int=100,\n        show_progress::Bool=true)\n\nGet a 2D histogram of x_q and y_q in the limits x_lim, y_lim over a number if bins Nbins in log-space. If you want to bin an additional quantity bin_q you can pass it as an optional argument.  If calc_mean is set to true it will calculate the mean of the quantity per bin, otherwise the sum is returned.\n\n\n\n\n\n","category":"function"},{"location":"calc_utility/","page":"Calculation Utility","title":"Calculation Utility","text":"bin_2D_log!","category":"page"},{"location":"calc_utility/#PyPlotUtility.bin_2D_log!","page":"Calculation Utility","title":"PyPlotUtility.bin_2D_log!","text":"bin_2D_log!( phase_map_count,  \n             x_q, y_q, x_lim, y_lim; \n             Nbins::Int=100,\n            show_progress::Bool=true)\n\nGet a 2D histogram of x_q and y_q in the limits x_lim, y_lim over a number if bins Nbins in log-space for pre-allocated array phase_map_count. Should be used if computing a 2D phase map over multiple files.\n\n\n\n\n\n","category":"function"},{"location":"calc_utility/","page":"Calculation Utility","title":"Calculation Utility","text":"bin_2D_quantity_log!","category":"page"},{"location":"calc_utility/#PyPlotUtility.bin_2D_quantity_log!","page":"Calculation Utility","title":"PyPlotUtility.bin_2D_quantity_log!","text":"bin_2D_quantity_log!( phase_map_count, phase_map, \n                      x_q, y_q, bin_q, x_lim, y_lim; \n                      Nbins::Int=100,\n                      show_progress::Bool=true)\n\nGet a 2D histogram of x_q and y_q in the limits x_lim, y_lim over a number if bins Nbins in log-space for pre-allocated arrays phase_map_count and phase_map. Should be used if computing a 2D phase map over multiple files.\n\n\n\n\n\n","category":"function"},{"location":"","page":"Table of Contents","title":"Table of Contents","text":"CurrentModule = PyPlotUtility\nDocTestSetup = quote\n    using PyPlotUtility\nend","category":"page"},{"location":"#PyPlotUtility.jl","page":"Table of Contents","title":"PyPlotUtility.jl","text":"","category":"section"},{"location":"","page":"Table of Contents","title":"Table of Contents","text":"This package provides a number of efficiency models for Diffuse Shock Acceleration (DSA). It provides a number of functions to calculate what fraction of the energy dissipated at a shock is used to accelerate Cosmic Rays (CRs).","category":"page"},{"location":"#Example","page":"Table of Contents","title":"Example","text":"","category":"section"},{"location":"","page":"Table of Contents","title":"Table of Contents","text":"using PyPlot, PyPlotUtility\n\nfig = get_figure()\nplot_styling!()\n\nax = gca()\naxis_ticks_styling!(ax)\nax.set_xlim([0.0, 1.0])\nax.set_ylim([0.0, 1.0])\nax.set_xlabel(\"x\")\nax.set_ylabel(\"y\")\n\nplot(rand(10), rand(10), label=\"example\")\n\nlegend(frameon=false)\n\nsavefig(\"example.png\", bbox_inches=\"tight\")","category":"page"},{"location":"","page":"Table of Contents","title":"Table of Contents","text":"(Image: example)","category":"page"},{"location":"#Table-of-contents","page":"Table of Contents","title":"Table of contents","text":"","category":"section"},{"location":"","page":"Table of Contents","title":"Table of Contents","text":"Pages = [ \"index.md\", \n          \"install.md\", \n          \"plot_utility.md\",\n          \"calc_utility.md\", \n          \"propaganda_plot.md\"]\nDepth = 3","category":"page"},{"location":"plot_utility/","page":"Plot Utility","title":"Plot Utility","text":"CurrentModule = PyPlotUtility\nDocTestSetup = quote\n    using PyPlotUtility\nend","category":"page"},{"location":"plot_utility/#Plot-Styling","page":"Plot Utility","title":"Plot Styling","text":"","category":"section"},{"location":"plot_utility/","page":"Plot Utility","title":"Plot Utility","text":"get_figure","category":"page"},{"location":"plot_utility/#PyPlotUtility.get_figure","page":"Plot Utility","title":"PyPlotUtility.get_figure","text":"get_figure(aspect_ratio::Float64=1.1; x_pixels::Int64=600)\n\nGet a Figure object with a given aspect ratio for a fixed number of pixels in x-diretion.\n\n\n\n\n\n","category":"function"},{"location":"plot_utility/","page":"Plot Utility","title":"Plot Utility","text":"plot_styling!","category":"page"},{"location":"plot_utility/#PyPlotUtility.plot_styling!","page":"Plot Utility","title":"PyPlotUtility.plot_styling!","text":"plot_styling!(;axis_label_font_size::Int64=20,\n                    legend_font_size::Int64=15,\n                    tick_label_size::Int64=15)\n\nLMB default plot styling\n\n\n\n\n\n","category":"function"},{"location":"plot_utility/","page":"Plot Utility","title":"Plot Utility","text":"axis_ticks_styling!","category":"page"},{"location":"plot_utility/#PyPlotUtility.axis_ticks_styling!","page":"Plot Utility","title":"PyPlotUtility.axis_ticks_styling!","text":"axis_ticks_styling!(ax::PyCall.PyObject; size_minor_ticks::Int64=6, \n                    width_minor_ticks::Int64=1, major_tick_width_scale::Int64=1,\n                    tick_label_size::Int64=15, color::String=\"k\")\n\nLMB default axis tick styling.\n\n\n\n\n\n","category":"function"},{"location":"plot_utility/","page":"Plot Utility","title":"Plot Utility","text":"cb_ticks_styling!","category":"page"},{"location":"plot_utility/#PyPlotUtility.cb_ticks_styling!","page":"Plot Utility","title":"PyPlotUtility.cb_ticks_styling!","text":"cb_ticks_styling!(ax::PyCall.PyObject; size_minor_ticks::Int64=6, \n                    width_minor_ticks::Int64=1, major_tick_width_scale::Int64=1,\n                    tick_label_size::Int64=15, color::String=\"k\")\n\nLMB default colorbar tick styling.\n\n\n\n\n\n","category":"function"},{"location":"plot_utility/","page":"Plot Utility","title":"Plot Utility","text":"pixel_size","category":"page"},{"location":"plot_utility/#PyPlotUtility.pixel_size","page":"Plot Utility","title":"PyPlotUtility.pixel_size","text":"pixel_size(fig::Figure)\n\nHelper function to get markers with size 1 pixel.\n\n\n\n\n\n","category":"function"},{"location":"plot_utility/#Linestyles","page":"Plot Utility","title":"Linestyles","text":"","category":"section"},{"location":"plot_utility/","page":"Plot Utility","title":"Plot Utility","text":"linestyle","category":"page"},{"location":"plot_utility/#PyPlotUtility.linestyle","page":"Plot Utility","title":"PyPlotUtility.linestyle","text":"linestyle(sequence::String=\"\";\n               dash::Real=3.7, dot::Real=1.0, space::Real=3.7,\n               buffer::Bool=false, offset::Int=0)\n\nGet custom IDL-like linestyles. sequence has to be an even number of entries.\n\nKeyword Arguments\n\ndash::Real=3.7: Size of dash.\ndot::Real=1.0: Size of dot.\nspace::Real=3.7: Size of space.\nbuffer::Bool=false: Whether to add a buffer to the end of the sequence.\noffset::Int=0: No clue.\n\n\n\n\n\n","category":"function"},{"location":"plot_utility/","page":"Plot Utility","title":"Plot Utility","text":"ls","category":"page"},{"location":"plot_utility/#PyPlotUtility.ls","page":"Plot Utility","title":"PyPlotUtility.ls","text":"ls(sequence::String=\"\";\n   dash::Real=3.7, dot::Real=1.0, space::Real=3.7,\n   buffer::Bool=false, offset::Int=0)\n\nGet custom IDL-like linestyles. sequence has to be an even number of entries. See also linestyle\n\n\n\n\n\n","category":"function"},{"location":"plot_utility/#Colorbars","page":"Plot Utility","title":"Colorbars","text":"","category":"section"},{"location":"plot_utility/","page":"Plot Utility","title":"Plot Utility","text":"get_colorbar_top","category":"page"},{"location":"plot_utility/#PyPlotUtility.get_colorbar_top","page":"Plot Utility","title":"PyPlotUtility.get_colorbar_top","text":"get_colorbar_top(ax::PyCall.PyObject, im::PyCall.PyObject, \n                 label::AbstractString, \n                 axis_label_font_size::Integer, \n                 tick_label_size::Integer)\n\nReturns a colorbar at the top of a plot.\n\n\n\n\n\n","category":"function"},{"location":"plot_utility/","page":"Plot Utility","title":"Plot Utility","text":"get_colorbar_left","category":"page"},{"location":"plot_utility/#PyPlotUtility.get_colorbar_left","page":"Plot Utility","title":"PyPlotUtility.get_colorbar_left","text":"get_colorbar_left(ax::PyCall.PyObject, im::PyCall.PyObject, \n                 label::AbstractString, \n                 axis_label_font_size::Integer, \n                 tick_label_size::Integer)\n\nReturns a colorbar at the left of a plot.\n\n\n\n\n\n","category":"function"},{"location":"plot_utility/","page":"Plot Utility","title":"Plot Utility","text":"get_colorbar_right","category":"page"},{"location":"plot_utility/#PyPlotUtility.get_colorbar_right","page":"Plot Utility","title":"PyPlotUtility.get_colorbar_right","text":"get_colorbar_right(ax::PyCall.PyObject, im::PyCall.PyObject, \n                 label::AbstractString, \n                 axis_label_font_size::Integer, \n                 tick_label_size::Integer)\n\nReturns a colorbar at the right of a plot.\n\n\n\n\n\n","category":"function"},{"location":"plot_utility/","page":"Plot Utility","title":"Plot Utility","text":"shift_colorbar_label!","category":"page"},{"location":"plot_utility/#PyPlotUtility.shift_colorbar_label!","page":"Plot Utility","title":"PyPlotUtility.shift_colorbar_label!","text":"shift_colorbar_label!(cax1::PyCall.PyObject, shift::String)\n\nShift a colorbar label at the left [\"left\", \"l\"] of the colorbar to the right, or vice versa with [\"right\", \"r\"].\n\n\n\n\n\n","category":"function"},{"location":"plot_utility/#Gridspec","page":"Plot Utility","title":"Gridspec","text":"","category":"section"},{"location":"plot_utility/","page":"Plot Utility","title":"Plot Utility","text":"get_gs","category":"page"},{"location":"plot_utility/#PyPlotUtility.get_gs","page":"Plot Utility","title":"PyPlotUtility.get_gs","text":"get_gs(gs::PyObject, row, col)\n\nHelper function to get the correct gridspec panel for a given (range of) row and col.\n\n\n\n\n\n","category":"function"},{"location":"plot_utility/","page":"Plot Utility","title":"Plot Utility","text":"slice","category":"page"},{"location":"plot_utility/#PyPlotUtility.slice","page":"Plot Utility","title":"PyPlotUtility.slice","text":"slice(rng::UnitRange)\n\nHelper function to convert Julia UnitRange to Python slice.\n\n\n\n\n\n","category":"function"},{"location":"plot_utility/#imshow","page":"Plot Utility","title":"imshow","text":"","category":"section"},{"location":"plot_utility/","page":"Plot Utility","title":"Plot Utility","text":"get_imshow","category":"page"},{"location":"plot_utility/#PyPlotUtility.get_imshow","page":"Plot Utility","title":"PyPlotUtility.get_imshow","text":"get_imshow(ax::PyCall.PyObject, image::Array{<:Real}, \n                x_lim::Array{<:Real}=zeros(2), y_lim::Array{<:Real}=zeros(2), \n                vmin::Real=0.0, vmax::Real=0.0; \n                cmap::String=\"viridis\", cnorm=matplotlib.colors.NoNorm(),\n                ticks_color::String=\"white\",\n                interpolation::String=\"none\")\n\nHelper function to plot an imshow with linear colorbar.\n\n\n\n\n\n","category":"function"},{"location":"plot_utility/","page":"Plot Utility","title":"Plot Utility","text":"get_imshow_log","category":"page"},{"location":"plot_utility/#PyPlotUtility.get_imshow_log","page":"Plot Utility","title":"PyPlotUtility.get_imshow_log","text":"get_imshow_log(ax::PyCall.PyObject, image::Array{<:Real}, \n               x_lim::Array{<:Real}=zeros(2), y_lim::Array{<:Real}=zeros(2), \n               vmin::Real=0.0, vmax::Real=0.0; \n               cmap::String=\"viridis\",\n                ticks_color::String=\"white\",\n                interpolation::String=\"none\")\n\nHelper function to plot an imshow with logarithmic colorbar.\n\n\n\n\n\n","category":"function"},{"location":"plot_utility/#pcolormesh","page":"Plot Utility","title":"pcolormesh","text":"","category":"section"},{"location":"plot_utility/","page":"Plot Utility","title":"Plot Utility","text":"get_pcolormesh","category":"page"},{"location":"plot_utility/#PyPlotUtility.get_pcolormesh","page":"Plot Utility","title":"PyPlotUtility.get_pcolormesh","text":"get_pcolormesh( map, x_lim, y_lim, c_lim=nothing; \n                image_cmap=\"plasma\", cnorm=matplotlib.colors.LogNorm(),\n                set_bad::Bool=true, bad_color::String=\"white\" )\n\nPlot a pcolormesh of map with linear xy-axis given by x_lim, y_lim. If c_lim is not defined the colorbar is limited by minimum and maximum of the map.\n\nKeyword Arguments:\n\nimage_cmap=\"plasma\": Name of the colormap to use.\ncnorm=matplotlib.colors.LogNorm(): Norm for pcolormesh. \nset_bad::Bool=true: Whether to set invalid pixels to a different color.\nbad_color::String=\"white\": Color to use if set_bad=true.\n\n\n\n\n\n","category":"function"},{"location":"plot_utility/","page":"Plot Utility","title":"Plot Utility","text":"get_pcolormesh_log","category":"page"},{"location":"plot_utility/#PyPlotUtility.get_pcolormesh_log","page":"Plot Utility","title":"PyPlotUtility.get_pcolormesh_log","text":"get_pcolormesh_log( map, x_lim, y_lim, c_lim=nothing; \n                    image_cmap=\"plasma\", cnorm=matplotlib.colors.LogNorm(),\n                    set_bad::Bool=true, bad_color::String=\"white\" )\n\nPlot a pcolormesh of map with logarithmic xy-axis given by x_lim, y_lim. If c_lim is not defined the colorbar is limited by minimum and maximum of the map.\n\nKeyword Arguments:\n\nimage_cmap=\"plasma\": Name of the colormap to use.\ncnorm=matplotlib.colors.LogNorm(): Norm for pcolormesh. \nset_bad::Bool=true: Whether to set invalid pixels to a different color.\nbad_color::String=\"white\": Color to use if set_bad=true.\n\n\n\n\n\n","category":"function"},{"location":"plot_utility/#streamlines","page":"Plot Utility","title":"streamlines","text":"","category":"section"},{"location":"plot_utility/","page":"Plot Utility","title":"Plot Utility","text":"get_streamlines","category":"page"},{"location":"plot_utility/#PyPlotUtility.get_streamlines","page":"Plot Utility","title":"PyPlotUtility.get_streamlines","text":"get_streamlines( ax::PyCall.PyObject, \n                 image_x::Array{<:Real}, image_y::Array{<:Real}, \n                 par::mappingParameters;\n                 scale::Real=1.0, density::Real=2.0, color::String=\"grey\")\n\nPlot streamlines of axis ax. Takes gridded images in x- and y-directions image_x, image_y and reconstructs their corresponding xy-positions from par. Returns the streamplot object.\n\nKeyword arguments:\n\nscale::Real=1.0: conversion scale for xy-coordinates (e.g. scale=1.e-3 for kpc -> Mpc)\ndensity::Real=2.0: Line density of streamlines\ncolor::String=\"grey\": Color of the streamlines\n\n\n\n\n\n","category":"function"}]
}
