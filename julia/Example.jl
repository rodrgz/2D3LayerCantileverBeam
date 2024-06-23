include("SandwichSolution.jl")

using .SandwichSolution

E₁ = E₃ = 500.0
ν₁ = ν₃ = 0.3
E₂ = 100.0
ν₂ = 0.25
Q = -1.0e-2
M = -5.0e-2
p₁ = 3.0
p₂ = 2.0 / 5.0
l = 5.0
h₁ = h₃ = 0.25
h₂ = 0.5

E = [E₁, E₂, E₃]
ν = [ν₁, ν₂, ν₃]

h = [h₁, h₂, h₃]
p = [p₁, p₂]

# Example values for x, y
x = l / 2.0
y = h₂ / 2.0

# Layer α
α = ifelse(y < 0, 1, y > h₂ ? 3 : 2)

println("(x, y) = ", "(", x, ",", y, ")")
println("layer α = ", α)
println("u₁ = ", u₁(x, y, α, E, ν, l, h, Q, M, p))
println("u₂ = ", u₂(x, y, α, E, ν, l, h, Q, M, p))
println("σ₁₁ = ", σ₁₁(x, y, α, E, ν, l, h, Q, M, p))
println("σ₂₂ = ", σ₂₂(x, y, α, E, ν, l, h, Q, M, p))
println("σ₁₂ = ", σ₁₂(x, y, α, E, ν, l, h, Q, M, p))
