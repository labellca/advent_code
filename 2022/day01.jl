###########
#### Part 1
fn = "_data/day01.txt"
f = open(fn, "r")
lines  = readlines(f)
close(f)

idx = findall(x -> x == "", lines)
prev = 1
tot_by_elf = Array{Int,1}(undef, length(idx))

for i in 1:length(idx)
    tot_by_elf[i] = sum(parse.(Int, lines[prev:idx[i]-1]))
    prev = idx[i]+1
end

## How many total Calories is that Elf carrying?
maximum(tot_by_elf)



###########
#### Part 2
## How many Calories are those Elves carrying in total?
sum(sort(tot_by_elf)[end-2:end])