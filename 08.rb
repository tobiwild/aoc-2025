vecs = ARGF.read.split("\n").map { it.split(',').map(&:to_i) }

dists = []
vecs.each_with_index do |vec1, i|
  vecs.each_with_index do |vec2, j|
    next unless i > j

    dist = [
      (vec1[0] - vec2[0])**2,
      (vec1[1] - vec2[1])**2,
      (vec1[2] - vec2[2])**2
    ].sum**0.5
    dists << [dist, i, j]
  end
end

cs = []
dists.sort_by! { it[0] }
p1 = nil
p2 = nil

dists.each_with_index do |(_dist, i, j), iteration|
  if iteration == 1000
    p1 = cs
         .map(&:size)
         .sort
         .last(3)
         .reduce(:*)
  end
  v1 = vecs[i]
  v2 = vecs[j]
  m = [v1, v2]
      .map { |v| cs.index { it.include?(v) } }
      .compact
  next if m.size == 2 && m.uniq.size == 1 # both same circuit

  if m.size == 2
    cs[m[0]].merge(cs[m[1]])
    cs.delete_at(m[1])
  else
    circuit = m[0] ? cs[m[0]] : Set.new.tap { cs << it }
    circuit << v1 << v2
  end
  if cs.size == 1 and cs.first.size == vecs.size
    p2 = v1[0] * v2[0]
    break
  end
end

puts p1
puts p2
