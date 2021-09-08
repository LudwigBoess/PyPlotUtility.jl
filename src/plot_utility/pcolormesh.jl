
"""
    get_pcolormesh_log( map, x_lim, y_lim, c_lim=nothing; 
                        image_cmap="plasma", cnorm=matplotlib.colors.LogNorm(),
                        set_bad::Bool=true, bad_color::String="white" )

Plot a pcolormesh of `map` with logarithmic xy-axis given by `x_lim`, `y_lim`.
If `c_lim` is not defined the colorbar is limited by minimum and maximum of the `map`.

## Keyword Arguments:
- `image_cmap="plasma"`: Name of the colormap to use.
- `cnorm=matplotlib.colors.LogNorm()`: Norm for `pcolormesh`. 
- `set_bad::Bool=true`: Whether to set invalid pixels to a different color.
- `bad_color::String="white"`: Color to use if `set_bad=true`.
"""
function get_pcolormesh_log(map, x_lim, y_lim, c_lim=nothing; 
                            image_cmap="plasma", cnorm=matplotlib.colors.LogNorm(),
                            set_bad::Bool=true, bad_color::String="white")

    # reconstruct corner point for pcolormesh
    X = 10.0.^LinRange(log10(x_lim[1]), log10(x_lim[2]), size(map,2))
    Y = 10.0.^LinRange(log10(y_lim[1]), log10(y_lim[2]), size(map,1))

    if set_bad
        # get colormap object
        cmap = plt.get_cmap(image_cmap)
        # set invalid pixels to white
        cmap.set_bad(bad_color)
    end

    # if no colorbar limits are set -> use minmax
    if isnothing(c_lim)
        c_lim = [minimum(map), maximum(map)]
    end

    # plot pcolormesh
    im1 = pcolormesh(X, Y, map, 
                     cmap=image_cmap, vmin=c_lim[1], vmax=c_lim[2], 
                     norm=cnorm)

    return im1
end


"""
    get_pcolormesh( map, x_lim, y_lim, c_lim=nothing; 
                    image_cmap="plasma", cnorm=matplotlib.colors.LogNorm(),
                    set_bad::Bool=true, bad_color::String="white" )

Plot a pcolormesh of `map` with linear xy-axis given by `x_lim`, `y_lim`.
If `c_lim` is not defined the colorbar is limited by minimum and maximum of the `map`.

## Keyword Arguments:
- `image_cmap="plasma"`: Name of the colormap to use.
- `cnorm=matplotlib.colors.LogNorm()`: Norm for `pcolormesh`. 
- `set_bad::Bool=true`: Whether to set invalid pixels to a different color.
- `bad_color::String="white"`: Color to use if `set_bad=true`.
"""
function get_pcolormesh(map, x_lim, y_lim, c_lim=nothing; 
                        image_cmap="plasma", cnorm=matplotlib.colors.LogNorm(),
                        set_bad::Bool=true, bad_color::String="white")

    # reconstruct corner point for pcolormesh
    X = LinRange(x_lim[1], x_lim[2], size(map,2))
    Y = LinRange(y_lim[1], y_lim[2], size(map,1))

    if set_bad
        # get colormap object
        cmap = plt.get_cmap(image_cmap)
        # set invalid pixels to white
        cmap.set_bad(bad_color)
    end

    # if no colorbar limits are set -> use minmax
    if isnothing(c_lim)
        c_lim = [minimum(map), maximum(map)]
    end

    # plot pcolormesh
    im1 = pcolormesh(X, Y, map, 
                     cmap=image_cmap, vmin=c_lim[1], vmax=c_lim[2], 
                     norm=cnorm)

    return im1
end