| **Documentation**                                                 | **Build Status**                                                                                | **License**                                                                                | **Version Status** |
|:-----------------------------------------------------------------:|:-----------------------------------------------------------------------------------------------:| :-----------------------------------------------------------------------------------------------:|:-----------:|
[![](https://img.shields.io/badge/docs-stable-blue.svg)](https://LudwigBoess.github.io/PyPlotUtility.jl/stable) [![](https://img.shields.io/badge/docs-dev-blue.svg)](https://LudwigBoess.github.io/PyPlotUtility.jl/dev) | [![Build Status](https://github.com/LudwigBoess/PyPlotUtility.jl/actions/workflows/jlpkgbutler-ci-master-workflow.yml/badge.svg)](https://github.com/LudwigBoess/PyPlotUtility.jl/actions/workflows/jlpkgbutler-ci-master-workflow.yml) [![codecov.io](https://codecov.io/gh/LudwigBoess/PyPlotUtility.jl/coverage.svg?branch=main)](https://codecov.io/gh/LudwigBoess/PyPlotUtility.jl?branch=main) | [![The MIT License](https://img.shields.io/badge/license-MIT-orange.svg)](LICENSE.md) | ![TagBot](https://github.com/LudwigBoess/PyPlotUtility.jl/workflows/TagBot/badge.svg) [![CompatHelper](https://github.com/LudwigBoess/PyPlotUtility.jl/actions/workflows/jlpkgbutler-compathelper-workflow.yml/badge.svg)](https://github.com/LudwigBoess/PyPlotUtility.jl/actions/workflows/jlpkgbutler-compathelper-workflow.yml) |


# PyPlotUtility.jl

A number of plotting utilities for PyPlot. Please see the [Documentation](https://LudwigBoess.github.io/PyPlotUtility.jl/dev).

# Example

You can do a simple plot with my default styling by using

```julia
using PyPlot, PyPlotUtility

fig = get_figure()
plot_styling!()

ax = gca()
axis_ticks_styling!(ax)
ax.set_xlabel("x")
ax.set_ylabel("y")

plot(rand(10), rand(10), label="example")

legend(frameon=false)

savefig(plot_name, bbox_inches="tight")
```