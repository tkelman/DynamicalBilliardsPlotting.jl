export plot_billiard


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
