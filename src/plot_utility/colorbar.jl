using PyCall
using PyPlot

"""
    get_colorbar_top(ax::PyCall.PyObject, im::PyCall.PyObject, 
                     label::AbstractString, 
                     axis_label_font_size::Integer, 
                     tick_label_size::Integer)

Returns a colorbar at the top of a plot.
"""
function get_colorbar_top(ax::PyCall.PyObject, im::PyCall.PyObject,
    label::AbstractString,
    axis_label_font_size::Integer = 16,
    tick_label_size::Integer = 15)

    axes_divider = pyimport("mpl_toolkits.axes_grid1.axes_divider")

    ax_divider = axes_divider.make_axes_locatable(ax)
    cax = ax_divider.append_axes("top", size = "7%", pad = "2%")
    cb = colorbar(im, cax = cax, orientation = "horizontal")#, fraction=0.046, pad=0.5)#, cax=cbaxis1)
    cb.set_label(label, fontsize = axis_label_font_size)
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
    cb.ax.minorticks_on()

    cax.xaxis.set_ticks_position("top")
    cax.xaxis.set_label_position("top")

    #cax.xaxis.set_major_locator(PyPlot.MaxNLocator(10))

    return cax
end

"""
    get_colorbar_left(ax::PyCall.PyObject, im::PyCall.PyObject, 
                     label::AbstractString, 
                     axis_label_font_size::Integer, 
                     tick_label_size::Integer)

Returns a colorbar at the left of a plot.
"""
function get_colorbar_left(ax::PyCall.PyObject, im::PyCall.PyObject,
    label::AbstractString,
    axis_label_font_size::Integer = 16,
    tick_label_size::Integer = 15)

    axes_divider = pyimport("mpl_toolkits.axes_grid1.axes_divider")

    ax_divider = axes_divider.make_axes_locatable(ax)
    cax = ax_divider.append_axes("left", size = "7%", pad = "2%")
    cb = colorbar(im, cax = cax)#, fraction=0.046, pad=0.5)#, cax=cbaxis1)
    cb.set_label(label, fontsize = axis_label_font_size)
    cb.ax.tick_params(
        reset=true,
        direction = "in",
        which = "major",
        labelsize = tick_label_size,
        size = 6, width = 1
    )
    cb.ax.tick_params(
        #reset=true,
        direction = "in",
        which = "minor",
        labelsize = tick_label_size,
        size = 3, width = 1
    )

    cax.xaxis.set_ticks_position("left")
    cax.xaxis.set_label_position("left")

    return cax
end

"""
    get_colorbar_right(ax::PyCall.PyObject, im::PyCall.PyObject, 
                     label::AbstractString, 
                     axis_label_font_size::Integer, 
                     tick_label_size::Integer)

Returns a colorbar at the right of a plot.
"""
function get_colorbar_right(ax::PyCall.PyObject, im::PyCall.PyObject,
    label::AbstractString,
    axis_label_font_size::Integer = 16,
    tick_label_size::Integer = 15)

    axes_divider = pyimport("mpl_toolkits.axes_grid1.axes_divider")

    ax_divider = axes_divider.make_axes_locatable(ax)
    cax = ax_divider.append_axes("right", size = "7%", pad = "2%")
    cb = colorbar(im, cax = cax)#, fraction=0.046, pad=0.5)#, cax=cbaxis1)
    cb.set_label(label, fontsize = axis_label_font_size)
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

    # cax.xaxis.set_ticks_position("right")
    # cax.xaxis.set_label_position("right")

    return cax
end

"""
    shift_colorbar_label!(cax::PyCall.PyObject, shift::String)

Shift a colorbar label at the left `["left", "l"]` of the colorbar to the right, or vice versa with `["right", "r"]`.
"""
function shift_colorbar_label!(cax::PyCall.PyObject, shift::String)

    if shift ∈ ["left", "l"]
        label1 = cax.xaxis.get_majorticklabels()
        label1[end].set_ha("right")
    elseif shift ∈ ["right", "r"]
        label1 = cax.xaxis.get_majorticklabels()
        label1[1].set_ha("left")
    elseif shift ∈ ["top", "t"]
        label1 = cax.yaxis.get_majorticklabels()
        label1[1].set_verticalalignment("bottom")
    elseif shift ∈ ["bottom", "b"]
        label1 = cax.yaxis.get_majorticklabels()
        label1[end].set_verticalalignment("top")
    else
        error("Shift needs to be 'left'/'l', 'right'/'r' 'top / t' or 'bottom / b' !")
    end

    return cax

end