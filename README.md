![DynamicalBilliards Logo: The Julia billiard](http://i.imgur.com/NKgzYrt.gif)

A Julia package for dynamical billiard systems in two dimensions.
The goals of the package is to provide a flexible and intuitive framework for fast implementation of billiard systems of arbitrary construction.

<center>

| **Documentation**   | [**Package Evaluator**](http://pkg.julialang.org/?pkg=DynamicalBilliards#DynamicalBilliards) | **Build Status**     |
|:--------:|:-------------------:|:-----------------------:|
| [![](https://img.shields.io/badge/docs-stable-blue.svg)](https://Datseris.github.io/DynamicalBilliards.jl/stable) |[![](http://pkg.julialang.org/badges/DynamicalBilliards_0.5.svg)](http://pkg.julialang.org/?pkg=DynamicalBilliards) | [![Build Status](https://travis-ci.org/Datseris/DynamicalBilliards.jl.svg?branch=master)](https://travis-ci.org/Datseris/DynamicalBilliards.jl) |
| [![](https://img.shields.io/badge/docs-latest-blue.svg)](https://Datseris.github.io/DynamicalBilliards.jl/latest) |[![](http://pkg.julialang.org/badges/DynamicalBilliards_0.6.svg)](http://pkg.julialang.org/?pkg=DynamicalBilliards)  | [![Build status](https://ci.appveyor.com/api/projects/status/r087ojfuh2rtrxtm?svg=true)](https://ci.appveyor.com/project/Datseris/dynamicalbilliards-jl)|


</center>

The core of `DynamicalBilliards.jl` is separated in simple and cohesive modular structures:
* **Straight propagation** : The standard billiard dynamical system. A particle is propagating in a straight line, until a specular reflection is performed at a boundary.
* **Magnetic propagation** : Instead of a straight line, the orbit of the particle is a circle, like electrons in a perpendicular magnetic field. The particle still undergoes specular reflections at the boundaries of the billiard.
* **Ray-splitting billiards** : A semiclassical implementation of the dynamical billiard. After a collision of a particle with a boundary, the particle may propagate *through* the boundary given some arbitrary probability and transmission law.
* **Standard billiards** : A library of pre-constructed billiard systems that have already been used in Physics/Mathematics (e.g. Sinai, periodic Sinai, Buminovich etc.)
* **Visualization** : functions for plotting and visualizing aspects of a billiard system, such as obstacles, orbits and more. Also includes animation related content.

**NOTICE:** This package does not support collision between particles (currently). All particles are considered point-particles for all simulations offered by `DynamicalBilliards.jl`.

## Installation
This package is registered, simply use `Pkg.add("DynamicalBilliards")` to install it.

If you want to use the latest features, compatible with the latest documentation, use `Pkg.checkout("DynamicalBilliards")`.

Documentation: [Stable](https://Datseris.github.io/DynamicalBilliards.jl/stable) or [Latest](https://Datseris.github.io/DynamicalBilliards.jl/latest).


### PyPlot
**WARNING:** this package has a dependency on `PyPlot` for its plotting features. If you are having trouble installing PyPlot you can always use the minimal Python installation through miniconda by running these lines in your Julia terminal:

```julia
ENV["PYTHON"]=""; Pkg.add("PyCall"); Pkg.build("PyCall");
Pkg.add("PyPlot"); using PyPlot;
```
