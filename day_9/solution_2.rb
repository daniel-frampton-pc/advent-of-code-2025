start_time = Time.now

# test input as array of strings
# input = %w[
# 7,1
# 11,1
# 11,7
# 9,7
# 9,5
# 2,5
# 2,3
# 7,3
# ]

# get input as array of strings
input = File.open("#{Dir.pwd}/input.txt").readlines

# parse as array of arrays of ints
parsed = input.map do |line|
  line.split(',').map(&:to_i)
end

puts "Parsing complete"

# puts "parsed:"
# pp parsed

x_values = parsed.map { |x, y| x }
y_values = parsed.map { |x, y| y }
max_x = x_values.max
max_y = y_values.max
min_x = x_values.min
min_y = y_values.min

puts "min_x: #{min_x}"
puts "min_y: #{min_y}"
puts "max_x: #{max_x}"
puts "max_y: #{max_y}"

# going to try using local file-based DB
require 'sqlite3'

# 1: create DB to track known points that are corners and walls

# Create DB
@db = SQLite3::Database.new( "grid.db" )

# reset the DB
@db.execute("drop table if exists points;")

# Create a table 
@db.execute <<-SQL
  create table points (
    x int,
    y int
  );

  create unique index index_x_y
  on points (x, y);
SQL

# define access methods

def mark(x, y)
  puts "marking: #{x}, #{y}"
  @db.execute(" INSERT INTO points VALUES( #{x}, #{y} )")
end

def marked?(x, y)
  puts "checking whether marked: #{x}, #{y}"
  result = @db.execute("SELECT 1 FROM points WHERE x = ? AND y = ?", [x, y])
  # puts "found result: #{result}"
  !!result.first
end

puts "Grid DB setup complete"

# a, b = tuples of [x, y]
def mark_line_between(a, b)
  # mark both corners (could only do 2nd, but need for first)
  mark(a[0], a[1])
  mark(b[0], b[1])

  # mark the points between, either horizontally or vertically, based on which plane is shared
  # TODO: abstract this out
  if a[0] == b[0]
    # same x coord, traverse vertically

    # compare Y to get top and bottom y of line
    top_y, bottom_y = a[1] < b[1] ? [a[1], b[1]] : [b[1], a[1]]

    # traverse in the direction of the next spot
    if a[1] < b[1]
      # traverse top to bottom
      pointer = top_y + 1
      until pointer == bottom_y
        mark(a[0], pointer)
        pointer += 1
      end
    else
      # traverse from bottom to top
      pointer = bottom_y - 1
      until pointer == top_y
        mark(a[0], pointer)
        pointer -= 1
      end
    end
  else
    # same y coord, traverse horizontally

    # compare X to get left and right X of line
    left_x, right_x = a[0] < b[0] ? [a[0], b[0]] : [b[0], a[0]]

    # compare X coords to determine direction to traverse in
    if a[0] < b[0]
      # traverse left to right
      pointer = left_x + 1
      until pointer == right_x
        mark(pointer, a[1])
        pointer += 1
      end
    else
      # traverse right to left
      pointer = right_x - 1
      until pointer == left_x
        mark(pointer, a[1])
        pointer -= 1
      end
    end
  end
end

puts "Starting point marking"

# 2: traverse the virtual grid and mark each cell the lines cross
parsed.each_cons(2) do |point_a, point_b|
  mark_line_between(point_a, point_b)
end

# then do it one more time for the last and first
mark_line_between(parsed[-1], parsed[0])

puts "Point marking complete"

# puts "grid now:"
# pp @grid

puts "Starting filling in"

# 3: fill in the polygon by iterating left to right
# TODO: hypothetically this means drawing horizontal lines above is unnecessary
y_pointer = min_y
until y_pointer > max_y do
  puts "Filling in row #{y_pointer}"

  write_mode = false

  prev_cell_marked = nil

  x_pointer = min_x
  until x_pointer > max_x
    cell_marked = marked?(x_pointer, y_pointer)

    # skip first column, no prev cell to compare with
    if y_pointer == 0
      prev_cell_marked = cell_marked
      x_pointer += 1
      next
    end

    # if previous cell was wall and current is not, toggle write_mode
    if !write_mode && prev_cell_marked && !cell_marked
      write_mode = true
    elsif write_mode && prev_cell_marked && cell_marked
      write_mode = false
    end
    
    if write_mode && !cell_marked
      mark(x_pointer, y_pointer)
      cell_marked = true
    end

    # cache cell value
    prev_cell_marked = cell_marked

    # increment column pointer
    x_pointer += 1
  end

  # increment row pointer
  y_pointer += 1
end

puts "Filling in complete"

# # for debugging, draw the grid
# all_x_coords = (0..max_x).to_a
# grid = (0..max_y).to_a.map do |y|
#   all_x_coords.map do |x|
#     marked?(x, y) ? 'X' : '.'
#   end.join
# end.join("\n")

# puts "filled in grid:"
# pp grid

puts "Checking for rectangle sizes"

# 4: check each pair of points for rectangle overlap with polygon & save size
# TODO: probably there's a smarter way to do this
rectangle_sizes = parsed.permutation(2).map.with_index do |tuple, index|
  puts "Checking permutation #{index}"

  # destructure
  a_x, a_y = tuple[0]
  b_x, b_y = tuple[1]

  # get min and max X, min and max Y
  rect_min_x, rect_max_x = a_x < b_x ? [a_x, b_x] : [b_x, a_x]
  rect_min_y, rect_max_y = a_y < b_y ? [a_y, b_y] : [b_y, a_y]

  # check for overlap with marked points, otherwise return 0
  rect_y_coords = (rect_min_y..rect_max_y).to_a
  rect_x_coords = (rect_min_x..rect_max_x).to_a
  # from start row to end row (by Y index)...
  in_bounds = rect_y_coords.all? do |rect_y|
    # from start char to end char... check for all Rs and Gs
    rect_x_coords.all? do |rect_x|
      marked?(rect_x, rect_y)
    end
  end

  # if in bounds, compute and return size, otherwise return 0
  if in_bounds
    # get side lengths based on which point is farther from origin
    x_length = rect_max_x - rect_min_x + 1
    y_length = rect_max_y - rect_min_y + 1
  
    x_length * y_length
  else
    0
  end
end

# 5: sort and return largest rectangle
puts "max rectangle size: #{rectangle_sizes.max}"

end_time = Time.now

elapsed_time = end_time - start_time
puts "elapsed time: #{elapsed_time}"