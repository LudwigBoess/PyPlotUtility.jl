using Documenter
using PyPlotUtility

makedocs(
    sitename = "PyPlotUtility",
    format = Documenter.HTML(),
    modules = [PyPlotUtility],
    pages = [
        "Table of Contents" => "index.md",
        "Install" => "install.md",
        "Kernels" => "plot_utility.md",
        "Extending" => "calc_utility.md",
        "SPH Functions" => "propaganda_plot.md"
    ]
)

# Documenter can also automatically deploy documentation to gh-pages.
# See "Hosting Documentation" and deploydocs() in the Documenter manual
# for more information.

deploydocs(
    repo = "github.com/LudwigBoess/PyPlotUtility.jl.git",
    devbranch = "master"
)
