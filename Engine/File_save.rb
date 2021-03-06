require 'rubygems'
require 'builder'

class Plane_Truss
  class Graphics
    
    # Create new subdirectory in Samples directory named truss_name, if it doesn't exist yet.
    Dir::mkdir("Samples/#{$truss_name}") unless File.exists?("Samples/#{$truss_name}") 
    
    # Create a new .xml file in the directory defined above named truss_name.
    # If such a file already exists, ask if user wants to overwrite it. 
    if File.exists?("Samples/#{$truss_name}/#{$truss_name}.xml") == true then
      exists = true
      puts "File already exists!"
      
      y_n = false  
      overwrite = ""
      
      until y_n == true
      
        case overwrite
        when "y", "Y"
          file = File.new("Samples/#{$truss_name}/#{$truss_name}.xml", "w")
          y_n = true
        when "n", "N"
          y_n = true
        else
          puts "Would you like to overwrite it? Y/N"
          overwrite = gets.chomp
        end
      end  
      
    else
      exists = false
      file = File.new("Samples/#{$truss_name}/#{$truss_name}.xml", "w")
    end
    
    xml = Builder::XmlMarkup.new( :target => file, :indent => 2 )
    
    # Calculates the number of node and element children.
    nu_node = @xy_node.row_size()
    nu_el = @el_node.row_size()
       
    # Populate the .xml file with:
    xml.instruct! :xml, :version => "1.1", :encoding => "UTF-8"
    
    # Create a truss element with name attribute.
    # Truss' child: nodes.
    xml.truss :name => $truss_name do
      
      # Nodes' child: node.
      xml.nodes :nu_node => nu_node do
        for n in 1..(nu_node)
          # Create node element with id attribute. 
          # Node's children: cooridante_x, cooridante_x, support_x, support_y, force_x, force_y.  
          xml.node :id => n  do
            xml.coordinate_x(@xy_node.[](n - 1 , 0))
            xml.coordinate_y(@xy_node.[](n - 1, 1))
            xml.support_x(@su.[](n - 1 , 0))
            xml.support_y(@su.[](n - 1, 1))
            xml.force_x(@f.[](n - 1 , 0))
            xml.force_y(@f.[](n - 1, 1))
          end
        end
      end
      
      # Elements' child: element.
      xml.elements :nu_el => nu_el do
        for el in 1..(nu_el)
          # Create "element" element with id attribute. 
          # Node's children: coordinate_x, coordinate_x, support_x, support_y, force_x, force_y.  
          xml.element :id => el  do
            xml.start_node(@el_node.[](el - 1 , 0))
            xml.end_node(@el_node.[](el - 1 , 1))
            xml.elastic_modulus(@em_a.[](el - 1, 0))
            xml.section_area(@em_a.[](el - 1, 1))
          end
        end
      end
    end
  
    if exists == true then
      case overwrite
      when "y", "Y"
        puts "#{$truss_name}.xml file was overwritten in Samples/#{$truss_name}."
        load("#{$main_path}/model_draw_normal.rb")
        file.close
      when "n", "N"
        puts "File was not overwritten."
      end
    else
      puts "A new folder Samples/#{$truss_name} was created and an #{$truss_name}.xml file was written in it."
      load("#{$main_path}/model_draw_normal.rb")
      file.close
    end
    
  end
end



