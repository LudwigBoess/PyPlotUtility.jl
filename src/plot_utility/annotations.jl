

function scale_annotation(ax, xmax, ymin, offset, length, width, scale_text, text_offset, annotation_color, fontsize = 15)

    if annotation_color == "w"
        background_color = "k"
    else
        background_color = "w"
    end

    # Line 
    arr = ax.arrow(xmax - length - offset, ymin + offset, length, 0.0, width = width, color = annotation_color,
        length_includes_head = true, head_width = 0.0)

    #arr.set_path_effects([PE.withStroke(linewidth=3, foreground=background_color)])


    # x label
    text_x = xmax - 0.5 * length - offset
    text_y = ymin + text_offset

    txt = ax.text(text_x, text_y, scale_text, color = annotation_color, fontsize = fontsize, 
                horizontalalignment = "center", verticalalignment = "center")

    #txt.set_path_effects([PE.withStroke(linewidth=2, foreground=background_color)])

    ax
end


function time_annotation(ax, xmin, ymax, offset, z_text, annotation_color)

    if annotation_color == "w"
        background_color = "k"
    else
        background_color = "w"
    end

    # x label
    text_x = xmin + offset
    text_y = ymax - offset

    txt = ax.text(text_x, text_y, z_text, color = annotation_color, fontsize = 20, horizontalalignment = "left", verticalalignment = "top")

    #PE = pyimport("matplotlib.patheffects")
    #txt.set_path_effects([PE.withStroke(linewidth=1, foreground=background_color)])

    ax
end


function text_annotation(ax, xmin, ymax, offset, z_text, annotation_color)

    if annotation_color == "w"
        background_color = "k"
    else
        background_color = "w"
    end

    # x label
    text_x = xmin - offset
    text_y = ymax - offset

    txt = ax.text(text_x, text_y, z_text, color = annotation_color, 
                  fontsize = 20, horizontalalignment = "right", verticalalignment = "top")

    #txt.set_path_effects([PE.withStroke(linewidth=1, foreground=background_color)])

    ax
end