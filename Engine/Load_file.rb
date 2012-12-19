require_relative 'new_methods'
require 'rexml/document'
include REXML

# Open .xml file named truss_name in the Samples/truss_name/ directory.
truss_name = $truss_name
file = File.new("Samples/#{$truss_name}/#{truss_name}.xml", "r")
doc = Document.new(file)

root = doc.root
truss_name = root.attributes["name"]

# Collect the number of nodes and elements in truss.
nodes = root.elements["nodes"]
$nu_node = nodes.attributes["nu_node"].to_i

elements = root.elements["elements"]
$nu_el = elements.attributes["nu_el"].to_i

class Plane_Truss
  
  # Defines self methods for calling the instance variables inside the Plane_Truss class and its subclasses.
  def self.xy_node; @xy_node end
  def self.su; @su end
  def self.f; @f end
  def self.em_a; @em_a end
  def self.el_node; @el_node end
      
  class Graphics < Plane_Truss
    # Create corresponding empty matrixes (filled with 0s) for all the required data in Graphics class.
    @xy_node = Matrix.build($nu_node, 2) {|row, col| 0 } 
    @su = Matrix.build($nu_node, 2) {|row, col| 0 }
    @f = Matrix.build($nu_node, 2) {|row, col| 0 }
    @em_a = Matrix.build($nu_el, 2) {|row, col| 0 }
    @el_node = Matrix.build($nu_el, 2) {|row, col| 0 }  
  end
  
end


# Read and write into a corresponding array all the node data (coordinates, supports, forces). 
$coordinates_x = XPath.each( doc, "truss/nodes/node/coordinate_x/text()") { |text| text }
$coordinates_y = XPath.each( doc, "truss/nodes/node/coordinate_y/text()") { |text| text }
$supports_x = XPath.each( doc, "truss/nodes/node/support_x/text()") { |text| text }
$supports_y = XPath.each( doc, "truss/nodes/node/support_y/text()") { |text| text }
$forces_x = XPath.each( doc, "truss/nodes/node/force_x/text()") { |text| text }
$forces_y = XPath.each( doc, "truss/nodes/node/force_y/text()") { |text| text }

# Read and write into a corresponding array all the element data (start/end nodes, material and section properties). 
$start_nodes = XPath.each( doc, "truss/elements/element/start_node/text()") { |text| text }
$end_nodes = XPath.each( doc, "truss/elements/element/end_node/text()") { |text| text }
$elastic_modules = XPath.each( doc, "truss/elements/element/elastic_modulus/text()") { |text| text }
$section_areas = XPath.each( doc, "truss/elements/element/section_area/text()") { |text| text }

class Plane_Truss  
  class Graphics
      
    # Floats used only where non-integer numbers are expected (physical variables).  
    # Write node matrixes from node arrays. 
    for i in 0..($nu_node - 1) do
      for j in 0..1 do
        @xy_node.[]=(i, j, (j == 0 ? $coordinates_x[i].to_s.to_f : $coordinates_y[i].to_s.to_f))
        @su.[]=(i, j, (j == 0 ? $supports_x[i].to_s.to_i : $supports_y[i].to_s.to_i))
        @f.[]=(i, j, (j == 0 ? $forces_x[i].to_s.to_f : $forces_y[i].to_s.to_f))
      end
    end
    
    # Write element matrixes from element arrays.
    for i in 0..($nu_el - 1) do
      for j in 0..1 do
        @el_node.[]=(i, j, (j == 0 ? $start_nodes[i].to_s.to_i : $end_nodes[i].to_s.to_i))
        @em_a.[]=(i, j, (j == 0 ? $elastic_modules[i].to_s.to_f : $section_areas[i].to_s.to_f))
      end
    end
   Graphics.xy_node
  end
  
  # Writes new xy_node, em_a, el_node matrixes for engine.rb in Plane_Truss class. 
  @xy_node = Graphics.xy_node
  @em_a = Graphics.em_a
  @el_node = Graphics.el_node
  
  # Sums all the elements in su matrix (only 0s and 1s). 
  nu_su = 0
  Graphics.su.each { |a| nu_su += a }
  
  # Builds new su and f matrixes for engine.rb in Plane_Truss class.
  @su = Matrix.build(nu_su, 2) {|row, col| 0 }
  @f = Matrix.build(2*$nu_node, 1) {|row, col| 0 }
  
  # Writes a new su 2 columns matrix. 
  row_nu = 0 
  for i in 0..($nu_node - 1)
    for j in 0..1
      if Graphics.su.[](i, j) == 1 then 
        @su.[]=(row_nu, 0, i + 1)
        @su.[]=(row_nu, 1, j + 1)
        row_nu += 1
      end
    end  
  end
    
  # Writes a new f 1 column matrix.
  m_el_nu = 0
  for i in 0..($nu_node - 1) do
    for j in 0..1 do
      @f.[]=(m_el_nu, 0, Graphics.f.[](i, j))
      m_el_nu += 1
    end
  end
  
end



file.close


