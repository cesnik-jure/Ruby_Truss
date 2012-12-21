class Truss
  puts "Truss"
  
  @instance_var = "truss instance"
  @@class_var = "truss class"

  def self.instance_var; puts @instance_var end

  def self.class_var; puts @@class_var end
  
end

Truss.instance_var
Truss.class_var
  
class Element < Truss
  @instance_var = "element instance"
  @@class_var = "element class"
   
end

puts "\nTruss"

Truss.instance_var
Truss.class_var

puts "\nElement"

Element.instance_var
Element.class_var
  
  
  

puts "\nout"
