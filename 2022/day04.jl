using CSV, DataFrames

###########
#### Data
fn = "_data/day04.txt"
data = DataFrame(CSV.File(fn, header=false, types=String))
rename!(data, ["elf1", "elf2"])

tmp1 = [parse.(Int64, i) for i in split.(data.elf1, "-")]
tmp2 = [parse.(Int64, i) for i in split.(data.elf2, "-")]

insertcols!(data, [n => getindex.(tmp1, i) for (i, n) in
                        enumerate([:elf1_first, :elf1_last])]...)
insertcols!(data, [n => getindex.(tmp2, i) for (i, n) in
                        enumerate([:elf2_first, :elf2_last])]...)
###########
#### Part 1                  
## In how many assignment pairs does one range fully contain the other?
sum((data.elf1_first .<= data.elf2_first) .&& (data.elf1_last .>= data.elf2_last ) .|| 
    (data.elf2_first .<= data.elf1_first) .&& (data.elf2_last .>= data.elf1_last ))

###########
#### Part 2
sum(.!((data.elf1_first .> data.elf2_last) .|| (data.elf2_first .> data.elf1_last)))