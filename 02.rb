p1 = 0
p2 = 0

ARGF.read.scan(/(\d+)-(\d+)/).each do |left, right|
  left, right = left.to_i, right.to_i
  (left..right).each do |n|
    ns = n.to_s
    h = ns.size / 2
    p1 += n if ns.size.even? && ns[...h] == ns[h..]
    invalid = (1..h).any? do |i|
      ns.size % i == 0 && ns == ns[...i] * (ns.size / i)
    end
    p2 += n if invalid
  end
end

puts p1
puts p2
