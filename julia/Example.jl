include("SandwichSolution.jl")  # Include the module file

using .SandwichSolution

# Benchmark parameters
E₁ = E₃ = 500.0
ν₁ = ν₃ = 0.3
E₂ = 100.0
ν₂ = 0.25
Q = -1.0e-2  #positivo deflexao pra cima
M = -5.0e-2 # positivo deflexao pra cima pra cima
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

# Initialize or compute the C matrix here
C = computeC(E, ν, l, h, Q, M, p)

println("(x, y) = ", "(", x, ",", y, ")")
println("layer α = ", α)
println("u₁ = ", u₁(C, x, y, α, E, ν))
println("u₂ = ", u₂(C, x, y, α, E, ν))
println("σ₁₁ = ", σ₁₁(C, x, y, α))
println("σ₂₂ = ", σ₂₂(C, x, y, α))
println("σ₁₂ = ", σ₁₂(C, x, y, α))
