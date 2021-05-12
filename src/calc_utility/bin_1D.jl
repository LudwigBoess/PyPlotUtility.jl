
"""
    bin_1D( quantity, bin_lim; 
            calc_mean::Bool=true, Nbins::Int=100,
            show_progress::Bool=true)

Get a 1D histogram of `quantity` in the limits `bin_lim`, over a number if bins `Nbins`.
If `calc_mean` is set to true it will calculate the mean of the quantity per bin, otherwise the sum is returned.
"""
function bin_1D(quantity, bin_lim; 
                calc_mean::Bool=false, Nbins::Int=100,
                show_progress::Bool=true)

    # get logarithmic bin spacing
    dbin = ( bin_lim[2] - bin_lim[1] ) / Nbins

    # allocate Nbins x Nbins matrix filled with zeros
    count = zeros(Int64, Nbins)

    if calc_mean
        # if a quantity should be mapped allocate Nbins x Nbins matrix filled with zeros
        count_quantity = zeros(eltype(quantity[1]), Nbins)
    end

    # optional progress meter
    if show_progress
        P = Progress(size(quantity,1))
        idx_p = 0
    end

    # loop over all entries
    @inbounds for i = 1:size(quantity,1)

        # floor division to get relevant bin
        # Julia is 1-based -> additional 1
        bin = 1 + floor( Int64, (quantity[i] - bin_lim[1])/dbin )

        # check if bin is in range to check if particle is relevant
        if (1 <= bin <= Nbins)
            
            # count up histogram storage
            count[bin] += 1

            if calc_mean
                # sum up to total binned quantity
                count_quantity[bin] += quantity[i]
            end
        end

        # update progress meter if defined
        if show_progress
            idx_p += 1
            ProgressMeter.update!(P, idx_p)
        end
    end


    if !calc_mean
        # return simple histogram
        return count
    else
        # if mean of binned quantity should be calculated
        @inbounds for i = 1:Nbins
            if count > 0
                count_quantity[i] /= count[i]
            end
        end

        # return mean quantity
        return count_quantity
    end
end


"""
    bin_1D!(count, quantity, bin_lim; 
            Nbins::Int=100, show_progress::Bool=true)

Get a 1D histogram of `quantity` in the limits `bin_lim`, over a number if bins `Nbins` for pre-allocated arrays `count` and `quantity_count`.
Should be used if computing a 1D histogram over multiple files.
"""
function bin_1D!(count, quantity, bin_lim; 
                 Nbins::Int=100, show_progress::Bool=true)

    # get logarithmic bin spacing
    dbin = (bin_lim[2] - bin_lim[1] ) / Nbins

    # optional progress meter
    if show_progress
        P = Progress(size(quantity,1))
        idx_p = 0
    end

    @inbounds for i = 1:size(quantity,1)

        bin = 1 + floor( Int64, (quantity[i] - bin_lim[1])/dbin )

        if (1 <= bin <= Nbins)
            
            count[bin] += 1
            
        end

        # update progress meter
        if show_progress
            idx_p += 1
            ProgressMeter.update!(P, idx_p)
        end
    end

    return count

end



"""
    bin_1D_quantity!(count, quantity_count, 
                     quantity, bin_lim; 
                     Nbins::Int=100, show_progress::Bool=true)

Get a 1D histogram of `quantity` in the limits `bin_lim`, over a number if bins `Nbins` for pre-allocated arrays `count` and `quantity_count`.
Should be used if computing the mean over multiple files.
"""
function bin_1D_quantity!( count, quantity_count, 
                           quantity, bin_lim; 
                           Nbins::Int=100, show_progress::Bool=true)

    # get logarithmic bin spacing
    dbin = ( bin_lim[2] - bin_lim[1] ) / Nbins

    # optional progress meter
    if show_progress
        P = Progress(size(quantity,1))
        idx_p = 0
    end

    @inbounds for i = 1:size(quantity,1)

        bin = 1 + floor( Int64, ( quantity[i] - bin_lim[1] ) / dbin )

        if (1 <= bin <= Nbins)
            
            count[bin]          += 1
            quantity_count[bin] += quantity[i]
            
        end

        # update progress meter
        if show_progress
            idx_p += 1
            ProgressMeter.update!(P, idx_p)
        end
    end

    return count, quantity_count

end



