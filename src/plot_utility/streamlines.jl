using SPHtoGrid
using PyCall
using PyPlot

"""
    get_streamlines( ax::PyCall.PyObject, 
                     image_x::Array{<:Real}, image_y::Array{<:Real}, 
                     par::mappingParameters;
                     scale::Real=1.0, density::Real=2.0, color::String="grey")

Plot streamlines of axis `ax`. Takes gridded images in x- and y-directions `image_x`, `image_y` and reconstructs their corresponding xy-positions from `par`.
Returns the `streamplot` object.

## Keyword arguments:
- `scale::Real=1.0`: conversion scale for xy-coordinates (e.g. `scale=1.e-3` for kpc -> Mpc)
- `density::Real=2.0`: Line density of streamlines
- `color::String="grey"`: Color of the streamlines
"""
function get_streamlines( ax::PyCall.PyObject, 
                          image_x::Array{<:Real}, image_y::Array{<:Real}, 
                          par::mappingParameters;
                          scale::Real=1.0, density::Real=2.0, color::String="grey")

    ax.set_xlim(scale .* par.x_lim)
    ax.set_ylim(scale .* par.y_lim)

    x_grid, y_grid = get_map_grid_2D(par)

    x_grid .*= scale
    y_grid .*= scale

    stream = ax.streamplot( x_grid, y_grid,
                            image_x, image_y, 
                            density = density, 
                            color = color
                            )

    return stream
end