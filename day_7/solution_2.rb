start_time = Time.now

# read file or get text input

# INPUT = %w[
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

INPUT = File.open("#{Dir.pwd}/input.txt").readlines

# tracking which indices have ray as hash for lookup
initial_ray_index = INPUT[0].index('S')

# cache known results
@known_paths = {}

# try recursive function
def count_branching_paths_from(start_line_index, ray_index)
    puts "starting #{start_line_index}, #{ray_index}"
    # sleep 0.2
    line_index = start_line_index

    # ray continues until end of tree or splits
    until line_index + 1 >= INPUT.length
        line_index += 1

        # return cached answer if present
        if @known_paths["#{line_index}_#{ray_index}"]
            return @known_paths["#{line_index}_#{ray_index}"]
        end

        # skip the odd numbered indices which are pointless
        # next if line_index.odd?
    
        if INPUT[line_index][ray_index] == '^'
            # split off recursively left and right, return results
            left_result = count_branching_paths_from(line_index, ray_index - 1)
            right_result = count_branching_paths_from(line_index, ray_index + 1)
            total = left_result + right_result

            # cache result and then return to caller
            @known_paths["#{line_index}_#{ray_index}"] = total
            return left_result + right_result
        end
    end

    puts "EOL"
    # have reached end of tree without splitting, return 1 to caller
    return 1
end

result = count_branching_paths_from(1, initial_ray_index)

puts "final counter: #{result}"

end_time = Time.now

elapsed_time = end_time - start_time
puts "elapsed_time: #{elapsed_time}"