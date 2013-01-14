# Output of prepared truss data.

class Plane_Truss
  class Graphics
    
    puts "\n-----Input data for #{$truss_name}-----\n"
    
    puts "Global coordinates of nodes (xy_node) in [m]."
    @xy_node.mputs
    puts "Supports of nodes (su)."
    @su.mputs
    puts "Forces on the nodes (f) in [m]."
    @f.mputs
    puts "Labels of start and end nodes of elements (el_node)."
    @el_node.mputs
    puts "Elastic modulus and cross sections of elements (em_a) in [MPa] and [m^2]."
    @em_a.mputs 
    
  end
end