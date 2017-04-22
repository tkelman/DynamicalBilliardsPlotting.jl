using DynamicalBilliards
using DynamicalBilliardsPlotting
using PyPlot
using Base.Test

bt = billiard_sinai(0.25)

@test plot_billiard(bt)
