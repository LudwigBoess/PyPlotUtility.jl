using PyCall
using PyPlot

"""
    axis_ticks_styling!(ax::PyCall.PyObject; size_minor_ticks::Int64=6, 
                        width_minor_ticks::Int64=1, major_tick_width_scale::Int64=1,
                        tick_label_size::Int64=15, color::String="k")

LMB default axis tick styling.
"""
function axis_ticks_styling!(ax::PyCall.PyObject; size_minor_ticks::Int64=6, 
                             width_minor_ticks::Int64=1, major_tick_width_scale::Int64=1,
                             tick_label_size::Int64=15, color::String="k")

    ax.tick_params(reset=true, direction="in", axis="both", labelsize=tick_label_size,
                    which="major", size=size_minor_ticks<<1, 
                    width=major_tick_width_scale*width_minor_ticks, color=color)

    ax.tick_params(reset=true, direction="in", axis="both", labelsize=tick_label_size,
                    which="minor", size=size_minor_ticks, width=width_minor_ticks, color=color)

    ax.minorticks_on()

    return ax
end

"""
    pixel_size(fig::Figure)

Helper function to get markers with size 1 pixel.
"""
function pixel_size(fig::Figure)
    return (72.0/fig.dpi)*(72.0/fig.dpi)
end