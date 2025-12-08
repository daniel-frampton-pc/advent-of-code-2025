input = File.open("#{Dir.pwd}/input.txt").readlines

# 1: rotate the whole grid conter-clockwise and process into arrays of ints

# get length for doing calculations (assumes all rows have equal length)
row_length = input.first.length

# initialize aggregator with row_length number of empty arrays
rotated_input_arrays = Array.new(row_length) { Array.new }

# pre-emptively remove operator row and reverse it for later
operator_row = input.pop.split(' ').reverse

# puts "operator_row:"
# pp operator_row

# split the lines and add them to rows-in-progress
input.each do |line|
    # split into characters
    split = line.split('')

    # reverse it
    reversed = split.reverse

    # add the characters to the arrays at each index position
    reversed.each_with_index do |char, index|
        rotated_input_arrays[index] << char
    end
end

# convert back into string
rotated_input = rotated_input_arrays.map {|row| row.join }.join("\n")

# puts "rotated input:"
# pp rotated_input

# 2: convert to array of ints
# A: strip, B: remove all whitespace, C: split on double line break, D: split rows on line break
array_of_ints = rotated_input.strip.gsub(" ", "").split("\n\n").map {|row| row.split("\n") }

# puts "first ten rows of array_of_ints:"
# pp array_of_ints[0, 10]

# 3: apply the operator matching row index to each row
totals = array_of_ints.map.with_index do |row, index|
    aggregator = row.shift.to_i

    row.each do |number|
        aggregator = aggregator.send(operator_row[index], number.to_i)
    end

    aggregator
end

# 4: total
grand_total = totals.sum

puts "grand_total:"
puts grand_total