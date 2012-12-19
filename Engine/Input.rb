# Input of all the data and its preparation for the Engine.rb.
# Global coordinates of nodes.
$xy_node = Matrix[[0,0], [4,0], [9,0], [13,0], [4,4], [9,4]]
# Supports in [node, direction] for the truss.
$su = Matrix[[1,1], [0,0], [0,0], [1,1], [0,0], [0,0]]
# Forces on the nodes.
$f = Matrix[[0,0], [0,0], [0,0], [0,0], [0,-100], [0,-100]]
# Numbers of start and end nodes of elements.
$el_node = Matrix[[1,2], [2,3], [3,4], [1,5], [2,5], [3,5], [3,6], [4,6], [5,6]]
# Elastic modulus and cross sections of elements.
$em_a = Matrix[[3000,0.5], [3000,0.5], [3000,0.5], [3000,2], [3000,1], [3000,1], [3000,1], [3000,2], [3000,2]]   


puts "Input data for #{$truss_name}:"
puts "Global coordinates of nodes (xy_node)."
$xy_node.mputs
puts "Supports of nodes (su)."
$su.mputs
puts "Forces on the nodes (f)."
$f.mputs
puts "Numbers of start and end nodes of elements (el_node)."
$el_node.mputs
puts "Elastic modulus and cross sections of elements (em_a)."
$em_a.mputs