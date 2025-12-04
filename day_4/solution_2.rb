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
# current_input = test_input_arrays.map { |row| row.strip.split('') }
current_input = raw_input.map { |row| row.strip.split('') }

# create duplicate which is to be modified
next_input = current_input.dup

# create counter for overall accessible rolls
accessible_rolls = 0

# pre-measure the grid (constants for access in methods)
height = current_input.length
MAX_HEIGHT_INDEX = height - 1
width = current_input[0].length
MAX_WIDTH_INDEX = width - 1

# extract logic for individual cell check
def cell_is_roll?(row_index, column_index, grid)
  # account for out of bounds
  return false if (row_index < 0) || (row_index > MAX_HEIGHT_INDEX)
  return false if (column_index < 0) || (column_index > MAX_WIDTH_INDEX)

  grid[row_index][column_index] == '@'
end

# extract logic for checking a segment, supports center segment
def count_rolls_in_segment(row_index, center_index, grid, count_center = true)
  roll_count = 0

  roll_count += 1 if cell_is_roll?(row_index, center_index - 1, grid)
  roll_count += 1 if count_center && cell_is_roll?(row_index, center_index, grid)
  roll_count += 1 if cell_is_roll?(row_index, center_index + 1, grid)

  roll_count
end

# create loop counter for debugging
loop_counter = 0

# run until break condition
loop do
  loop_counter += 1
  accessible_rolls_in_loop = 0

  puts "starting loop #{loop_counter}"

  # iterate over lines
  current_input.each_with_index do |row, row_index|
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
      adjacent_rolls += count_rolls_in_segment(row_index, column_index, current_input, false)

      # count rolls in previous row
      adjacent_rolls += count_rolls_in_segment(row_index - 1, column_index, current_input)

      # count rolls in next row
      adjacent_rolls += count_rolls_in_segment(row_index + 1, column_index, current_input)

      # check total count
      if (adjacent_rolls < 4)
        puts "found accessible roll at #{column_index}, #{row_index}"

        # increment counters
        accessible_rolls += 1
        accessible_rolls_in_loop += 1

        # remove roll from duplicate of input
        next_input[row_index][column_index] = '.'
      end
    end
    
    puts "done with row #{row_index}"
  end

  if accessible_rolls_in_loop == 0
    puts "No accessible rolls found in loop #{loop_counter}, breaking"
    break
  else
    puts "Found #{accessible_rolls_in_loop} rolls in loop #{loop_counter}."
    puts "Starting next loop with accessible rolls removed"
    current_input = next_input
  end
end

puts "Accessible rows: #{accessible_rolls}"

puts "Done"