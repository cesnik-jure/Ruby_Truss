require 'rasem'

$main_path = File.dirname(__FILE__)
require("#{$main_path}/methods_new")
load("#{$main_path}/data_input.rb")
  
class Plane_Truss
  class Graphics 
    $spacing = 80
    $x_max = (xy_node.column_vectors[0].max + 3) * $spacing
    $y_max = (xy_node.column_vectors[1].max + 3) * $spacing
  end
end


# Create a new .svg image variable.
img = Rasem::SVGImage.new($x_max+1, $y_max+1) do
  
  pt_g = Plane_Truss::Graphics
     
  def self.write(x, y, string, colour, align)
    text x, y, string, :font_family=>"Verdana", "font-size"=>12, "fill"=>colour, "text-anchor"=>align
  end
  
  # Draw an arrow in x direction starting in x,y with length and arrow_text.    
  def self.draw_arrow_x(x, y, length, arrow_colour, arrow_width, arrow_text)
    case 
    when length < 0
      line(x, y, x+length, y, :stroke=>arrow_colour, "stroke-width"=>arrow_width)
      polyline([[x+length+10, y-5], [x+length, y], [x+length+10, y+5]],
        :stroke=>arrow_colour, "stroke-width"=>arrow_width, :fill=>arrow_colour)
        
      write(x+length/2, y-10, arrow_text, arrow_colour, "middle")
                  
    when length > 0
      line(x, y, x+length, y, :stroke=>arrow_colour, "stroke-width"=>arrow_width)
      polyline([[x+length-10, y-5], [x+length, y], [x+length-10, y+5]],
        :stroke=>arrow_colour, "stroke-width"=>arrow_width, :fill=>arrow_colour)
      
      write(x+length/2, y-10, arrow_text, arrow_colour, "middle")
           
    when length == 0
    end
  end
  
  # Draw an arrow in y direction starting in x,y with length and arrow_text. 
  def self.draw_arrow_y(x, y, length, arrow_colour, arrow_width, arrow_text)
    case 
    when length < 0
      line(x, y, x, y-length, :stroke=>arrow_colour, "stroke-width"=>arrow_width)
      polyline([[x-5, y-length-10], [x, y-length], [x+5, y-length-10]],
        :stroke=>arrow_colour, "stroke-width"=>arrow_width, :fill=>arrow_colour)
      
      write(x+10, y-length/2, arrow_text, arrow_colour, "start")
      
    when length > 0
      line(x, y, x, y-length, :stroke=>arrow_colour, "stroke-width"=>arrow_width)
      polyline([[x-5, y-length+10], [x, y-length], [x+5, y-length+10]],
        :stroke=>arrow_colour, "stroke-width"=>arrow_width, :fill=>arrow_colour)
        
      write(x+10, y-length/2, arrow_text, arrow_colour, "start")
      
    when length == 0
    end
  end
     
     
  # Draw a grid with 'step' spacing with 1 meter annotations.   
  def self.draw_grid(x_max,y_max,step)
    n_x = (x_max/step).round()
    n_y = (y_max/step).round()
    n_x_cur = 0
    n_y_cur = 0

    # Draw a grid with lines using 'step' spacing.   
    while n_x_cur <= n_x do
      line(n_x_cur*step, 0, n_x_cur*step, n_y*step, :stroke=>"gray" )     
      n_x_cur += 1
    end
    while n_y_cur <= n_y do
      line(0, n_y_cur*step, n_x*step, n_y_cur*step, :stroke=>"gray" )     
      n_y_cur += 1
    end
    
    draw_arrow_x(step, (n_y-1)*step, step, "black", 2, "1 m")
    draw_arrow_y(step, (n_y-1)*step, step, "black", 2, "1 m")
    
  end
  
  
  def self.draw_element(x1, y1, x2, y2, element_label)
    line(x1, y1, x2, y2, :stroke=>"black", "stroke-width"=>"2")
    dx = (y2-y1) 
    dy = (x2-x1)
    ds = ((dx.abs)**2 + (dy.abs)**2)**0.5
    dx = dx*20/ds
    dy = dy*20/ds
    x_c = (x2+x1)*0.5
    y_c = (y2+y1)*0.5
    
    write(x_c+dx, y_c-dy, "(#{element_label})", "black", "middle")
  end
  
  def self.draw_node(x, y, node_label)
    circle x, y, @rad, :stroke=>"black", "stroke-width"=>"2", :fill=>"white"
    write(x-15, y-15, "[#{node_label}]", "black", "end")
  end
  
  def self.draw_x_support(x, y)
    group :stroke=>"black", "stroke-width"=>"2", :fill=>"white" do
      polyline([
        [x-@rad, y],
        [x-3*@rad, y-(3.464/2*@rad)], 
        [x-3*@rad, y+(3.464/2*@rad)],
        [x-@rad, y]
        ])
      line(x-(3+0.433)*@rad, y-((3.464/2+0.433)*@rad), x-(3+0.433)*@rad, y+((3.464/2+0.433)*@rad))
    end
  end
  
  def self.draw_y_support(x,y)
    group :stroke=>"black", "stroke-width"=>"2", :fill=>"white" do
      polyline([
        [x, y+@rad],
        [x-(3.464/2*@rad), y+3*@rad], 
        [x+(3.464/2*@rad), y+3*@rad],
        [x, y+@rad]
        ])
      line(x-((3.464/2+0.433)*@rad), y+(3+0.433)*@rad, x+((3.464/2+0.433)*@rad), y+(3+0.433)*@rad)
    end
  end
  
  def self.draw_xy_support(x,y)
    group :stroke=>"black", "stroke-width"=>"2", :fill=>"white" do
      polyline([
        [x, y+@rad],
        [x-(3.464/2*@rad), y+3*@rad], 
        [x+(3.464/2*@rad), y+3*@rad],
        [x, y+@rad]
        ])
    end
  end
  


  # Gather basic data for graphics from the input and define some basic geometry parameters.
  # One spacing represents a distance of 1 meter.
  @spacing = $spacing
  @rad = @spacing/13
  @n_node = pt_g.xy_node.row_size()
  @n_element = pt_g.el_node.row_size()
  @x_max = (pt_g.xy_node.column_vectors[0].max + 3) * @spacing
  @y_max = (pt_g.xy_node.column_vectors[1].max + 3) * @spacing
  @x_co = pt_g.xy_node.column_vectors[0]
  @y_co = pt_g.xy_node.column_vectors[1]
  
  # Draw the grid and only then everthing else on it.  
  draw_grid(@x_max, @y_max, @spacing)
  
  # Draw all the elements.
  n = 0
  while n < @n_element do
    s_node = pt_g.el_node.[](n,0)
    f_node = pt_g.el_node.[](n,1)
    
    x_s = (@x_co[s_node-1]+2)*@spacing
    y_s = @y_max - (2+@y_co[s_node-1])*@spacing
    x_f = (@x_co[f_node-1]+2)*@spacing
    y_f = @y_max - (2+@y_co[f_node-1])*@spacing
    
    draw_element(x_s, y_s, x_f, y_f, (n+1).to_s)
    
    n += 1
  end
  
  # Draw all the nodes and their supports.
  n = 0
  while n < @n_node do
    x = (@x_co[n]+2)*@spacing
    y = @y_max - (2+@y_co[n])*@spacing
    
    xy_su = 1*pt_g.su.[](n,0) + 2*pt_g.su.[](n,1)
    
    draw_node(x, y, (n+1).to_s)
    
    case xy_su
    when 0
    when 1
      draw_x_support(x,y)
    when 2
      draw_y_support(x,y)
    when 3
      draw_xy_support(x,y)
    end
    
    force_x = pt_g.f.[](n,0)
    force_y = pt_g.f.[](n,1)
    
    draw_arrow_x(x, y, force_x, "red", 3, force_x.abs.to_s)
    draw_arrow_y(x, y, force_y, "red", 3, force_y.abs.to_s)
    
    n += 1
  end  
  
end

puts img.output

# Create a new .svg file.
picture = File.new("Samples/file.svg", "w")

# Open the created .svg file and write img in it.
File.open("Samples/file.svg", "w") do |f|
  f << img.output
end


