require_relative 'new_methods'
require 'rubygems'
require 'builder'

# Input of all the data and its preparation for the FEM_Engine.rb.
# Numbers of start and end nodes of elements.
el_node = Matrix[[1, 2], [2, 3], [1, 4], [2, 4], [3, 4]]
#el_node = Matrix[[1, 2], [2, 3], [1, 3]]
# Global coordinates of nodes. 
xy_node = Matrix[[-4, 3], [0, 3], [4, 3], [0, 0]]
#xy_node = Matrix[[0, 0], [0, 5], [5, 0]]
# Elastic modulus and cross sections of elements.
em_a = Matrix[[3000, 2], [3000, 2], [3000, 2], [3000, 2], [3000, 2]]
#em_a = Matrix[[10 ** 5, 2], [10 ** 5, 1], [10 ** 5, 0.5]]   
# Supports in [node, direction] for the truss.
su = Matrix[[1,1], [0,0], [1,1], [0,0]] 
#su = Matrix[[1,1], [0,0], [1,1]]
# Forces on the nodes.
f = Matrix[[0,0], [0,-80], [0,0], [0,0]] 
#f = Matrix[[0,0], [10,0], [0,0]] 


nu_node = xy_node.row_size()
nu_el = el_node.row_size()


# Create new subdirectory in Samples directory named truss_name, if it doesn't exist yet.
truss_name = "Primer 1"
Dir::mkdir("Samples/" + truss_name) unless File.exists?("Samples/" + truss_name) 

# Create new .xml file in the directory defined above named truss_name. 
file = File.new("Samples/" + truss_name + "/" + truss_name + ".xml", "w")
xml = Builder::XmlMarkup.new( :target => file, :indent => 2 )

# Populate the .xml file with:
xml.instruct! :xml, :version => "1.1", :encoding => "UTF-8"

# Create a truss element with name attribute.
# Truss' child: nodes.
xml.truss :name => truss_name do
  
  # Nodes' child: node.
  xml.nodes :nu_node => nu_node do
    for n in 1..(nu_node)
      # Create node element with id attribute. 
      # Node's children: cooridante_x, cooridante_x, support_x, support_y, force_x, force_y.  
      xml.node :id => n  do
        xml.coordinate_x(xy_node.[](n - 1 , 0))
        xml.coordinate_y(xy_node.[](n - 1, 1))
        xml.support_x(su.[](n - 1 , 0))
        xml.support_y(su.[](n - 1, 1))
        xml.force_x(f.[](n - 1 , 0))
        xml.force_y(f.[](n - 1, 1))
      end
    end
  end
  
  # Elements' child: element.
  xml.elements :nu_el => nu_el do
    for el in 1..(nu_el)
      # Create "element" element with id attribute. 
      # Node's children: coordinate_x, coordinate_x, support_x, support_y, force_x, force_y.  
      xml.element :id => el  do
        xml.start_node(el_node.[](el - 1 , 0))
        xml.end_node(el_node.[](el - 1 , 1))
        xml.elastic_modulus(em_a.[](el - 1, 0))
        xml.section_area(em_a.[](el - 1, 1))
      end
    end
  end
end

file.close




