require 'rasem'

$main_path = File.dirname(__FILE__)
require("#{$main_path}/methods_new")
load("#{$main_path}/data_input.rb")



$pt_g = Plane_Truss::Graphics

class Rasem::SVGImage

  pt_g = $pt_g 
     
  def write(x, y, string, colour, align)
    text x, y, string, :font_family=>"Verdana", "font-size"=>12, "fill"=>colour, "text-anchor"=>align
  end
  
  # Draw an arrow in x direction starting in x,y with length and arrow_text.    
  def draw_arrow_x(x, y, length, arrow_colour, arrow_width, arrow_text)
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
  def draw_arrow_y(x, y, length, arrow_colour, arrow_width, arrow_text)
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
  def draw_grid(x_max,y_max,step)
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
  
  
  def draw_element(x1, y1, x2, y2, line_width, line_stroke, element_label)
    line(x1, y1, x2, y2, :stroke=>line_stroke, "stroke-width"=>line_width)
    dx = (y2-y1) 
    dy = (x2-x1)
    ds = ((dx.abs)**2 + (dy.abs)**2)**0.5
    dx = dx*20/ds
    dy = dy*20/ds
    x_c = (x2+x1)*0.5
    y_c = (y2+y1)*0.5
    
    write(x_c+dx, y_c-dy, element_label, line_stroke, "middle")
  end
  
  def draw_node(x, y, node_label)
    circle x, y, @rad, :stroke=>"black", "stroke-width"=>"2", :fill=>"white"
    write(x-15, y-15, node_label, "black", "end")
  end
  
  def draw_x_support(x, y)
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
  
  def draw_y_support(x,y)
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
  
  def draw_xy_support(x,y)
    group :stroke=>"black", "stroke-width"=>"2", :fill=>"white" do
      polyline([
        [x, y+@rad],
        [x-(3.464/2*@rad), y+3*@rad], 
        [x+(3.464/2*@rad), y+3*@rad],
        [x, y+@rad]
        ])
    end
  end
end

