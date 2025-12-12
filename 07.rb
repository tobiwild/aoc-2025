grid = ARGF.read.split("\n").map(&:chars)
start = grid.shift.index('S')
raise 'no start' if start.nil?

def part1(grid, start)
  cols = [start]

  result = 0

  grid.each do |row|
    new_cols = []
    cols.each do |c|
      if row[c] == '^'
        result += 1
        new_cols << c - 1
        new_cols << c + 1
      else
        new_cols << c
      end
    end
    cols = new_cols.uniq
  end

  result
end

def part2(grid, start)
  seen = {}
  score = lambda do |r, c|
    seen[[r, c]] ||= begin
      return 1 if r > grid.size - 1

      if grid[r][c] == '^'
        return [
          score.call(r + 1, c - 1),
          score.call(r + 1, c + 1)
        ].sum
      end

      score.call(r + 1, c)
    end
  end
  score.call(0, start)
end

puts part1(grid, start)
puts part2(grid, start)
