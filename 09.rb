input = ARGF
        .read
        .split("\n")
        .map { it.split(',').map(&:to_i) }

# part 1
input
  .combination(2)
  .map { it.transpose.map { it.reduce(:-).abs.succ }.reduce(:*) }
  .max
  .tap { puts it }

# part 2
def build_ranges(rows, cols)
  rows = rows.keys.sort
  ranges = []
  start = rows.first
  active_range = nil
  (rows.first..rows.last).each do |row|
    new_range = cols.filter { _2.include? row }.keys.sort.then do
      it.first..it.last
    end
    if active_range && active_range != new_range
      ranges << [start..row - 1, active_range]
      start = row
    end
    ranges << [start..row, new_range] if row == rows.last
    active_range = new_range
  end
  ranges
end

cols = input.group_by { it[0] }.transform_values { it.map { it[1] }.sort.then { _1.._2 } }
rows = input.group_by { it[1] }.transform_values { it.map { it[0] }.sort.then { _1.._2 } }
# ranges describes the rectangles of the red/green tiles
# the ranges for the example are
# [[1..2, 7..11], [3..5, 2..11], [6..7, 9..11]]
ranges = build_ranges(rows, cols)

input
  .combination(2)
  .filter do |pair|
    cs, rs = pair.transpose
    cs = cs.sort.then { _1.._2 }
    rs = rs.sort.then { _1.._2 }
    ranges.each do |rrs, ccs|
      break unless rs.min

      rs = (rrs.max + 1)..rs.max if rrs.min <= rs.min && rrs.max >= rs.min && ccs.cover?(cs)
    end
    rs.size == 0
  end
  .map { it.transpose.map { it.reduce(:-).abs.succ }.reduce(:*) }
  .max
  .tap { puts it }
