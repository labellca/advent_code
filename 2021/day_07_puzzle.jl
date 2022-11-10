include("../utils.jl")


### input
### horzontal position of each crab
fn = "2021_07.txt"
input = readInput(fn)
data = parseInput_list(input, ",")

position_list = unique(data)
n_fuel = Inf

for p in ProgressBar(position_list)
    sum_fuel = sum(abs.(data .- p))
    if sum_fuel < n_fuel
        n_fuel = sum_fuel
    end
end

println("Part 1: How much fuel must they spend to align to that position? ")
println(n_fuel)

