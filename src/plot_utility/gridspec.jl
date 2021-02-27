using PyCall
using PyPlot

"""
    slice(rng::UnitRange)

Helper function to convert `Julia` `UnitRange` to `Python`.
"""
function slice(rng::UnitRange)
    pycall(pybuiltin("slice"), PyObject, first(rng), last(rng))
end

"""
    get_gs(gs::PyObject, row, col)

Helper function to get the correct `gridspec` panel for a given (range of) `row` and `col`.
"""
function get_gs(gs::PyObject, row, col)

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