using PyCall
using PyPlot


"""
    linestyle(sequence::String="";
                   dash::Real=3.7, dot::Real=1.0, space::Real=3.7,
                   buffer::Bool=false, offset::Int=0)

Get custom `IDL`-like linestyles. `sequence` has to be an even number of entries.

## Keyword Arguments
- `dash::Real=3.7`: Size of dash.
- `dot::Real=1.0`: Size of dot.
- `space::Real=3.7`: Size of space.
- `buffer::Bool=false`: Whether to add a buffer to the end of the sequence.
- `offset::Int=0`: No clue.
"""
function linestyle(sequence::String="";
                   dash::Real=3.7, dot::Real=1.0, space::Real=3.7,
                   buffer::Bool=false, offset::Int=0)


    if sequence == "-"
        return sequence
    end
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

"""
    ls(sequence::String="";
       dash::Real=3.7, dot::Real=1.0, space::Real=3.7,
       buffer::Bool=false, offset::Int=0)

Get custom `IDL`-like linestyles. `sequence` has to be an even number of entries.

## Keyword Arguments
- `dash::Real=3.7`: Size of dash.
- `dot::Real=1.0`: Size of dot.
- `space::Real=3.7`: Size of space.
- `buffer::Bool=false`: Whether to add a buffer to the end of the sequence.
- `offset::Int=0`: No clue.
"""
function ls(sequence::String="";
            dash::Real=3.7, dot::Real=1.0, space::Real=3.7,
            buffer::Bool=false, offset::Int=0)

    return linestyle(sequence, dash=dash, dot=dot, space=space, buffer=buffer, offset=offset)
end