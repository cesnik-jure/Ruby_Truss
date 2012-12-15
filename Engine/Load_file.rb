require_relative 'new_methods'
require 'rexml/document'
include REXML

# Open .xml file named truss_name in the Samples/truss_name/ directory.
truss_name = "Primer 1" 
file = File.new("Samples/" + truss_name + "/" + truss_name + ".xml", "r")

doc = Document.new(file)
root = doc.root
truss_name = root.attributes["name"]

# Collect the number of nodes and elements in truss.
nodes = root.elements["nodes"]
nu_node = nodes.attributes["nu_node"].to_i

elements = root.elements["elements"]
nu_el = elements.attributes["nu_el"].to_i

# Create corresponding empty matrixes (filled with 0s) for all the required data.
su = f = xy_node = Matrix.build(nu_node, 2) {|row, col| 0 }
em_a = el_node = Matrix.build(nu_el, 2) {|row, col| 0 }


node = nodes.elements["node"]

id = node.attributes["id"]



file.close




