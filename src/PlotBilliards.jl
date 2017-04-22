using PyPlot, DynamicalBilliards

export plot_obstacle, plot_particle, plot_billiard, plot_cyclotron
export animate_evolution
####################################################
## Plot Obstacles & Billiards
####################################################
"""
```julia
plot_obstacle(obst::Obstacle; kwargs...)
```
Plot given obstacle on the current `PyPlot` figure.

The default arguments for each type of obstacle have been chosen for maximum clarity and
consistency.

The `kwargs...` given by the user are keywords passed directly into PyPlot's
constructors. For `Wall` obstacles, kwargs are passed into `PyPlot.plot()`. For
`Disk` obstacles, kwargs are passed into `PyPlot.plt[:Circle]()`.
"""
function plot_obstacle(d::Disk; kwargs...)
  circle1 = PyPlot.plt[:Circle](d.c, d.r;
  edgecolor = (0,0.6,0), facecolor = (0, 0.6,0, 0.5), kwargs...)
  PyPlot.gca()[:add_artist](circle1)
  PyPlot.show()
end

function plot_obstacle(d::RandomDisk; kwargs...)
  circle1 = PyPlot.plt[:Circle](d.c, d.r;
  edgecolor = (0.8,0.8,0), facecolor = (0.8, 0.8, 0, 0.5), linewidth = 2.0, kwargs...)
  PyPlot.gca()[:add_artist](circle1)
  PyPlot.show()
end

function plot_obstacle(d::Antidot; kwargs...)
  circle1 = PyPlot.plt[:Circle](d.c, d.r;
  edgecolor = (0.8,0.0,0), linewidth = 2.0, facecolor = (0.6, 0.0, 0, 0.1),
  linestyle="dashed", kwargs...)
  PyPlot.gca()[:add_artist](circle1)
  PyPlot.show()
end

function plot_obstacle(w::FiniteWall; kwargs...)
  PyPlot.plot([w.sp[1],w.ep[1]],[w.sp[2],w.ep[2]];
  color=(0,0.6,0), linewidth = 2.0, ms=0, kwargs...)
  PyPlot.show()
end

function plot_obstacle(w::RandomWall; kwargs...)
  PyPlot.plot([w.sp[1],w.ep[1]],[w.sp[2],w.ep[2]];
  color=(0.8,0.8,0), linewidth = 2.0, ms=0, kwargs...)
  PyPlot.show()
end

function plot_obstacle(w::SplitterWall; kwargs...)
  PyPlot.plot([w.sp[1],w.ep[1]],[w.sp[2],w.ep[2]];
  color=(0.8,0.0,0), linewidth = 3.0, linestyle="dashed", kwargs...)
  PyPlot.show()
end

function plot_obstacle(w::PeriodicWall; kwargs...)
  PyPlot.plot([w.sp[1],w.ep[1]],[w.sp[2],w.ep[2]];
  color="purple", linewidth = 1.0, alpha = 0.5, kwargs...)
  PyPlot.show()
end

"""
```julia
plot_billiard(bt::Vector{Obstacle})
```
Plot all obstacles in `bt` using the default arguments, set
`xlim` and `ylim` to be 10% larger than `cellsize` and
set the axis aspect ratio to equal.

```julia
plot_billiard(bt, xmin, ymin, xmax, ymax)
```
Plot the given (periodic) billiard `bt` on the current PyPlot figure, repeatedly
plotting from `(xmin, ymin)` to `(xmax, ymax)`. Only works for rectangular billiards.

```julia
plot_billiard(bt, xt::Vector{Float64}, yt::Vector{Float64}; plot_orbit = true)
```
Plot the given (periodic) billiard `bt` along with a particle trajectory defined
by `xt` and `yt`, on the current PyPlot figure. Only works for rectangular billiards.

Sets limits automatically. Set the keyword argument `plot_orbit = false` to not
plot the orbit defined by `(xt, yt)`.
"""
function plot_billiard(bt::Vector{Obstacle})
  for obst in bt
    plot_obstacle(obst)
  end
  xmin, ymin, xmax, ymax = cellsize(bt)
  dx = xmax - xmin; dy = ymax - ymin
  PyPlot.xlim(xmin - 0.1dx, xmax + 0.1dx)
  PyPlot.ylim(ymin - 0.1dy, ymax + 0.1dy)
  PyPlot.gca()[:set_aspect]("equal")
