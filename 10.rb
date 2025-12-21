p1 = 0

ARGF.each_line do |line|
  lights_target = line[/\[(.*?)\]/, 1].chars.map { it == '#' }
  buttons = line
            .scan(/\((.*?)\)/)
            .map { it.first.split(',').map(&:to_i) }

  p1 += (1..buttons.size).find do |combo|
    buttons.combination(combo).any? do |group|
      lights = [false] * lights_target.size
      group.flatten.each { lights[it] = !lights[it] }
      lights == lights_target
    end
  end
end

puts p1
