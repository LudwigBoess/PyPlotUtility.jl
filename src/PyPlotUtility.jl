module PyPlotUtility

using PyCall

export axis_ticks_styling!, get_gs 

function axis_ticks_styling!(ax::PyCall.PyObject; size_minor_ticks::Int64=6, tick_label_size::Int64=15, color::String="k")

    ax.tick_params(reset=true, direction="in", axis="both", labelsize=tick_label_size,
                    which="major", size=size_minor_ticks<<1, width=1, color=color)
    ax.tick_params(reset=true, direction="in", axis="both", labelsize=tick_label_size,
                    which="minor", size=size_minor_ticks, width=1, color=color)

    ax.minorticks_on()

    return ax
end

function slice(rng::UnitRange)
    pycall(pybuiltin("slice"), PyObject, first(rng), last(rng))
end


function get_gs(gs::PyObject, row::Int64, col::Int64)

    if (typeof(row) <: UnitRange && typeof(col) <: UnitRange )
        return get(gs, (slice(row), slice(col)))
    elseif typeof(row) <: UnitRange
        return get(gs, (slice(row), col))
    elseif typeof(col) <: UnitRange
        return get(gs, (row, slice(col)))
    else
        return get(gs, (row, col))
    end
end

end # module
