start_time = Time.now

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

    # skip strings with only 1 digit
    next if id_length == 1

    # TODO: figure out how to check for *ANY* repeated pattern of 1 or more recurring characters.
      # try each interval from 1 to half the length of the string, where that number divides equally into length?
    
    intervals_to_try = [1]
    to_try_pointer = 2

    while to_try_pointer <= id_length / 2
      # if it divides equally into length without remainder, add it
      if id_length % to_try_pointer == 0
        intervals_to_try << to_try_pointer
      end

      # increment pointer
      to_try_pointer += 1
    end

    # puts "intervals_to_try: #{intervals_to_try}"

    # check each interval / segment length for patterns
    intervals_to_try.each do |interval|
      # puts "checking interval #{interval}"

      # split the string into the segments by converting to array then joining
      as_array = id_string.split('')
      segments = []
      as_array.each_slice(interval) do |chunk|
        segments << chunk.join
      end

      # puts "found segments: #{segments}"

      # check for equality of all the segments by getting length of unique elements
      unique_chunks = segments.uniq.length

      # puts "unique_chunks: #{unique_chunks}"

      # if it is true, add it to invalid IDs
      if unique_chunks == 1
        # puts "found invalid_id #{pointer}"
        invalid_ids << pointer

        # TODO: need to break not just from this iteration but the one above it
        next
      end
    end
  end

  # puts "done with input #{index}, range #{input_range}"
end

# puts "all invalid IDs:"
# pp invalid_ids

puts "sum of unique invalid IDs:"
puts invalid_ids.uniq.sum

end_time = Time.now

elapsed_time = end_time - start_time

puts "Time elapsed: #{elapsed_time} seconds"