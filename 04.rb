def get(arr, *indexes)
  indexes.reduce(arr) do |a, idx|
    return nil if idx < 0

    a&.[](idx)
  end
end

dirs = [
  [-1, -1],
  [-1, 0],
  [-1, 1],
  [0, -1],
  [0, 1],
  [1, -1],
  [1, 0],
  [1, 1]
]

grid = ARGF.read.split("\n").map(&:chars)

p1 = 0
p2 = 0

it = 0
loop do
  it += 1
  remove = []
  grid.each_with_index do |row, y|
    row.each_with_index do |c, x|
      next if c != '@'

      adj_count = dirs.count { |dx, dy| get(grid, y + dy, x + dx) == '@' }
      remove << [x, y] if adj_count < 4
    end
  end
  break if remove.empty?

  p1 = remove.size if it == 1
  p2 += remove.size
  remove.each { |x, y| grid[y][x] = '.' }
end

puts p1
puts p2
