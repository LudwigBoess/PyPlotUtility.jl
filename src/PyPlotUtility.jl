module PyPlotUtility

using PyCall

export axis_ticks_styling!, get_gs,
       linestyle, ls


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


function linestyle(sequence::String="";
                   dash::Float64=3.7, dot::Float64=1.0, space::Float64=3.7,
                   buffer::Bool=false, offset::Int64=0)


    if ( count(i-> (i=='.'), sequence) > 0 ) || ( count(i-> (i==':'), sequence) > 0)
        dash = 6.4
    end

    if (sequence == "" || sequence == "-" || sequence == "_")
        return (offset, [ dash ])
    elseif sequence == ":"
        return (offset, [dot, space, dot, space, dot, space] )
    else
        reftype = Dict( '-' => [  dash, space ],
                        '_' => [ 2dash, space ],
                        '.' => [   dot, space ],
                        ':' => [   dot, space, dot, space, dot, space ] )

        onoffseq = Vector{Float64}(undef, 0)

        for c ∈ sequence
            onoffseq = [onoffseq; reftype[c]]
        end

        if buffer
            onoffseq[end] = 1.0
        end

        return (offset, onoffseq)
    end

end

function ls(sequence::String="";
            dash::Float64=3.7, dot::Float64=1.0, space::Float64=3.7,
            buffer::Bool=false, offset::Int64=0)

    return linestyle(sequence, dash=dash, dot=dot, space=space, buffer=buffer, offset=offset)
end

end # module
