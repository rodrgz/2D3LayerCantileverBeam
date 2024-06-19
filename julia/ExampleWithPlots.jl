include("SandwichSolution.jl")

using .SandwichSolution
using Plots
using Plots.PlotMeasures

E₁ = E₃ = 500.0
ν₁ = ν₃ = 0.3
E₂ = 100.0
ν₂ = 0.25
Q = -1.0
M = -5.0
p₁ = 2.0
p₂ = 1.0
l = 5.0
h₁ = h₃ = 0.25
h₂ = 0.5

E = [E₁, E₂, E₃]
ν = [ν₁, ν₂, ν₃]
h = [h₁, h₂, h₃]
p = [p₁, p₂]

function calculate_stresses!(σ11, σ22, σ12, X, Y, x_coords, y_coords, E, ν, l, h, Q, M, p)
    for (i, x) in enumerate(x_coords)
        for (j, y) in enumerate(y_coords)
            α = ifelse(y < 0.0, 1, y > h[2] ? 3 : 2)
            σ11[i, j] = σ₁₁(x, y, α, E, ν, l, h, Q, M, p)
            σ22[i, j] = σ₂₂(x, y, α, E, ν, l, h, Q, M, p)
            σ12[i, j] = σ₁₂(x, y, α, E, ν, l, h, Q, M, p)
        end
    end
end

function calculate_displacements!(
    u1::AbstractVector, u2::AbstractVector, X, Y, x_coords, y_coords, E, ν, l, h, Q, M, p,
)
    for (i, x) in enumerate(x_coords)
        y = y_coords[i]
        α = ifelse(y < 0.0, 1, y > h[2] ? 3 : 2)
        u1[i] = u₁(x, y, α, E, ν, l, h, Q, M, p)
        u2[i] = u₂(x, y, α, E, ν, l, h, Q, M, p)
    end
end

function calculate_displacements!(
    u1::AbstractMatrix, u2::AbstractMatrix, X, Y, x_coords, y_coords, E, ν, l, h, Q, M, p,
)
    for (i, x) in enumerate(x_coords)
        for (j, y) in enumerate(y_coords)
            α = ifelse(y < 0.0, 1, y > h[2] ? 3 : 2)
            u1[i, j] = u₁(x, y, α, E, ν, l, h, Q, M, p)
            u2[i, j] = u₂(x, y, α, E, ν, l, h, Q, M, p)
        end
    end
end

# Create a grid of x and y values
x_grid = range(0, l; length = 100)
y_grid = range(-h₁, h₂ + h₃; length = 20)
X = repeat(x_grid, 1, length(y_grid))
Y = repeat(y_grid, 1, length(x_grid))'
u₁_grid = similar(X)
u₂_grid = similar(Y)
σ₁₁_grid = similar(X)
σ₂₂_grid = similar(X)
σ₁₂_grid = similar(X)
calculate_displacements!(u₁_grid, u₂_grid, X, Y, x_grid, y_grid, E, ν, l, h, Q, M, p)
calculate_stresses!(σ₁₁_grid, σ₂₂_grid, σ₁₂_grid, X, Y, x_grid, y_grid, E, ν, l, h, Q, M, p)

# Create an external boundary for plotting deformation
x_outer = [
    x_grid
    x_grid[end]
    x_grid[end]
    reverse(x_grid)
    x_grid[1]
    x_grid[1]
    x_grid[1]
]
y_outer = [
    -h₁ .* ones(length(x_grid))
    0.0
    h₂
    (h₂ + h₃) .* ones(length(x_grid))
    h₂
    0.0
    -h₁
]
u₁_outer = similar(x_outer)
u₂_outer = similar(y_outer)
calculate_displacements!(u₁_outer, u₂_outer, X, Y, x_outer, y_outer, E, ν, l, h, Q, M, p)

# Create an inner boundary (material interfaces) for plotting deformation
x_inner = [x_grid; reverse(x_grid)]
y_inner = [0.0 .* ones(length(x_grid)); h₂ .* ones(length(x_grid))]
u₁_inner = similar(x_inner)
u₂_inner = similar(y_inner)
calculate_displacements!(u₁_inner, u₂_inner, X, Y, x_inner, y_inner, E, ν, l, h, Q, M, p)

function plot_and_save_contour(
    x_grid, y_grid, data_grid, filename, xlabel, ylabel, title, clims, num_contours, h, l,
)
    contourf(
        x_grid, y_grid,
        data_grid';
        xlabel = xlabel,
        ylabel = ylabel,
        title = title,
        aspect_ratio = :equal,
        color = :turbo,
        clims = clims,
        levels = num_contours,
        yflip = true,
        left_margin = 8mm,
        right_margin = 2mm,
    )

    # Plot material interface at y=h[2]
    h_line_y = h[2]
    plot!([0, l], [h_line_y, h_line_y]; linecolor = :magenta, label = "")

    # Plot material interface at y=h[1]
    h_line_y = 0
    plot!([0, l], [h_line_y, h_line_y]; linecolor = :magenta, label = "")

    return savefig(filename)
end

num_contours = 6
xlabel = "x"
ylabel = "y"

# Plot and save each contour plot
plot_and_save_contour(
    x_grid, y_grid, u₁_grid, "u1.svg", xlabel, ylabel, "u₁", (minimum(u₁_grid), maximum(u₁_grid)), num_contours, h, l,
)
plot_and_save_contour(
    x_grid, y_grid, u₂_grid, "u2.svg", xlabel, ylabel, "u₂", (minimum(u₂_grid), maximum(u₂_grid)), num_contours, h, l,
)
plot_and_save_contour(
    x_grid, y_grid, σ₁₁_grid, "sigma11.svg", xlabel, ylabel, "σ₁₁", (minimum(σ₁₁_grid), maximum(σ₁₁_grid)), num_contours, h, l,
)
plot_and_save_contour(
    x_grid, y_grid, σ₂₂_grid, "sigma22.svg", xlabel, ylabel, "σ₂₂", (minimum(σ₂₂_grid), maximum(σ₂₂_grid)), num_contours, h, l,
)
plot_and_save_contour(
    x_grid, y_grid, σ₁₂_grid, "sigma12.svg", xlabel, ylabel, "σ₁₂", (minimum(σ₁₂_grid), maximum(σ₁₂_grid)), num_contours, h, l,
)

# Function to plot boundary
function plot_boundary(x, y, u₁, u₂; label = "", linecolor = :black)
    return plot!(
        x .+ u₁,
        y .+ u₂;
        linecolor = linecolor,
        yflip = true,
        aspect_ratio = :equal,
        label = label,
    )
end

# Create a deformed grid by adding displacements to original coordinates
scale = 0.1
u₁_outer *= scale
u₂_outer *= scale
u₁_inner *= scale
u₂_inner *= scale

# Plot deformed and undeformed beams
plot(
    x_outer, y_outer;
    linecolor = :black,
    yflip = true,
    aspect_ratio = :equal,
    label = "Undeformed Boundary",
)
plot_boundary(x_inner, y_inner, u₁_inner, u₂_inner; label = "")
plot_boundary(
    x_outer,
    y_outer,
    u₁_outer,
    u₂_outer;
    label = "Deformed Boundary",
    linecolor = :red,
)
plot_boundary(x_inner, y_inner, u₁_inner, u₂_inner; linecolor = :red)
xlabel!(xlabel)
ylabel!(ylabel)
savefig("deformed.svg")
