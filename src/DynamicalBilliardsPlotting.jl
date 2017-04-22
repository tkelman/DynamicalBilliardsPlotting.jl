"""
Plotting routines and dependencies for the julia package DynamicalBilliards.jl
"""
module DynamicalBilliardsPlotting

using PyPlot, DynamicalBilliards

include("obstacles.jl")
include("billiards.jl")
include("particle.jl")
include("animations.jl")

end
