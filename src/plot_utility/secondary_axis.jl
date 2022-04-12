using Cosmology
using Unitful
using Printf

"""
    get_z_secondary_axis(ax::PyCall.PyObject, c::Cosmology.AbstractCosmology=cosmology();
                         x_lim::Vector{<:Real}=[2.0, 14.0],
                         z_plot=[15, 4, 2, 1, 0.5, 0.3, 0.2, 0.1, 0])

Adds a secondary x-axis for an axis `ax` with a time series in Gyrs, to show the corresponding redshift based on a cosmology `c`.

## Keyword arguments
* `x_lim`: Limits of the original x axis in Gyrs. 
* `z_plot`: The redshifts at which to set ticks.

"""
function get_z_secondary_axis!(ax::PyCall.PyObject, 
                              c::Cosmology.AbstractCosmology=cosmology();
                              z_plot=[15, 4, 2, 1, 0.5, 0.3, 0.2, 0.1, 0])

    ax2 = ax.twiny()
    ax2.set_xlabel("Redshift  " * L"z")
    ax2.set_xlim(ax.get_xlim())

    ax2.set_xticks([ustrip(age(c, z)) for z in z_plot])
    ax2.set_xticklabels(["$(@sprintf("%0.1f", z))" for z in z_plot])

    ax2.tick_params(direction="in",
                    which="major", size=12, 
                    width=1, color="k")

    return ax2
end


"""
    CR Dimensionless Momentum -> Energy
"""

const me     = 9.10953e-28
const mp     = 1.6726e-24
const cL     = 2.9979e10
const erg2eV = 6.242e+11


function get_cr_energy_axis!(ax::PyCall.PyObject, CR_type::String="p";
                            p_plot::Vector{<:Real}=10.0.^LinRange(0, 6.0, 6))

    ax2 = ax.twiny()
    ax2.set_xscale(ax.get_xscale())

    if CR_type == "p"
        label  = "Proton Energy  " * L"E_p" * " [ GeV ]"
        mass   = mp 
        factor = 1.e-9
    elseif CR_type == "e"
        label  = "Electron Energy  " * L"E_e" * " [ MeV ]"
        mass   = me
        factor = 1.e-6
    else
        error("CR_type must be either 'p' or 'e'!")
    end

    conversion(p) = p * mass*cL^2 * erg2eV * factor

    locmin = plt.LogLocator(base = 10.0, subs = (0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9), numticks = 20)
    ax2.xaxis.set_minor_locator(locmin)
    ax2.xaxis.set_minor_formatter(matplotlib.ticker.NullFormatter())

    locmaj = matplotlib.ticker.LogLocator(base = 10, numticks = 12)
    ax2.xaxis.set_major_locator(locmaj)

    xlim = ax.get_xlim()
    ax2.set_xlim(conversion.(xlim))

    #ax2.set_xticks([p for p in p_plot])
    #ax2.set_xticklabels(["$(@sprintf("%f", p))" for p in p_plot])

    ax2.set_xlabel(label, labelpad = 10)

    ax2.tick_params(direction="in", labelsize=15,
                which="major", size=6, 
                width=1, color="k")

    ax2.tick_params(direction="in", labelsize=15,
                which="minor", size=3, 
                width=1, color="k")

    ax2.minorticks_on()

    return ax2

end
