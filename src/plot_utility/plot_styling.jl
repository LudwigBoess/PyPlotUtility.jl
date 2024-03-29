using PyCall
using PyPlot

"""
    get_figure(aspect_ratio::Float64=1.1; x_pixels::Int64=600)

Get a `Figure` object with a given aspect ratio for a fixed number of pixels in x-diretion.
"""
function get_figure(aspect_ratio::Float64=1.1; x_pixels::Int64=600)
    rc("figure", dpi=100)
    figure(figsize=(aspect_ratio*1.e-2*x_pixels, 1.e-2*x_pixels))#, constrained_layout=true)
end

"""
    plot_styling!(;axis_label_font_size::Int64=20,
                        legend_font_size::Int64=15,
                        tick_label_size::Int64=15)

LMB default plot styling
"""
function plot_styling!( x_pixels::Int64 = 600;
                        axis_label_font_size::Int64 = 16,
                        legend_font_size::Int64 = 15,
                        color::String="k")

    axis_label_font_size = floor(Int64, x_pixels / 600 * axis_label_font_size)
    legend_font_size = floor(Int64, x_pixels / 600 * legend_font_size)

    rc("font", size = axis_label_font_size, family = "stixgeneral")
    rc("legend", fontsize = legend_font_size)
    rc("mathtext", fontset = "stix")
    rc("text", color=color)
    rc("axes", labelcolor=color)
    rc("xtick", color=color)
    rc("ytick", color=color)
end

"""
    color_spines(ax::PyCall.PyObject)

Changes the color accross all spines.
"""
function color_spines(ax::PyCall.PyObject, color::String)
    for spine ∈ ["top", "bottom", "left", "right"]
        ax.spines[spine].set_edgecolor(color)
    end
end

"""
    axis_ticks_styling!(ax::PyCall.PyObject; size_minor_ticks::Int64=6, 
                        width_minor_ticks::Int64=1, major_tick_width_scale::Int64=1,
                        tick_label_size::Int64=15, color::String="k")

LMB default axis tick styling.
"""
function axis_ticks_styling!(ax::PyCall.PyObject; size_minor_ticks::Int64=3, 
                             width_minor_ticks::Int64=1, major_tick_width_scale::Int64=1,
                             tick_label_size::Int64=15, color::String="k")

    ax.tick_params(reset=true, direction="in", axis="both", labelsize=tick_label_size,
                    which="major", size=size_minor_ticks<<1, 
                    width=major_tick_width_scale*width_minor_ticks, color=color)

    ax.tick_params(reset=true, direction="in", axis="both", labelsize=tick_label_size,
                    which="minor", size=size_minor_ticks, width=width_minor_ticks, color=color)

    ax.minorticks_on()

    color_spines(ax, color)

    return ax

end


"""
    cb_ticks_styling!(ax::PyCall.PyObject; size_minor_ticks::Int64=6, 
                        width_minor_ticks::Int64=1, major_tick_width_scale::Int64=1,
                        tick_label_size::Int64=15, color::String="k")

LMB default colorbar tick styling.
"""
function cb_ticks_styling!(cb::PyCall.PyObject; size_minor_ticks::Int64=3, 
                             width_minor_ticks::Int64=1, major_tick_width_scale::Int64=1,
                             tick_label_size::Int64=15, color::String="k")

    cb.ax.tick_params(direction="in", labelsize=tick_label_size,
                    which="major", size=2size_minor_ticks, 
                    width=major_tick_width_scale*width_minor_ticks, color=color)

    cb.ax.tick_params(direction="in", labelsize=tick_label_size,
                    which="minor", size=size_minor_ticks, 
                    width=width_minor_ticks, color=color)

    cb.ax.minorticks_on()

    cb.outline.set_edgecolor(color)

    return cb
end


"""
    pixel_size(fig::Figure)

Helper function to get markers with size 1 pixel.
"""
function pixel_size(fig::Figure)
    return (72.0/fig.dpi)*(72.0/fig.dpi)
end