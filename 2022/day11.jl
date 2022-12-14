###########
#### Data
fn = "_data/day11.txt"
f = open(fn, "r")
data  = readlines(f)
close(f)

monkeys = Dict()
monkey_nb = 0

### Parse info
for line in data
    info = split(line, " ")

    if length(info) == 1
        ### line with no information
        continue

    elseif  info[1] == "Monkey"
        ### identify monkey to consider
        monkey_nb = parse(Int64, info[2][1:end-1])
        monkeys[monkey_nb] = Dict()

        ### initiate monkey list of items
        monkeys[monkey_nb]["items"] = []

    elseif info[3] == "Starting"
        ### add initial items to each monkey
        for val in info[5:end]
            push!(monkeys[monkey_nb]["items"], parse(Int, replace(val, "," => ""))) 
        end
    
    elseif info[3] == "Operation:"
        monkeys[monkey_nb]["operation"] = Meta.parse(join(info[6:end]))
    
    elseif info[3] == "Test:"
        monkeys[monkey_nb]["test"] = [parse(Int64, info[6])]

    elseif info[6] == "true:"
        push!(monkeys[monkey_nb]["test"], parse(Int64, info[10]))
    elseif info[6] == "false:"
        push!(monkeys[monkey_nb]["test"], parse(Int64, info[10]))
    end
end


###########
#### Part 1
monkeys_1 = deepcopy(monkeys)
round = 1
nb_items_inspected = zeros(Int64, length(monkeys_1))
old = 0

while round <= 20
    for monkey in 0:length(monkeys_1)-1
        info = monkeys_1[monkey]
        for i in info["items"]
            nb_items_inspected[monkey+1] += 1
            old = i
            ## Monkey inspect + get bored
            new = floor(eval(info["operation"]) / 3)
            
            ## Monkey test + toss
            if new % info["test"][1] == 0
                push!(monkeys_1[info["test"][2]]["items"], new)
            else 
                push!(monkeys_1[info["test"][3]]["items"], new)
            end
        end
        monkeys_1[monkey]["items"] = []
    end
    println(nb_items_inspected)
    round += 1
end

## Figure out which monkeys to chase by counting how many items they inspect over 20 rounds. What is the level of monkey business after 20 rounds of stuff-slinging simian shenanigans?
prod(sort!(nb_items_inspected, rev=true)[1:2])


###########
#### Part 2
monkeys_2 = deepcopy(monkeys)
round = 0
nb_items_inspected = zeros(Int64, length(monkeys_2))
old = 0

### find mega-modulo from all divisible
### change each >new> value to new % mm
mm = prod([monkeys_2[x]["test"][1] for x in keys(monkeys_2)])

while round < 10000
    if round % 100 == 0
        print("=")
    end
        
    for monkey in 0:length(monkeys_2)-1
        info = monkeys_2[monkey]

        for i in info["items"]
            nb_items_inspected[monkey+1] += 1
            old = i
            ## Monkey inspect
            new = abs(eval(info["operation"]) % mm)

            ## Monkey test + toss
            if new % info["test"][1] == 0
                push!(monkeys_2[info["test"][2]]["items"], abs(new) )
            else 
                push!(monkeys_2[info["test"][3]]["items"], abs(new) )
            end
        end
        monkeys_2[monkey]["items"] = []
    end
    round += 1
end

## Worry levels are no longer divided by three after each item is inspected; you'll need to find another way to keep your worry levels manageable. 
## Starting again from the initial state in your puzzle input, what is the level of monkey business after 10000 rounds?
prod(sort!(nb_items_inspected, rev=true)[1:2])