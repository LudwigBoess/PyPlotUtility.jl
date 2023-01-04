"""
    bin_1D( bin_quantity, bin_lim, count_quantity=nothing; 
            calc_sigma::Bool=true, Nbins::Int=100,
            show_progress::Bool=true)

Get a 1D histogram of `quantity` in the limits `bin_lim`, over a number if bins `Nbins`.
If a `count_quantity` is provided it computes the mean of said quantity within the bin.
If `calc_sigma` is set to `true` it will also return the standard deviation of the quantity per bin.
"""
function bin_1D(bin_quantity, bin_lim, count_quantity=nothing; 
                calc_sigma::Bool=true, calc_mean::Bool=false, 
                Nbins::Int=100,
                show_progress::Bool=true)

    # get logarithmic bin spacing
    dbin = (bin_lim[2] - bin_lim[1] ) / Nbins

    # allocate Nbins x Nbins matrix filled with zeros
    count = zeros(Int64, Nbins)

    if !isnothing(count_quantity)
        # if a quantity should be mapped allocate Nbins x Nbins matrix filled with zeros
        sum_quantity = zeros(eltype(count_quantity[1]), Nbins)
    end

    # optional progress meter
    if show_progress
        P = Progress(size(bin_quantity,1))
        idx_p = 0
    end

    # loop over all entries
    @inbounds for i = 1:size(bin_quantity,1)

        if isinf(bin_quantity[i]) || isnan(bin_quantity[i])
            continue
        end
        
        # floor division to get relevant bin
        # Julia is 1-based -> additional 1
        bin = 1 + floor( Int64, (bin_quantity[i] - bin_lim[1])/dbin )

        # check if bin is in range to check if particle is relevant
        if (1 <= bin <= Nbins)
            
            # count up histogram storage
            count[bin] += 1

            if !isnothing(count_quantity)
                # sum up to total binned quantity
                sum_quantity[bin] += count_quantity[i]
            end
        end

        # update progress meter if defined
        if show_progress
            idx_p += 1
            ProgressMeter.update!(P, idx_p)
        end
    end


    # only 1D histogram
    if isnothing(count_quantity)
        # only return counts
        return count

    # mean value inside bins
    else
        # calc standard deviation within bins
        if calc_sigma
            # calc sigma
            sigma = σ_1D_quantity(sum_quantity, count)
        end

        if calc_mean
            # if mean of binned quantity should be calculated
            @inbounds for i = 1:Nbins
                if count[i] > 0
                    sum_quantity[i] /= count[i]
                end
            end
        end

        if !calc_sigma
            # return mean quantity
            return sum_quantity
        else
            # return mean quantity and sigma
            return sum_quantity, sigma
        end
    end    
end


"""
    bin_1D!(count, bin_quantity, bin_lim, 
            sum_quantity=nothing, count_quantity=nothing; 
            Nbins::Int=100,
            show_progress::Bool=true)

Get a 1D histogram of `quantity` in the limits `bin_lim`, over a number if bins `Nbins` for pre-allocated array `count`.
If a `count_quantity` is provided it computes the sum of said quantity within the bin and writes it into `sum_quantity`.
"""
function bin_1D!(count, bin_quantity, bin_lim, 
                sum_quantity=nothing, count_quantity=nothing; 
                Nbins::Int=100,
                show_progress::Bool=true)

    # get logarithmic bin spacing
    dbin = (bin_lim[2] - bin_lim[1] ) / Nbins

    # optional progress meter
    if show_progress
        P = Progress(size(bin_quantity,1))
        idx_p = 0
    end

    # loop over all entries
    @inbounds for i = 1:size(bin_quantity,1)

        # floor division to get relevant bin
        # Julia is 1-based -> additional 1
        bin = 1 + floor( Int64, (bin_quantity[i] - bin_lim[1])/dbin )

        # check if bin is in range to check if particle is relevant
        if (1 <= bin <= Nbins)
            
            # count up histogram storage
            count[bin] += 1

            if !isnothing(count_quantity)
                # sum up to total binned quantity
                sum_quantity[bin] += count_quantity[i]
            end
        end

        # update progress meter if defined
        if show_progress
            idx_p += 1
            ProgressMeter.update!(P, idx_p)
        end
    end


    # only 1D histogram
    if isnothing(count_quantity)
        # only return counts
        return count
    else
        # return count and sum quantity
        return count, sum_quantity
    end    
