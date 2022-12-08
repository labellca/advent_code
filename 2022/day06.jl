###########
#### Data
fn = "_data/day06.txt"
f = open(fn, "r")
data  = readline(f)
close(f)

function detectSubSignal(data::String, n::Int, label::String)
    N = length(data)

    for i in 1:N
        subsignal = data[i:i+n-1]
        if unique(subsignal) |> length == n
            println("How many characters need to be processed before the first $label marker is detected?")
            println(i+n-1)
            break
        end
    end
end

###########
#### Part 1
detectSubSignal(data, 4, "start-of-packet")

###########
#### Part 2
detectSubSignal(data, 14, "start-of-message")

