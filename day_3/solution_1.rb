largest_joltages = []

File.open("#{Dir.pwd}/input.txt") do |file|
  file.each_line.with_index do |line, index|
    puts "starting bank #{index}"

    puts "bank: #{line}"

    # convert string to array of digits
    as_array = line.strip.split('').map(&:to_i)

    puts "as_array: #{as_array}"

    # find highest number in all but last position, and its index
    # TODO: do this in one iteration
    highest_ten = as_array[0..-2].max
    ten_index = as_array.index(highest_ten)

    # find highest number to the right of index position
    highest_one = as_array[(ten_index + 1) ..-1].max

    # combine and store
    largest_joltage = (highest_ten.to_i * 10) + highest_one.to_i

    puts "Found largest joltage to be #{largest_joltage}"

    largest_joltages << largest_joltage
  end
end

puts "All largest joltages:"
pp largest_joltages

puts "Sum of all: #{largest_joltages.sum}"