using DataFrames, CSV

###########
#### Data
fn = "_data/day02.txt"
data = DataFrame(CSV.File(fn, header=false))
rename!(data, ["opponent", "me"])

###########
#### Part 1
## A : rock     B: paper     C: scisor
## X : rock     Y: paper     Z: scisor
score = Dict("X"=>1, "Y"=>2, "Z"=>3)

function getOutcome(row)
    o,m = row
    if (o == "A" && m == "Y") || (o == "B" && m == "Z") || (o == "C" && m == "X")
        return 6
    elseif (o == "A" && m == "X") || (o == "B" && m == "Y") || (o == "C" && m == "Z")
        return 3
    else
        return 0
    end
end


data[!, :selected] = [score[i] for i in data[:, :me]]
data[!, :outcome] = getOutcome.(eachrow(data))
data[!, :score] = data.selected + data.outcome

## What would your total score be if everything goes exactly according to your strategy guide?
sum(data.score)


###########
#### Part 2
## X : lose     Y: draw     Z: win
outcome = Dict("X"=>0, "Y"=>3, "Z"=>6)
selection_win = Dict("A"=>"B", "B"=>"C", "C"=>"A")
selection_lose = Dict("A"=>"C", "B"=>"A", "C"=>"B")
score2 = Dict("A"=>1, "B"=>2, "C"=>3)

function getSelection(row)

end

data[!, :outcome2] = [outcome[i] for i in data[:, :me]]