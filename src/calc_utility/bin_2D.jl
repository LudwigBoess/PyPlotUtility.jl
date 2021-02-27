
"""
    bin_2D_log( x_q, y_q, x_lim, y_lim, bin_q=nothing; 
            calc_mean::Bool=true, Nbins::Int=100)

Get a 2D histogram of `x_q` and `y_q` in the limits `x_lim`, `y_lim` over a number if bins `Nbins` in ``log``-space.
If you want to bin an additional quantity `bin_q` you can pass it as an optional argument. 
If `calc_mean` is set to true it will calculate the mean of the quantity per bin, otherwise the sum is returned.
"""
function bin_2D_log(x_q, y_q, x_lim, y_lim, bin_q=nothing; 
                calc_mean::Bool=true, Nbins::Int=100)

    # get logarithmic bin spacing
    dlogx = (log10(x_lim[2]) - log10(x_lim[1]) ) / Nbins
    dlogy = (log10(y_lim[2]) - log10(y_lim[1]) ) / Nbins

    phase_map_count = zeros(Int64, Nbins, Nbins)

    if !isnothing(bin_q)
        phase_map = zeros(eltype(x_q[1]), Nbins, Nbins)
    end

    @showprogress "Binning... " for i = 1:size(x_q,1)

        x_bin = 1 + floor( Int64, (log10(x_q[i]) - log10(x_lim[1]))/dlogx )
        y_bin = 1 + floor( Int64, (log10(y_q[i]) - log10(y_lim[1]))/dlogy )

        if (1 <= x_bin <= Nbins) && (1 <= y_bin <= Nbins)
            
            phase_map_count[y_bin, x_bin] += 1

            if !isnothing(bin_q)
                phase_map[y_bin, x_bin] += bin_q[i]
            end
        end
    end

    if isnothing(bin_q)
        return phase_map_count
    else
        if calc_mean
            # reduce map
            @inbounds for i = 1:Nbins, j = 1:Nbins
                phase_map[j, i] /= phase_map_count[j,i]
            end
        end

        return phase_map
    end
end

"""
    bin_2D_log!( phase_map_count,  
                 x_q, y_q,  
                 x_lim, y_lim; Nbins::Int=100)

Get a 2D histogram of `x_q` and `y_q` in the limits `x_lim`, `y_lim` over a number if bins `Nbins` in ``log``-space for pre-allocated array `phase_map_count`.
Should be used if computing a 2D phase map over multiple files.
"""
function bin_2D_log!(phase_map_count,  
                     x_q, y_q,  
                     x_lim, y_lim; Nbins::Int=100)

    # get logarithmic bin spacing
    dlogx = (log10(x_lim[2]) - log10(x_lim[1]) ) / Nbins
    dlogy = (log10(y_lim[2]) - log10(y_lim[1]) ) / Nbins

    @showprogress "Binning... " for i = 1:size(x_q,1)

        x_bin = 1 + floor( Int64, (log10(x_q[i]) - log10(x_lim[1]))/dlogx )
        y_bin = 1 + floor( Int64, (log10(y_q[i]) - log10(y_lim[1]))/dlogy )

        if (1 <= x_bin <= Nbins) && (1 <= y_bin <= Nbins)
            
            phase_map_count[y_bin, x_bin] += 1

            phase_map[y_bin, x_bin] += bin_q[i]
            
        end
    end

    return phase_map_count, phase_map

end



"""
    bin_2D_quantity_log!( phase_map_count, phase_map, 
                          x_q, y_q, bin_q, 
                          x_lim, y_lim; Nbins::Int=100)

Get a 2D histogram of `x_q` and `y_q` in the limits `x_lim`, `y_lim` over a number if bins `Nbins` in ``log``-space for pre-allocated arrays `phase_map_count` and `phase_map`.
Should be used if computing a 2D phase map over multiple files.
"""
function bin_2D_quantity_log!(phase_map_count, phase_map, 
                          x_q, y_q, bin_q, 
                          x_lim, y_lim; Nbins::Int=100)

    # get logarithmic bin spacing
    dlogx = (log10(x_lim[2]) - log10(x_lim[1]) ) / Nbins
    dlogy = (log10(y_lim[2]) - log10(y_lim[1]) ) / Nbins

    @showprogress "Binning... " for i = 1:size(x_q,1)

        x_bin = 1 + floor( Int64, (log10(x_q[i]) - log10(x_lim[1]))/dlogx )
        y_bin = 1 + floor( Int64, (log10(y_q[i]) - log10(y_lim[1]))/dlogy )

        if (1 <= x_bin <= Nbins) && (1 <= y_bin <= Nbins)
            
            phase_map_count[y_bin, x_bin] += 1

            phase_map[y_bin, x_bin] += bin_q[i]
            
        end
    end

    return phase_map_count, phase_map

end

