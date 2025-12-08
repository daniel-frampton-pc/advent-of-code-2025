test_input = <<INPUT
123 328  51 64 
 45 64  387 23 
  6 98  215 314
*   +   *   +  
INPUT

# input_as_array = test_input.split("\n").map(&:strip)

# pp input_as_array

input = File.open("#{Dir.pwd}/input.txt").readlines.map(&:strip)

all_arrays = input.map {|row| row.split(' ') }

pp all_arrays

# pop the operators row from the grid
operators_row = all_arrays.pop

# aggregator for results, starts as initial row
results = all_arrays.shift.map(&:to_i)

# convert results to integer

# for each other row except the first and last
all_arrays.each_with_index do |row, index|
  puts "starting row #{index}"

  # for each item in row
  row.each_with_index do |item, index|
    puts "processing item #{index}"

    # calculate new value by applying operation for index
    new_result = results[index].send(operators_row[index], item.to_i)

    # update results at index position for column
    results[index] = new_result
  end
end

puts "results:"
pp results

puts "sum of results:"
pp results.sum