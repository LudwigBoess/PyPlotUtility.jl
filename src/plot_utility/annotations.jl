

"""
    Propaganda Plot
"""
function annotate_arrows(ax, xmin, ymin, offset, length, x_text, y_text, text_offset)

    # arrow in x-direction
    ax.arrow(xmin+offset, ymin+offset, length, 0.0, width = 0.1, color="white", length_includes_head=true)

    # arrow in y-direction
    ax.arrow(xmin+offset, ymin+offset, 0.0, length, width = 0.1, color="white", length_includes_head=true)

    # x label
    text_x = xmin+offset+length+text_offset
    text_y = ymin+offset

    ax.text(text_x, text_y, x_text, color="white", fontsize=15, horizontalalignment="center", verticalalignment="center")

    # y label
    text_x = xmin+offset
    text_y = ymin+offset+length+text_offset

    ax.text(text_x, text_y, y_text, color="white", fontsize=15, horizontalalignment="center", verticalalignment="center")
end

function annotate_scale(ax, xmax, ymin, offset, length, scale_text, text_offset)

    # Line 
    ax.arrow(xmax-length-offset, ymin+offset, length, 0.0, width = 0.1, color="white", 
        length_includes_head=true, head_width=0.0)

    # x label
    text_x = xmax-0.5*length-offset
    text_y = ymin+text_offset

    ax.text(text_x, text_y, scale_text, color="white", fontsize=15, horizontalalignment="center", verticalalignment="center")
end

function annotate_redshift(ax, xmin, ymax, offset, z_text)

    # x label
    text_x = xmin+offset
    text_y = ymax-offset

    ax.text(text_x, text_y, z_text, color="white", fontsize=20, horizontalalignment="left", verticalalignment="top")
end