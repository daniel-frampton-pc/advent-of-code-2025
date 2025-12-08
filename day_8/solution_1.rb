start_time = Time.now

# test input as array of strings
# input = %w[
# 162,817,812
# 57,618,57
# 906,360,560
# 592,479,940
# 352,342,300
# 466,668,158
# 542,29,236
# 431,825,988
# 739,650,466
# 52,470,668
# 216,146,977
# 819,987,18
# 117,168,530
# 805,96,715
# 346,949,466
# 970,615,88
# 941,993,340
# 862,61,35
# 984,92,344
# 425,690,689
# ]

# get input as array of strings
input = File.open("#{Dir.pwd}/input.txt").readlines

# convert to array of arrays of integers
points = input.map {|line| line.strip.split(',').map(&:to_i) }

# get euclidean distance btw points [x, y, z] and [x, y, z]
def get_distance_btw(point_a, point_b)
    x = (point_a[0] - point_b[0])**2
    y = (point_a[1] - point_b[1])**2
    z = (point_a[2] - point_b[2])**2
    Math.sqrt(x + y + z)
end

distance_log = {}

# find the distance between each pair of points
points.permutation(2) do |a, b|
    distance = get_distance_btw(a, b)

    # store points by distance for later storing
    distance_log[distance] = [a, b]
end

# sort by distance into array of [distance, point]
sorted_distances = distance_log.sort_by { |k, _v| k }

# initialize empty circuits trackers
circuits = {} # key: digit ID, value: array of points
circuit_lookup = {} # key: point, value: digit ID
most_recent_id = -1 # track unique key

# repeat until 1000 points have been joined
# 10.times do |time| # with test input
1000.times do |time|
    puts "Starting loop ##{time}"

    # remove the 2 closest points from the set
    point_a, point_b = sorted_distances.shift.last

    # check for current circuit ID
    point_a_circuit = circuit_lookup[point_a.to_s]
    point_b_circuit = circuit_lookup[point_b.to_s]

    # return if both already in same circuit (circuits were joined elsewhere)
    next if (point_a_circuit && point_b_circuit) && point_a_circuit == point_b_circuit

    # if they are both in different circuits, combine them
    if point_a_circuit && point_b_circuit
        # merge circuit B into circuit A
        circuits[point_a_circuit] = circuits[point_a_circuit].concat(circuits[point_b_circuit])

        # change circuit ID of each point in circuit B to that of circuit A
        circuits[point_b_circuit].each do |point|
            circuit_lookup[point.to_s] = point_a_circuit
        end

        # delete the merged circuit
        circuits.delete(point_b_circuit)
    # if one is in circuit and the other isn't, move the other
    elsif point_a_circuit && !point_b_circuit
        circuits[point_a_circuit] << point_b
        circuit_lookup[point_b.to_s] = point_a_circuit
    elsif point_b_circuit && !point_a_circuit
        circuits[point_b_circuit] << point_a
        circuit_lookup[point_a.to_s] = point_b_circuit
    # if neither are in a circuit, create one
    else
        new_circuit_id = most_recent_id + 1
        circuits[new_circuit_id] = [point_a, point_b]
        circuit_lookup[point_a.to_s] = new_circuit_id
        circuit_lookup[point_b.to_s] = new_circuit_id
        most_recent_id = new_circuit_id
    end
end

# count number of points in each circuit
circuit_sizes = circuits.map { |_id, points| points.length }

# sort descending and get highest 3
circuit_sizes_sorted = circuit_sizes.sort { |a, b| b <=> a }
top_3_circuit_sizes = circuit_sizes_sorted[0..2]

puts "top_3_circuit_sizes: #{top_3_circuit_sizes}"

# multiply those 3 together
product = top_3_circuit_sizes.reduce do |size, agg|
    size * agg
end

# print product
puts "product: #{product}"

end_time = Time.now

elapsed_time = end_time - start_time
puts "elapsed time: #{elapsed_time}"