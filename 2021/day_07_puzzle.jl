include("../utils.jl")


### input
### horizontal position of each crab
fn = "2021_07.txt"
input = readInput(fn)
data = parseInput_list(input, ",")

n_fuel = Inf

for p in ProgressBar(1:maximum(datat))
    sum_fuel = sum(abs.(data .- p))
    if sum_fuel < n_fuel
        n_fuel = sum_fuel
    end
end

println("Part 1: How much fuel must they spend to align to that position? ")
println(n_fuel)

function moveCost(n_step::Int64, cost::Int64)
    if n_step == 0
        return cost
    else 
        return moveCost(n_step-1, cost+(n_step))
    end
end

n_fuel_revised = Inf

for p in ProgressBar(1:maximum(data))
    sum_fuel = sum(moveCost.(abs.(data .- p), 0))
    if sum_fuel < n_fuel_revised
        n_fuel_revised = sum_fuel
    end
end

println("Part 2: How much fuel must they spend to align to that position? ")
println(n_fuel_revised)