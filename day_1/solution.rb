# array of integers from 0 to 99 simulating the dial, where index position 0 is where it points
dial = (0..99).to_a

# turn to 50 as start position per instructions
dial.rotate!(50)

# counter of hits
counter = 0

# instruction aggregator
instructions = []

# open file
File.open("#{Dir.pwd}/advent_of_code_input.txt") do |file|
  # iterate over lines
  file.each_line do |line|
    # strip newline
    stripped = line.strip

    # split into direction (L or R) and number (remaining chars)
    direction = stripped[0]
    number = stripped[1..-1]

    # add to aggregator as a hash
    instructions << { direction: direction, number: number.to_i }
  end
end

# TODO: move into the file iteration to save time
instructions.each do |instruction|
  puts "Dial at #{dial[0]}"

  puts "Following instruction: #{instruction}"

  # get number
  number = instruction[:number]

  # make it negative if turning left
  number = -number if instruction[:direction] == "L"

  # rotate dial array
  dial.rotate!(number)

  puts "Dial now at #{dial[0]}"

  # check if at zero
  counter += 1 if dial[0] == 0

  puts "Counter now at #{counter}"
end

puts "Counter: " + counter.to_s