"""
    bin_1D_log( quantity, bin_lim; 
                calc_mean::Bool=true, Nbins::Int=100,
                show_progress::Bool=true)

Get a 1D histogram of `quantity` in the limits `bin_lim`, over a number if bins `Nbins` in ``log``-space for pre-allocated arrays `count` and `quantity_count`.
If `calc_mean` is set to true it will calculate the mean of the quantity per bin, otherwise the sum is returned.
"""
function bin_1D_log(quantity, bin_lim; 
                    calc_mean::Bool=true, Nbins::Int=100,
                    show_progress::Bool=true)

    # get logarithmic bin spacing
    dlogbin = (log10(bin_lim[2]) - log10(bin_lim[1]) ) / Nbins

    # allocate Nbins x Nbins matrix filled with zeros
    count = zeros(Int64, Nbins)

    if calc_mean
        # if a quantity should be mapped allocate Nbins x Nbins matrix filled with zeros
        count_quantity = zeros(eltype(quantity[1]), Nbins)
    end

    # optional progress meter
    if show_progress
        P = Progress(size(quantity,1))
        idx_p = 0
    end

    # loop over all entries
    @inbounds for i = 1:size(quantity,1)

        # floor division to get relevant bin
        # Julia is 1-based -> additional 1
        bin = 1 + floor( Int64, (log10(quantity[i]) - log10(bin_lim[1]))/dlogbin )

        # check if bin is in range to check if particle is relevant
        if (1 <= bin <= Nbins)
            
            # count up histogram storage
            count[bin] += 1

            if calc_mean
                # sum up to total binned quantity
                count_quantity[bin] += quantity[i]
            end
        end

        # update progress meter if defined
        if show_progress
            idx_p += 1
            ProgressMeter.update!(P, idx_p)
        end
    end


    if !calc_mean
        # return simple histogram
        return count
    else
        # if mean of binned quantity should be calculated
        @inbounds for i = 1:Nbins
            if count > 0
                count_quantity[i] /= count[i]
            end
        end

        # return mean quantity
        return count_quantity
    end
end


"""
    bin_1D_log!(count, quantity, bin_lim; 
                Nbins::Int=100, show_progress::Bool=true)

Get a 1D histogram of `quantity` in the limits `bin_lim`, over a number if bins `Nbins` in ``log``-space for pre-allocated arrays `count` and `quantity_count`.
Should be used if computing a 1D histogram over multiple files.
"""
function bin_1D_log!(count, quantity, bin_lim; 
                     Nbins::Int=100, show_progress::Bool=true)

    # get logarithmic bin spacing
    dlogbin = (log10(bin_lim[2]) - log10(bin_lim[1]) ) / Nbins

    # optional progress meter
    if show_progress
        P = Progress(size(quantity,1))
        idx_p = 0
    end

    @inbounds for i = 1:size(quantity,1)

        bin = 1 + floor( Int64, (log10(quantity[i]) - log10(bin_lim[1]))/dlogbin )

        if (1 <= bin <= Nbins)
            
            count[bin] += 1
            
        end

        # update progress meter
        if show_progress
            idx_p += 1
            ProgressMeter.update!(P, idx_p)
        end
    end

    return count

end



"""
    bin_1D_quantity_log!(count, quantity_count, 
                         quantity, bin_lim; 
                         Nbins::Int=100, show_progress::Bool=true)

Get a 1D histogram of `quantity` in the limits `bin_lim`, over a number if bins `Nbins` in ``log``-space for pre-allocated arrays `count` and `quantity_count`.
Should be used if computing the mean over multiple files.
"""
function bin_1D_quantity_log!(count, quantity_count, 
                              quantity, bin_lim; 
                              Nbins::Int=100, show_progress::Bool=true)

    # get logarithmic bin spacing
    dlogbin = (log10(bin_lim[2]) - log10(bin_lim[1]) ) / Nbins

    # optional progress meter
    if show_progress
        P = Progress(size(quantity,1))
        idx_p = 0
    end

    @inbounds for i = 1:size(quantity,1)

        bin = 1 + floor( Int64, (log10(quantity[i]) - log10(bin_lim[1]))/dlogbin )

        if (1 <= bin <= Nbins)
            
            count[bin]          += 1
            quantity_count[bin] += quantity[i]
            
        end

        # update progress meter
        if show_progress
            idx_p += 1
            ProgressMeter.update!(P, idx_p)
        end
    end

    return count, quantity_count

end

