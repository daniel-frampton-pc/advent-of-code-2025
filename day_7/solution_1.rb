# read file or get text input

# input = %w[
# .......S.......
# ...............
# .......^.......
# ...............
# ......^.^......
# ...............
# .....^.^.^.....
# ...............
# ....^.^...^....
# ...............
# ...^.^...^.^...
# ...............
# ..^...^.....^..
# ...............
# .^.^.^.^.^...^.
# ...............
# ]

input = File.open("#{Dir.pwd}/input.txt").readlines

# tracking which indices have ray as hash for lookup
ray_indices = { input[0].index('S') => true }
# puts "ray_indices: #{ray_indices}"

# start counter of times ray split
counter = 0

input.each_with_index do |line, index|
    # skip the odd numbered indices which are pointless
    next if index.odd?

    puts "checking line #{index}"
    
    # puts "line:"
    # pp line

    # prepare new version of ray indices
    # new_ray_indices = ray_indices.dup
    new_ray_indices = {}

    # check each current ray index
    ray_indices.each do |ray_index, _bool|
        if line[ray_index] == '^'
            puts "ray splits at #{ray_index}"
            counter += 1

            # add indices before and after previous ray
            new_ray_indices[ray_index - 1] = true
            new_ray_indices[ray_index + 1] = true
        else
            # ray continues
            new_ray_indices[ray_index] = true
        end
    end

    puts "new_ray_indices keys:"
    pp new_ray_indices.keys

    # set the new ray indices
    ray_indices = new_ray_indices
end

puts "final counter: #{counter}"