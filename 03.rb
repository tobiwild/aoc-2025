def solve(digits, size)
  left = 0
  size.downto(1).map do |right|
    num, i = digits[left..-right].each_with_index.max_by { |v, _| v }
    left += i + 1
    num
  end
end

p1 = 0
p2 = 0

ARGF.each_line(chomp: true) do |line|
  digits = line.chars.map(&:to_i)

  p1 += solve(digits, 2).join.to_i
  p2 += solve(digits, 12).join.to_i
end

puts p1
puts p2
