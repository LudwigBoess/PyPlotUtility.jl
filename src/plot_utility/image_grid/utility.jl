
function read_map_par(read_mode, Nfile, files, map_arr, par_arr)

    if isnothing(map_arr)

        image_name = files[Nfile]

        # read SPHtoGrid image
        if read_mode == 1
            map, par, snap_num, units = read_fits_image(image_name)

            # read Smac1 binary image
        elseif read_mode == 2
            map = read_smac1_binary_image(image_name)
            smac1_info = read_smac1_binary_info(image_name)
            smac1_center = [smac1_info.xcm, smac1_info.ycm, smac1_info.zcm] ./ 3.085678e21
            par = mappingParameters(center = smac1_center,
                x_size = smac1_info.boxsize_kpc,
                y_size = smac1_info.boxsize_kpc,
                z_size = smac1_info.boxsize_kpc,
                Npixels = smac1_info.boxsize_pix)

        elseif read_mode == 3
            map = read_smac2_image(image_name, 1)
            par = read_smac2_info(image_name)
            
        elseif read_mode == 4
            map = read_smac1_fits_image(image_name, 1)
            par = read_smac1_fits_info(image_name)
        end
    else
        map = map_arr[Nfile]
        par = par_arr[Nfile]
    end

    # transpose map to match imshow and scatter
    return map', par
end

function smooth_map!(map, smooth_size, par)
    pixelSideLength = (par.x_lim[2] - par.x_lim[1]) / par.Npixels[1]
    smooth_pixel = smooth_size ./ pixelSideLength ./ 2
    map = imfilter(map, reflect(Kernel.gaussian((smooth_pixel[1], smooth_pixel[2]), (par.Npixels[1] - 1, par.Npixels[1] - 1))))
    return map
end


function get_contours(contour_map, r, par, i_circle)

    for i = 1:par.Npixels[1], j = 1:par.Npixels[2]
        r_map = √((i-0.5par.Npixels[1])^2 + (j-0.5par.Npixels[2])^2)
        if r_map <= r 
            contour_map[i,j] = i_circle
        end
    end

    contour_map
end

function get_circle_contours(ax, r_circles, circle_labels, circle_alpha, circle_lines, par)

    pixelSideLength = (par.x_lim[2] - par.x_lim[1]) / par.Npixels[1]

    contour_map = zeros(par.Npixels[1], par.Npixels[2])

    sorted = reverse(sortperm(r_circles))

    for i = 1:length(r_circles)
        # circle radius in pixel units
        r = r_circles[sorted[i]] / pixelSideLength

        contour_map = get_contours(contour_map, r, par, circle_labels[sorted[i]])
    end

    CS = ax.contour(collect(1:par.Npixels[1]), collect(1:par.Npixels[2]), 
        contour_map, levels=circle_labels,
                    colors="w", alpha=circle_alpha, linestyles=circle_lines)

    ax.clabel(CS, CS.levels, inline=true, fmt=circle_labels[sorted])

    return ax
end