end


function plot_billiard(bt, xmin, ymin, xmax, ymax)
  # Cell limits:
  cellxmin, cellymin, cellxmax, cellymax = cellsize(bt)
  dcx = cellxmax - cellxmin
  dcy = cellymax - cellymin
  # Obstacles to plot:
  toplot = Obstacle[]
  for obst in bt
    (typeof(obst) == PeriodicWall) && continue
    push!(toplot, obst)
  end
  # Find displacement vectors (they will multiply dcx, dcy)
  dx = (floor((xmin - cellxmin)/dcx):1:ceil((xmax - cellxmax)/dcx))*dcx
  dy = (floor((ymin - cellymin)/dcy):1:ceil((ymax - cellymax)/dcy))*dcy
  # Plot displaced Obstacles
  for x in dx
    for y in dy
      disp = SVector(x,y)
      for obst in toplot
        plot_obstacle(translation(obst, disp))
      end
    end
  end
  # Set limits etc.
  PyPlot.xlim(xmin, xmax)
  PyPlot.ylim(ymin, ymax)
  PyPlot.gca()[:set_aspect]("equal")
end

function plot_billiard(bt, xt::Vector{Float64}, yt::Vector{Float64}; plot_orbit = true)
  xmin = floor(minimum(round(xt,8))); xmax = ceil(maximum(round(xt,8)))
  ymin = floor(minimum(round(yt,8))); ymax = ceil(maximum(round(yt,8)))
  if plot_orbit
    plot(xt, yt, color = "blue")
  end

  plot_billiard(bt, xmin, ymin, xmax, ymax)
end


"""
```julia
translation(obst::Obstacle, vector)
```
Create a copy of the given obstacle with its position
translated by by `vector`.
"""
function translation(d::Circular, vec)
  newd = typeof(d)(d.c .+ vec, d.r)
end

function translation(w::Wall, vec)
  neww = typeof(w)(w.sp .+ vec, w.ep .+ vec, w.normal)
end



####################################################
## Plot Particle
####################################################

"""
```julia
plot_cyclotron(p::MagneticParticle; use_cell=true, kwargs...)
```
Plot the circle traced by the free particle motion. Optionally use `p.current_cell` for
the particle's position. The user provided `kwargs...` are passed onto `PyPlot.plt[:Circle]()`.
"""
function plot_cyclotron(p::MagneticParticle; use_cell=true, kwargs...)
  ω = p.omega
  pos = use_cell ? p.pos + p.current_cell : p.pos
  c = pos - (1/ω)*[p.vel[2], -p.vel[1]]
  r = abs(1/ω)
  circle1 = PyPlot.plt[:Circle](c, r,
  edgecolor = (0.0,0.0,0.8, 0.5), linewidth = 2.0, facecolor = (0., 0.0, 0.8, 0.05),
  kwargs...)
  PyPlot.gca()[:add_artist](circle1)
  PyPlot.show()
end

"""
```julia
plot_particle(p::AbstractParticle; use_cell=true, kwargs...)
```
Plot given particle on the current `PyPlot` figure. Optionally use `p.current_cell` for
the particle's position. Given `kwargs...` are passed onto `PyPlot.scatter()`.

The particle is represented as a small ball (`PyPlot.scatter()`) and a small arrow (`PyPlot.quiver()`).
All `kwargs...` are given to `scatter()` but if a keyword argument `color` is given,
it is also passed to `quiver()`.
"""
function plot_particle(p::AbstractParticle; use_cell=true, kwargs...)
  pos = use_cell ? p.pos + p.current_cell : p.pos
  kwargs = Dict(kwargs)
  # Set same color for arrow and point:
  if haskey(kwargs, :color)
    c = kwargs[:color]
  else
    c = (0,0,0)
  end
  # Plot position:
  s1 = scatter(pos...; color=c, s= 30.0, kwargs...)
  # Plot velocity:
  q1 = quiver(pos..., 0.08p.vel...; angles = "xy", scale = 1, width = 0.005, color=c)
  return s1, q1
end

####################################################
## Animate Particle
####################################################

