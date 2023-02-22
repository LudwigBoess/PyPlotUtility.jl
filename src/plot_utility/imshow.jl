
"""
    get_imshow(ax::PyCall.PyObject, image::Array{<:Real}, 
                    x_lim::Array{<:Real}=zeros(2), y_lim::Array{<:Real}=zeros(2), 
                    vmin::Real=0.0, vmax::Real=0.0; 
                    cmap::String="viridis", cnorm=matplotlib.colors.NoNorm(),
                    ticks_color::String="white",
                    interpolation::String="none")

Helper function to plot an `imshow` with linear colorbar.
"""
function get_imshow(ax::PyCall.PyObject, image::Array{<:Real}, 
                    x_lim::Array{<:Real}=zeros(2), y_lim::Array{<:Real}=zeros(2), 
                    vmin::Real=0.0, vmax::Real=0.0; 
                    cmap::String="viridis", cnorm=matplotlib.colors.NoNorm(),
                    ticks_color::String="white",
                    interpolation::String="none")

    if vmin == 0.0 && vmax == 0.0
        vmin = minimum(image)
        vmax = maximum(image)
    end

    if x_lim == zeros(2) && y_lim == zeros(2)
        x_lim = [1, length(image[:,1])]
        y_lim = [1, length(image[1,:])]
    end
    
    im = ax.imshow(image, norm=cnorm,
                    vmin=vmin, vmax=vmax, 
                    cmap = cmap,
                    origin="lower",
                    extent= [x_lim[1],
                             x_lim[2],
                             y_lim[1],
                             y_lim[2]],
                    interpolation=interpolation
                        )

    for spine in values(ax.spines)
        spine.set_edgecolor(ticks_color)
    end

    return im
end


"""
    get_imshow_log(ax::PyCall.PyObject, image::Array{<:Real}, 
                   x_lim::Array{<:Real}=zeros(2), y_lim::Array{<:Real}=zeros(2), 
                   vmin::Real=0.0, vmax::Real=0.0; 
                   cmap::String="viridis",
                    ticks_color::String="white",
                    interpolation::String="none")

Helper function to plot an `imshow` with logarithmic colorbar.
"""
function get_imshow_log(ax::PyCall.PyObject, image::Array{<:Real}, 
                        x_lim::Array{<:Real}=zeros(2), y_lim::Array{<:Real}=zeros(2), 
                        vmin::Real=0.0, vmax::Real=0.0; 
                        cmap::String="viridis", ticks_color::String="white", 
                        interpolation::String="none")

    return get_imshow(ax, image, x_lim, y_lim, vmin, vmax, cmap=cmap, cnorm=matplotlib.colors.LogNorm(;vmin, vmax),
                      ticks_color=ticks_color, interpolation=interpolation)
end