ranges, ids = ARGF.read.split("\n\n")
ranges = ranges.split("\n").map do
  it.split('-')
    .map(&:to_i)
    .then { (_1.._2) }
end
ids = ids.split("\n").map(&:to_i)

# part 1
puts(ids.count { |id| ranges.any? { it.include?(id) } })

# part 2
ranges.sort_by!(&:min)
min = -1
p2 = 0
ranges.each do |r|
  p2 += ([r.min, min].max..r.max).size
  min = [min, r.max + 1].max
end

puts p2
