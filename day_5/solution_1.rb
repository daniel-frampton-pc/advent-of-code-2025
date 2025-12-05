ids = File.open("#{Dir.pwd}/input.txt").readlines

# test_ids = [
#   1,
#   5,
#   8,
#   11,
#   17,
#   32
# ]

# test_ranges = [
#   '3-5',
#   '10-14',
#   '16-20',
#   '12-18'
# ]

raw_ranges = File.open("#{Dir.pwd}/ranges.txt").readlines

puts "ids:"
puts ids

# convert all the lines in ranges to Ruby ranges
ranges = raw_ranges.map do |range|
  first, last = range.split('-').map(&:to_i)
  (first..last)
end

# create counter
fresh_ids = 0

ids.each do |id|
  ranges.each do |range|
    if range.include?(id.to_i)
      fresh_ids += 1
      break
    end
  end
end

puts "total fresh IDs: #{fresh_ids}"