###########
#### Data
fn = "_data/day03.txt"
f = open(fn, "r")
data  = readlines(f)
close(f)

###########
#### Part 1
N = length(data)
compartment_length = Int.(length.(data) ./ 2)
priority = Array{Int, 1}(undef, N)
alphabet = "abcdefghijklmnopqrstuvwxyz"

function getCommon(p1::String, p2::String)
    for i in p1
        if occursin(string(i), p2)
            return i
        end
    end
end

for i in 1:N
   part1 = data[i][1:compartment_length[i]]
   part2 = data[i][compartment_length[i]+1:end] 
   item = getCommon(part1, part2)

   pos = findfirst(lowercase(string(item)), alphabet)[1]
   if isuppercase(item)
        priority[i] = pos+length(alphabet)
   else
        priority[i] = pos
   end
end

## What is the sum of the priorities of those item types?
sum(priority)


###########
#### Part 2
badge_priority = Array{Int, 1}(undef, Int(N/3))
group_nb = 1

function getCommon3(p1::String, p2::String, p3::String)
    for i in p1
        if occursin(string(i), p2) && occursin(string(i), p3)
            return i
        end
    end
end

for i in 1:3:N
    part1 = data[i]
    part2 = data[i+1]
    part3 = data[i+2]

    badge = getCommon3(part1, part2, part3)
    pos = findfirst(lowercase(string(badge)), alphabet)[1]

    if isuppercase(badge)
        badge_priority[group_nb] = pos+length(alphabet)
   else
        badge_priority[group_nb] = pos
   end

   group_nb += 1
end

## What is the sum of the priorities of those item types?
sum(badge_priority)