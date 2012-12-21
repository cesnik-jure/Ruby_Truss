$main_path = File.dirname(__FILE__)

require("#{$main_path}/new_methods")


$truss_name = "Primer 1"
  
require("#{$main_path}/Load_file")


class Plane_Truss
  
  puts "-----Input data-----"
  puts "Global coordinates of nodes (xy_node)."
  xy_node.mputs
  puts "Supports of nodes (su)."
  su.mputs
  puts "Forces on the nodes (f)."
  f.mputs
  puts "Numbers of start and end nodes of elements (el_node)."
  el_node.mputs
  puts "Elastic modulus and cross sections of elements (em_a)."
  em_a.mputs  
  
  
  require("#{$main_path}/Engine")
  
  puts "-----FEM Calculation results-----"
  
  puts "Displacements of nodes (d)."
  @d.mputs
  puts "Reactions in truss supports (r)."
  @r.mputs
  puts "Axial forces in truss elements (v_f)."
  @v_f.mputs
 
end