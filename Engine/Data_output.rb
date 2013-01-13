# Output of prepared truss data.

class Plane_Truss
  class Graphics

    puts "Input data for #{$truss_name}:"
    puts "Global coordinates of nodes (xy_node)."
    @xy_node.mputs
    puts "Supports of nodes (su)."
    @su.mputs
    puts "Forces on the nodes (f)."
    @f.mputs
    puts "Labels of start and end nodes of elements (el_node)."
    @el_node.mputs
    puts "Elastic modulus and cross sections of elements (em_a)."
    @em_a.mputs 
    
  end
end

# MISSING: GRAPHIC OUTPUT!!!!