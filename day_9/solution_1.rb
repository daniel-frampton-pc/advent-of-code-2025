start_time = Time.now

# test input as array of strings
# input = %w[
# 7,1
# 11,1
# 11,7
# 9,7
# 9,5
# 2,5
# 2,3
# 7,3
# ]

# get input as array of strings
input = File.open("#{Dir.pwd}/input.txt").readlines

parsed = input.map do |line|
  line.split(',').map(&:to_i)
end

# puts "parsed:"
# pp parsed

# sort to get the best extreme corners

# sort the tuple descending, get first and last as top left, bottom right
sorted_ascending = parsed.sort_by { |x, y| x + y }
top_left = sorted_ascending.first
bottom_right = sorted_ascending.last

puts "top_left: #{top_left}"
puts "bottom_right: #{bottom_right}"

# compute sides, get product of rectangle
x_length_1 = bottom_right[0] - top_left[0] + 1
y_length_1 = bottom_right[1] - top_left[1] + 1
size_1 = x_length_1 * y_length_1

puts "size_1: #{size_1}"

# sort the tuple by high X, reverse Y, get first and last as top right, bottom left
sorted_crosswise = parsed.sort_by { |x, y| [x, -y] }
bottom_left = sorted_crosswise.first
top_right = sorted_crosswise.last

puts "bottom_left: #{bottom_left}"
puts "top_right: #{top_right}"

# compute sides, get product of rectangle
x_length_2 = top_right[0] - bottom_left[0] + 1
y_length_2 = bottom_left[1] - top_right[1] + 1
size_2 = x_length_2 * y_length_2

puts "size_2: #{size_2}"

puts "largest: #{size_1 > size_2 ? size_1 : size_2}"

end_time = Time.now

elapsed_time = end_time - start_time
puts "elapsed time: #{elapsed_time}"