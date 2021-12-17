```@meta
CurrentModule = PyPlotUtility
DocTestSetup = quote
    using PyPlotUtility
end
```

# Propaganda Plot

I like to make paneled imshow plots. This is a bit of a pain to do every time, so I tried to introduce a kind of Swiss Army Knife plotting function for streamlining this. You can find an example of this e.g. in [Steinwandel, Böss, et al (2021)](https://ui.adsabs.harvard.edu/abs/2021arXiv210807822S/abstract).

![Propaganda Examples](propaganda_plot.png)

```@docs
propaganda_plot_columns
```
