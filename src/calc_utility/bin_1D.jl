
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
    bin_1D_quantity(count, quantity_count, 
                     quantity, bin_lim; 
                     Nbins::Int=100, show_progress::Bool=true)

Get a 1D histogram of `quantity` in the limits `bin_lim`, over a number if bins `Nbins` for pre-allocated arrays `count` and `quantity_count`.
Should be used if computing the mean over multiple files.
"""
function bin_1D_quantity( x_q, bin_q, bin_lim; 
                           Nbins::Int=100, show_progress::Bool=true,
                           calc_mean::Bool=true)

    # allocate Nbins x Nbins matrix filled with zeros
    count = zeros(Int64, Nbins)

    # if a quantity should be mapped allocate Nbins x Nbins matrix filled with zeros
    count_quantity = zeros(eltype(quantity[1]), Nbins)

    # allocate Nbins x Nbins matrix filled with zeros
    count = zeros(Int64, Nbins)
    

    # get logarithmic bin spacing
    dbin = ( bin_lim[2] - bin_lim[1] ) / Nbins

    # optional progress meter
    if show_progress
        P = Progress(size(quantity,1))
        idx_p = 0
    end

    @inbounds for i = 1:size(quantity,1)

        bin = 1 + floor( Int64, ( x_q[i] - bin_lim[1] ) / dbin )

        if (1 <= bin <= Nbins)
            
            count[bin]          += 1
            count_quantity[bin] += bin_q[i]
            
        end

        # update progress meter
        if show_progress
            idx_p += 1
            ProgressMeter.update!(P, idx_p)
        end
    end

    if calc_mean
        return count .* quantity_count ./ count.^2
    else
        return quantity_count
    end

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
    bin_1D_quantity_log(count, quantity_count, 
                        quantity, bin_lim; 
                        Nbins::Int=100, show_progress::Bool=true)

Get a 1D histogram of `quantity` in the limits `bin_lim`, over a number if bins `Nbins` for pre-allocated arrays `count` and `quantity_count`.
Should be used if computing the mean over multiple files.
"""
function bin_1D_quantity_log( x_q, bin_q, bin_lim; 
                              Nbins::Int=100, show_progress::Bool=true,
                              calc_mean::Bool=true)

    # allocate Nbins x Nbins matrix filled with zeros
    count = zeros(Int64, Nbins)

    # if a quantity should be mapped allocate Nbins x Nbins matrix filled with zeros
    count_quantity = zeros(eltype(bin_q[1]), Nbins)

    # allocate Nbins x Nbins matrix filled with zeros
    count = zeros(Int64, Nbins)
    

    # get logarithmic bin spacing
    dlogbin = (log10(bin_lim[2]) - log10(bin_lim[1]) ) / Nbins

    # optional progress meter
    if show_progress
        P = Progress(size(bin_q,1))
        idx_p = 0
    end

    @inbounds for i = 1:size(x_q,1)

        bin = 1 + floor( Int64, (log10(x_q[i]) - log10(bin_lim[1]))/dlogbin )


        if (1 <= bin <= Nbins)
            
            count[bin]          += 1
            count_quantity[bin] += bin_q[i]
            
        end

        # update progress meter
        if show_progress
            idx_p += 1
            ProgressMeter.update!(P, idx_p)
        end
    end

    if calc_mean
        return count .* count_quantity ./ count.^2
    else
        return count_quantity
    end

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


"""
    σ_1D_quantity(quantity_sum, bin_count)

Compute the standard deviation per bin.
From: https://math.stackexchange.com/questions/198336/how-to-calculate-standard-deviation-with-streaming-inputs
"""
function σ_1D_quantity(quantity_sum, bin_count)

    σ = Vector{eltype(quantity_sum[1])}(undef, length(quantity_sum))

    @inbounds for i = 1:length(quantity_count)
        if bin_count[i] > 0
            σ[i] = √( quantity_sum[i] / bin_count[i] - ( quantity_sum[i] / bin_count[i] )^2 )
        else
            σ[i] = 0
        end
    end

    return σ
end