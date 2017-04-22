![DynamicalBilliards Logo: The Julia billiard](http://i.imgur.com/NKgzYrt.gif)

`DynamicalBilliards.jl` is a Julia package for dynamical billiard systems in two dimensions.
The goals of the package is to provide a flexible and intuitive framework for fast implementation of billiard systems of arbitrary construction. The current repo, `DynamicalBilliardsPlotting.jl` provides plotting routines and dependencies to the core package.

Documentation: [Stable](https://Datseris.github.io/DynamicalBilliards.jl/stable) or [Latest](https://Datseris.github.io/DynamicalBilliards.jl/latest).

## Installation
The core package is registered, simply use `Pkg.add("DynamicalBilliards")` to install it.

All plotting is done though `PyPlot`, therefore the present package has a dependency on it. If you are having trouble installing PyPlot you can always use the minimal Python installation through miniconda by running these lines in your Julia terminal:

```julia
ENV["PYTHON"]=""; Pkg.add("PyCall"); Pkg.build("PyCall");
Pkg.add("PyPlot"); using PyPlot;
```

After you have installed `PyPlot`, install this package either with `Pkg.clone("https://github.com/Datseris/DynamicalBilliardsPlotting.jl")` or, when it is registered, simply `Pkg.add("DynamicalBilliardsPlotting")`.
