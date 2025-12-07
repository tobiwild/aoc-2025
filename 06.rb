def part1(input)
  grid = input.split("\n").map(&:split)
  grid.transpose.sum do |nums|
    op = nums.pop
    nums = nums.map(&:to_i)
    nums.reduce(op)
  end
end

def part2(input)
  rows = input.split("\n")
  ops = rows.pop.split.reverse
  rows
    .map { it.chars.reverse }
    .transpose
    .map { it.join.strip }
    .chunk { it == '' ? :_separator : true }
    .sum { _2.map(&:to_i).reduce(ops.shift) }
end

input = ARGF.read
puts part1(input)
puts part2(input)