"""
```julia
animate_evolution(p, bt, colnumber[, ray-splitter]; kwargs)
```
Animate the evolution of the particle, plotting the orbit from collision to collision.

Notice the difference with `evolve!()`: No time is given here; instead a number of
collisions is passed.

## Arguments
* `p::AbstractParticle` : Either standard or magnetic.
* `bt::Vector{Obstacle}` : The billiard table.
* `colnumber::Int` : Number of collisions to evolve the particle for.
* `ray-splitter::Dict{Int, Any}` : (Optional) Ray-splitting dictionary
  that enables ray-splitting processes during evolution.
## Keyword Arguments
* `sleeptime` : Time passed to `sleep()` between each collision.
* `col_to_plot` : How many previous collisions are shown during the animation.
* `savefigs` : Save .png figures to enable the creation of animation afterwards.
  **WARNING:** currently the .gif production has to be made by the user!
* `savename` : Name (**including path!**) of the figures to be produced. The ending
  "\_i.png" will be attached to all figures.
* `particle_kwargs` : Either a Dict{Symbol, Any} or a vector of Tuple{Symbol, Any}.
  Keywords passed into `plot_particle()`.
* `orbit_kwargs` : Either a Dict{Symbol, Any} or a Vector of Tuple{Symbol, Any}.
  Keywords passed into `PyPlot.plot()` which plots the orbit of the particle.
"""
function animate_evolution(p::AbstractParticle, bt, colnumber;
  sleeptime = 0.1, col_to_plot = 5, savefigs = false, savename = "",
  particle_kwargs = nothing, orbit_kwargs = nothing)

  sleeptime == 0 && (sleeptime = 1e-6)
  ε = eps()
  i=0
  xdata = Vector{Float64}[]
  ydata = Vector{Float64}[]

  while i < colnumber

    xt, yt, vxt, vyt, ts = construct(evolve!(p, bt, ε)...)

    if i < col_to_plot
      push!(xdata, xt)
      push!(ydata, yt)
    else
      shift!(xdata); shift!(ydata)
      push!(xdata, xt); push!(ydata, yt)
    end

    xpd = Float64[]
    for el in xdata; append!(xpd, el); end

    ypd = Float64[]
    for el in ydata; append!(ypd, el); end

    if i == 0
      if orbit_kwargs != nothing
        line, = plot(xpd, ypd; orbit_kwargs...)
      else
        line, = plot(xpd, ypd; color = "blue")
      end
    end
    line[:set_xdata](xpd)
    line[:set_ydata](ypd)

    if particle_kwargs != nothing
      point, quiv = plot_particle(p; particle_kwargs...)
    else
      point, quiv = plot_particle(p)
    end

    if savefigs
      s = savename*"_$(i+1).png"
      savefig(s, dpi = 60, bbox_inches="tight")
    end


    sleep(sleeptime)
    if i < colnumber - 1
      point[:remove]()
      quiv[:remove]()
    end
    i+=1
  end
end

# Magnetic + Ray-splitting
function animate_evolution(p::AbstractParticle, bt,
  colnumber, rayspl::Dict;
  sleeptime = 0.1, col_to_plot = 5, orbit_color = (0,0,1),
  savefigs = false, savename = "", particle_color = (0,0,0),
  particle_kwargs = nothing, orbit_kwargs = nothing)

  sleeptime == 0 && (sleeptime = 1e-6)
  ε = eps()
  i=0
  xdata = Vector{Float64}[]
  ydata = Vector{Float64}[]

  while i < colnumber

    xt, yt, vxt, vyt, ts = construct(evolve!(p, bt, ε, rayspl)...)

    if i < col_to_plot
      push!(xdata, xt)
      push!(ydata, yt)
    else
      shift!(xdata); shift!(ydata)
      push!(xdata, xt); push!(ydata, yt)
    end

    xpd = Float64[]
    for el in xdata; append!(xpd, el); end

    ypd = Float64[]
    for el in ydata; append!(ypd, el); end

    if i == 0
      if orbit_kwargs != nothing
        line, = plot(xpd, ypd; orbit_kwargs...)
      else
        line, = plot(xpd, ypd; color = "blue")
      end
    end
    line[:set_xdata](xpd)
    line[:set_ydata](ypd)

    if particle_kwargs != nothing
      point, quiv = plot_particle(p; particle_kwargs...)
    else
      point, quiv = plot_particle(p)
    end

    if savefigs
      s = savename*"_$(i+1).png"
      savefig(s, dpi = 60, bbox_inches="tight")
    end

    sleep(sleeptime)

    if i < colnumber - 1
      point[:remove]()
      quiv[:remove]()
    end
    i+=1
  end
end
