# get whole file contents as array of strings
raw_input = File.open("#{Dir.pwd}/input.txt").readlines

# test input from puzzle
# test_input = <<INPUT
# ..@@.@@@@.
# @@@.@.@.@@
# @@@@@.@.@@
# @.@@@@..@.
# @@.@@@@.@@
# .@@@@@@@.@
# .@.@.@.@@@
# @.@@@.@@@@
# .@@@@@@@@.
# @.@.@@@.@.
# INPUT

# test_input_arrays = test_input.split("\n")

# convert to array of arrays (constant for access in methods)
# INPUT = test_input_arrays.map { |row| row.strip.split('') }
INPUT = raw_input.map { |row| row.strip.split('') }

# create counter
accessible_rolls = 0

# pre-measure the grid (constants for access in methods)
height = INPUT.length
MAX_HEIGHT_INDEX = height - 1
width = INPUT[0].length
MAX_WIDTH_INDEX = width - 1

# extract logic for individual cell check
def cell_is_roll?(row_index, column_index)
  # account for out of bounds
  return false if (row_index < 0) || (row_index > MAX_HEIGHT_INDEX)
  return false if (column_index < 0) || (column_index > MAX_WIDTH_INDEX)

  INPUT[row_index][column_index] == '@'
end

# extract logic for checking a segment, supports center segment
def count_rolls_in_segment(row_index, center_index, count_center = true)
  roll_count = 0

  roll_count += 1 if cell_is_roll?(row_index, center_index - 1)
  roll_count += 1 if count_center && cell_is_roll?(row_index, center_index)
  roll_count += 1 if cell_is_roll?(row_index, center_index + 1)

  roll_count
end

# iterate over lines
INPUT.each_with_index do |row, row_index|
  puts "starting row #{row_index}"
 
  puts "row:"
  pp row

  # iterate over elements
  row.each_with_index do |roll, column_index|
    # only run the check if the current element is a roll
    next unless roll == '@'

    puts "counting rolls adjacent to roll at column #{column_index}, row #{row_index}"

    # start counter
    adjacent_rolls = 0

    # count adjacent rolls in row (ignores center index)
    adjacent_rolls += count_rolls_in_segment(row_index, column_index, false)

    # count rolls in previous row
    adjacent_rolls += count_rolls_in_segment(row_index - 1, column_index)

    # count rolls in next row
    adjacent_rolls += count_rolls_in_segment(row_index + 1, column_index)

    # check total count
    if (adjacent_rolls < 4)
      puts "found accessible roll at #{column_index}, #{row_index}"
      accessible_rolls += 1
    end
  end
  
  puts "done with row #{row_index}"
end

puts "Accessible rows: #{accessible_rolls}"

puts "Done"