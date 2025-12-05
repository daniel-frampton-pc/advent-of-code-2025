# test_ranges = [
#   '3-5',
#   '10-14',
#   '16-20',
#   '12-18'
# ]

raw_ranges = File.open("/Users/danielframpton/Documents/advent_of_code/day_5/ranges.txt").readlines

# convert all the lines in ranges to Ruby ranges
# ranges = test_ranges.map do |range|
ranges = raw_ranges.map do |range|
  first, last = range.split('-').map(&:to_i)
  (first..last)
end

puts "ranges:"
pp ranges

# ensure that the ranges are sorted in ascending order
sorted_ranges = ranges.sort_by { |range| [range.begin, range.end] }

puts "sorted ranges:"
pp sorted_ranges

combined_ranges = []

# keep going until all the ranges have been processed
until sorted_ranges.length == 0
  first_range = sorted_ranges[0]
  ranges_to_combine = [first_range]
  combined_range = first_range.dup

  # find all the overlapping ranges
  sorted_ranges.each_with_index do |range, index|
    next if index == 0
  
    if combined_range.overlap?(range)
      # add found index to aggregator
      ranges_to_combine << range

      # get new start and end of combined range
      min_start = [combined_range.begin, range.begin].min
      max_end = [combined_range.end, range.end].max

      # make new combined range
      combined_range = (min_start..max_end)
    end
  end

  # add combined range to combined_ranges
  combined_ranges << combined_range

  # remove the combined ranges from original array
  ranges_to_combine.each do |range|
    sorted_ranges.delete(range)
  end
end

puts "combined_ranges:"
pp combined_ranges

total_ids = combined_ranges.sum(&:count)

puts "total IDs across all ranges: #{total_ids}"

puts "done"