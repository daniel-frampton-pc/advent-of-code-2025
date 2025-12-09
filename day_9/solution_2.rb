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

width = parsed.map { |x, y| x }.max + 1
height = parsed.map { |x, y| y }.max + 1

# 1: create a grid with width of max Y, width of max X
# TODO: this runs indefinitely; probably hitting memory limit?
@grid = Array.new(height) { Array.new(width) { '.' }}

puts "Grid creation complete"

# puts "grid:"
# pp @grid

def mark_cell(x, y, character)
  # puts "marking cell #{x}, #{y} as '#{character}'"
  @grid[y][x] = character
end

# a, b = tuples of [x, y]
def mark_line_between(a, b)
  # mark both corners (could only do 2nd, but need for first)
  mark_cell(a[0], a[1], 'R')
  mark_cell(b[0], b[1], 'R')

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
        mark_cell(a[0], pointer, 'G')
        pointer += 1
      end
    else
      # traverse from bottom to top
      pointer = bottom_y - 1
      until pointer == top_y
        mark_cell(a[0], pointer, 'G')
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
        mark_cell(pointer, a[1], 'G')
        pointer += 1
      end
    else
      # traverse right to left
      pointer = right_x - 1
      until pointer == left_x
        mark_cell(pointer, a[1], 'G')
        pointer -= 1
      end
    end
  end
end

puts "Starting line drawing"

# 2: traverse the grid and mark each cell the lines cross, R for red, G for green
parsed.each_cons(2) do |point_a, point_b|
  mark_line_between(point_a, point_b)
end

# then do it one more time for the last and first
mark_line_between(parsed[-1], parsed[0])

puts "Line drawing complete"

# puts "grid now:"
# pp @grid

puts "Starting filling in"

# 3: fill in the polygon by iterating left to right
# TODO: hypothetically this means drawing horizontal lines above is unnecessary
@grid.each_with_index do |row, row_index|
  puts "Filling in row #{row_index}"
  write_mode = false

  row.each_with_index do |cell, cell_index|
    next if cell_index == 0

    # if previous cell was wall and current is not, toggle write_mode
    if !write_mode && @grid[row_index][cell_index - 1] != '.' && cell == '.'
      write_mode = true
    # if write mode is on and we've passed a wall, break to next row
    elsif write_mode && @grid[row_index][cell_index - 1] != '.' && cell != '.'
      break
    end
    
    # if in write mode and cell is empty, write to current cell
    if write_mode && cell == '.'
      @grid[row_index][cell_index] = 'G'
    end
  end
end

puts "Filling in complete"

# puts "grid now:"
# pp @grid

puts "Checking for rectangle sizes"

# 4: check each pair of points for rectangle overlap with polygon & save size
# TODO: probably there's a smarter way to do this
rectangle_sizes = parsed.permutation(2).map.with_index do |tuple, index|
  puts "Checking permutation #{index}"

  # destructure
  a_x, a_y = tuple[0]
  b_x, b_y = tuple[1]

  # get min and max X, min and max Y
  min_x, max_x = a_x < b_x ? [a_x, b_x] : [b_x, a_x]
  min_y, max_y = a_y < b_y ? [a_y, b_y] : [b_y, a_y]

  # check for overlap with R and G, otherwise return 0
  # from start row to end row (by Y index)...
  in_bounds = @grid[min_y..max_y].all? do |row|
    # from start char to end char... check for all Rs and Gs
    row[min_x..max_x].join.match?(/^[RG]*$/)
  end

  # if in bounds, compute and return size, otherwise return 0
  if in_bounds
    # get side lengths based on which point is farther from origin
    x_length = max_x - min_x + 1
    y_length = max_y - min_y + 1
  
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