end



"""
    bin_1D_log( bin_quantity, bin_lim, count_quantity=nothing; 
                calc_sigma::Bool=true, Nbins::Int=100,
                show_progress::Bool=true)

Get a 1D histogram of `quantity` in the limits `bin_lim`, over a number if bins `Nbins` ``log``-space.
If a `count_quantity` is provided it computes the mean of said quantity within the bin.
If `calc_sigma` is set to `true` it will also return the standard deviation of the quantity per bin.
"""
function bin_1D_log(bin_quantity, bin_lim, count_quantity=nothing; 
                    calc_sigma::Bool=true, calc_mean::Bool=false, 
                    Nbins::Int=100,
                    show_progress::Bool=true)

    return bin_1D(log10.(bin_quantity), log10.(bin_lim), count_quantity; calc_sigma, calc_mean, Nbins, show_progress)
end


"""
    bin_1D_log!(count, bin_quantity, bin_lim, 
                sum_quantity=nothing, count_quantity=nothing; 
                Nbins::Int=100,
                show_progress::Bool=true)

Get a 1D histogram of `quantity` in the limits `bin_lim`, over a number if bins `Nbins` for pre-allocated array `count` in ``log``-space.
If a `count_quantity` is provided it computes the sum of said quantity within the bin and writes it into `sum_quantity`.
"""
function bin_1D_log!(count, bin_quantity, bin_lim, 
                sum_quantity=nothing, count_quantity=nothing; 
                Nbins::Int=100,
                show_progress::Bool=true)

    bin_1D!(count, log10.(bin_quantity), log10.(bin_lim), 
                sum_quantity, count_quantity; 
                Nbins, show_progress)
end


"""
    bin_1D_loglog( bin_quantity, bin_lim, count_quantity; 
                calc_sigma::Bool=true, Nbins::Int=100,
                show_progress::Bool=true)

Get a 1D histogram of `bin_quantity` in the limits `bin_lim`, over a number if bins `Nbins` in ``log``-space.
If a `count_quantity` is provided it computes the mean of said quantity in ``log``-space within the bin.
If `calc_sigma` is set to `true` it will also return the standard deviation of the quantity per bin.
"""
function bin_1D_loglog(bin_quantity, bin_lim, count_quantity; 
                    calc_sigma::Bool=true, Nbins::Int=100,
                    show_progress::Bool=true)

    return bin_1D(log10.(bin_quantity), log10.(bin_lim), log10.(count_quantity); 
                  calc_sigma, Nbins, show_progress)
end


"""
    bin_1D_log!(count, bin_quantity, bin_lim, 
                sum_quantity=nothing, count_quantity=nothing; 
                Nbins::Int=100,
                show_progress::Bool=true)

Get a 1D histogram of `bin_quantity` in the limits `bin_lim`, over a number if bins `Nbins` for pre-allocated array `count` in ``log``-space.
If a `count_quantity` is provided it computes the sum of said quantity within the bin and writes it into `sum_quantity`.
"""
function bin_1D_loglog!(count, bin_quantity, bin_lim, 
                sum_quantity=nothing, count_quantity=nothing; 
                Nbins::Int=100,
                show_progress::Bool=true)

    bin_1D!(count, log10.(bin_quantity), log10.(bin_lim), 
                sum_quantity, log10.(count_quantity); 
                Nbins, show_progress)
end

"""
    σ_1D_quantity(quantity_sum, bin_count)

Compute the standard deviation per bin.
From: https://math.stackexchange.com/questions/198336/how-to-calculate-standard-deviation-with-streaming-inputs
"""
function σ_1D_quantity(quantity_sum, bin_count)

    σ = Vector{eltype(quantity_sum[1])}(undef, length(quantity_sum))

    @inbounds for i = 1:length(quantity_sum)
        if bin_count[i] > 0
            σ[i] = √( quantity_sum[i] / bin_count[i] - ( quantity_sum[i] / bin_count[i] )^2 )
        else
            σ[i] = 0
        end
    end

    return σ
end


