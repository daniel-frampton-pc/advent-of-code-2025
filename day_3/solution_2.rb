largest_joltages = []

# test_input = <<INPUT
# 987654321111111
# 811111111111119
# 234234234234278
# 818181911112111
# INPUT

File.open("#{Dir.pwd}/input.txt") do |file|
  file.each_line.with_index do |line, index|
    puts "starting bank #{index}"

    puts "bank: #{line}"

    # convert string to array of digits
    as_array = line.strip.split('').map(&:to_i)

    puts "as_array: #{as_array}"

    # # find highest number in all but last position, and its index
    # highest_ten = as_array[0..-2].max
    # ten_index = as_array.index(highest_ten)

    # # find highest number to the right of index position
    # highest_one = as_array[(ten_index + 1) ..-1].max

    # # combine and store
    # largest_joltage = (highest_ten.to_i * 10) + highest_one.to_i

    # in descending order from 12 to 1
    search_pointer = 12

    # start search allowing everything
    front_index = 0

    digits = []

    # find each digit
    until search_pointer == 0
      puts "search_pointer now: #{search_pointer}"
      # 1: find max in the characters that CAN be the first of X: that is, in 0...-X
      search_range = as_array[front_index..-search_pointer]
      puts "search_range: #{search_range}"
      highest_in_range = search_range.max
      puts "highest_in_range: #{highest_in_range}"

      # 2: store that number
      digits << highest_in_range

      # 3: store its index position + 1 to mark new start of search range
      # a: get index in the search range
      front_index_in_range = search_range.index(highest_in_range)
      # b: get actual index in total array by adding front_index, then increment by one
      front_index = front_index_in_range + front_index + 1
      puts "front_index now: #{front_index}"

      search_pointer -= 1
    end

    # convert to string, then integer
    largest_joltage = digits.join.to_i

    puts "Found largest joltage to be #{largest_joltage}"

    largest_joltages << largest_joltage
  end
end

puts "All largest joltages:"
pp largest_joltages

puts "Sum of all: #{largest_joltages.sum}"