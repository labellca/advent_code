include("../utils.jl")

### input
### Unique signal patterns + output value
fn = "2021_08.txt"
input = readInput(fn)
data = parseInput_list.(input, " | ", "S")

n = length(data)
signals = [String.(split(i[1], " ")) for i in data]
outputs = [String.(split(i[2], " ")) for i in data]
entry_lines = [vcat(signals[i], outputs[i]) for i in 1:n]

function numberDigits_easy(entry::Array{String})
    entry_length = length.(entry)
    n_segment = Dict(1=>0, 2=>1, 3=>7, 4=>4, 5=>0, 6=>0, 7=>8)

    entry_int = [n_segment[i] for i in entry_length]
    return filter(x -> x != 0, entry_int[end-3:end]) |> length
end

n_digits = numberDigits_easy.(entry_lines) |> sum
println("Part 1: In the output values, how many times do digits 1, 4, 7, or 8 appear?")
println(n_digits)

function fragmentSum(fragment_counts::Dict, fragments)
    return sum([fragment_counts[i] for i in fragments])
end

function numberDigits_sum(entry::Array{String})
    entry_signal = join(entry[1:10], "")
    random_fragment_counts = countmap(entry_signal)

    entry_output = entry[11:end]
    digit_fragment_sum_output = [fragmentSum(random_fragment_counts, d) for d in entry_output]
    return parse(Int64, join([string(digit_fragment_sum_init[d]) for d in digit_fragment_sum_output], ""))
end

digit_layout = Dict(0 => [1,2,3,5,6,7],
                    1 => [3, 6],
                    2 => [1,3,4,5,7],
                    3 => [1,3,4,6,7],
                    4 => [2,3,4,6],
                    5 => [1,2,4,6,7],
                    6 => [1,2,4,5,6,7],
                    7 => [1,3,6],
                    8 => [1,2,3,4,5,6,7],
                    9 => [1,2,3,4,6,7])
fragment_counts_init = countmap(vcat(values(digit_layout)...))
digit_fragment_sum_init = Dict(fragmentSum(fragment_counts_init, digit_layout[k]) => k for k in keys(digit_layout))

sum_output_digits = sum(numberDigits_sum.(entry_lines))
println("Part 2: What do you get if you add up all of the output values?")
println(sum_output_digits)