p1 = 0
p2 = 0

dial = 50

ARGF.each_line do |line|
  letter = line[0]
  num = line[1..].to_i
  delta = letter == 'L' ? -1 : 1
  num.times do
    dial += delta
    dial %= 100
    p2 += 1 if dial == 0
  end
  p1 += 1 if dial == 0
end

puts p1
puts p2
