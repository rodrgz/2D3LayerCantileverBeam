include("SandwichSolution.jl")

using .SandwichSolution
using Plots

# Benchmark parameters
E₁ = E₃ = 500.0
ν₁ = ν₃ = 0.3
E₂ = 100.0
ν₂ = 0.25
Q = -1.0e-2
M = 5.0e-2
p₁ = 3.0
p₂ = 2.0 / 5.0
l = 5.0
h₁ = h₃ = 0.25
h₂ = 0.5

E = [E₁, E₂, E₃]
ν = [ν₁, ν₂, ν₃]
h = [h₁, h₂, h₃]
p = [p₁, p₂]

# Compute C matrix
C = compute_C(E, ν, l, h, Q, M, p)

# Create a grid of x and y values
x_grid = range(0, l, length = 100)
y_grid = range(-h₁, h₂ + h₃, length = 20)
X = repeat(x_grid, 1, length(y_grid))
Y = repeat(y_grid, 1, length(x_grid))'

# Extract outer boundary points
x_outer = [x_grid; reverse(x_grid); x_grid[1]]
y_outer = [-h₁ .* ones(length(x_grid)); (h₂ + h₃) .* ones(length(x_grid)); -h₁]

# Initialize arrays to store stress and displacement values
u₁_grid = similar(X)
u₂_grid = similar(Y)
σ₁₁_grid = similar(X)
σ₂₂_grid = similar(X)
σ₁₂_grid = similar(X)
u₁_outer = similar(x_outer)
u₂_outer = similar(y_outer)
σ₁₁_outer = similar(x_outer)
σ₂₂_outer = similar(y_outer)
σ₁₂_outer = similar(x_outer)

# Calculate stress and displacement values for each point in the grid
for i = 1:length(x_grid)
    for j = 1:length(y_grid)
        x = X[i, j]
        y = Y[i, j]

        # Determine the appropriate layer index i based on y
        index = ifelse(y < 0, 1, y > h₂ ? 3 : 2)

        # Calculate displacements and stresses at this point
        u₁_grid[i, j] = u₁(C, x, y, index, E, ν)
        u₂_grid[i, j] = u₂(C, x, y, index, E, ν)
        σ₁₁_grid[i, j] = σ₁₁(C, x, y, index)
        σ₂₂_grid[i, j] = σ₂₂(C, x, y, index)
        σ₁₂_grid[i, j] = σ₁₂(C, x, y, index)

    end
end

for i = 1:length(x_outer)
    x = x_outer[i]
    y = y_outer[i]

    # Determine the appropriate layer index i based on y
    index = ifelse(y < 0, 1, y > h₂ ? 3 : 2)

    # Calculate displacements and stresses at this point
    u₁_outer[i] = u₁(C, x, y, index, E, ν)
    u₂_outer[i] = u₂(C, x, y, index, E, ν)
    σ₁₁_outer[i] = σ₁₁(C, x, y, index)
    σ₂₂_outer[i] = σ₂₂(C, x, y, index)
    σ₁₂_outer[i] = σ₁₂(C, x, y, index)
end


num_contours = 20

# Plotting and saving in svg format
contourf(
    x_grid,
    y_grid,
    u₁_grid',
    xlabel = "x",
    ylabel = "y",
    title = "u₁",
    aspect_ratio = :equal,
    color = :turbo,
    clims = (-maximum(abs.(u₁_grid)), maximum(abs.(u₁_grid))),
    levels = num_contours,
    yflip = true,
)
savefig("u1.svg")

contourf(
    x_grid,
    y_grid,
    u₂_grid',
    xlabel = "x",
    ylabel = "y",
    title = "u₂",
    aspect_ratio = :equal,
    color = :turbo,
    clims = (-maximum(abs.(u₂_grid)), maximum(abs.(u₂_grid))),
    levels = num_contours,
    yflip = true,
)
savefig("u2.svg")

contourf(
    x_grid,
    y_grid,
    σ₁₁_grid',
    xlabel = "x",
    ylabel = "y",
    title = "Stress (σ₁₁)",
    aspect_ratio = :equal,
    color = :turbo,
    clims = (-maximum(abs.(σ₁₁_grid)), maximum(abs.(σ₁₁_grid))),
    levels = num_contours,
    yflip = true,
)
savefig("sigma11.svg")

contourf(
    x_grid,
    y_grid,
    σ₂₂_grid',
    xlabel = "x",
    ylabel = "y",
    title = "σ₂₂",
    aspect_ratio = :equal,
    color = :turbo,
    clims = (-maximum(abs.(σ₂₂_grid)), maximum(abs.(σ₂₂_grid))),
    levels = num_contours,
    yflip = true,
)
savefig("sigma22.svg")

contourf(
    x_grid,
    y_grid,
    σ₁₂_grid',
    xlabel = "x",
    ylabel = "y",
    title = "σ₁₂",
    aspect_ratio = :equal,
    color = :turbo,
    clims = (-maximum(abs.(σ₁₂_grid)), maximum(abs.(σ₁₂_grid))),
    levels = num_contours,
    yflip = true,
)
savefig("sigma12.svg")

# Create a deformed grid by adding displacements to original coordinates
scale = 0.1
u₁_outer *= scale
u₂_outer *= scale

# Plot deformed and undeformed beams
plot(
    x_outer,
    y_outer,
    linecolor = :black,
    yflip = true,
    aspect_ratio = :equal,
    label = "Undeformed Boundary",
)
plot!(
    x_outer .+ u₁_outer,
    y_outer .+ u₂_outer,
    linecolor = :red,
    yflip = true,
    aspect_ratio = :equal,
    label = "Deformed Boundary",
)
xlabel!("x")
ylabel!("y")

savefig("deformed.svg")
