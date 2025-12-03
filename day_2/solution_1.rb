input = nil

File.open("#{Dir.pwd}/puzzle_input.txt") do |file|
  input = file.readline
end

puts input

inputs = input.split(',')

pp inputs

invalid_ids = []

inputs.each_with_index do |input_range, index|
  puts "on input #{index}"

  # split on hyphen

  low, high = input_range.split('-')

  puts "low: " + low
  puts "high: " + high

  # this is breaking, too big of an array to hold in memory
  # range = (low..high).to_a

  # set pointer to low
  pointer = low.to_i

  until pointer == high.to_i
    # increment pointer
    pointer += 1

    # stringify
    id_string = pointer.to_s

    # check length
    id_length = id_string.length

    # skip numbers of odd length
    next if id_length.odd?

    # get first half and second half
    half = id_string.length / 2
    # from zero to before midpoint
    first_half = id_string[0..(half - 1)]
    # from after midpoint, for length of half
    second_half = id_string[half, half]

    # handle invalid IDs
    if first_half == second_half
      # puts "found invalid ID #{id_string}"
      invalid_ids << pointer
    end
  end

  puts "done with input #{index}, range #{input_range}"
end

puts "all invalid IDs:"
pp invalid_ids

puts "sum of invalid IDs:"
puts invalid_ids.sum