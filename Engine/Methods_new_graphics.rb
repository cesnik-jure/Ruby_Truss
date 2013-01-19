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
    n_x_cur = 1
    n_y_cur = 1

    # Draw a grid with lines using 'step' spacing.   
    while n_x_cur <= n_x do
      line(n_x_cur*step, step, n_x_cur*step, n_y*step, :stroke=>"gray" )     
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
    dx = dx*(20+line_width)/ds
    dy = dy*(20+line_width)/ds
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
  
  def draw_Toby(x, y, size)
    
    @output << <<-PAW
<g transform="translate(#{x},#{y}) scale(#{size/2500.0},-#{size/2500.0})"
fill="#000000" stroke="none">
<path d="M696 1980 c-145 -57 -208 -159 -209 -335 0 -103 27 -197 85 -291 111
-184 268 -226 385 -103 67 71 101 210 89 369 -13 185 -72 302 -177 355 -58 30
-106 31 -173 5z"/>
<path d="M1302 1965 c-85 -38 -182 -155 -215 -260 -36 -112 -29 -293 14 -378
25 -49 85 -114 120 -133 79 -40 181 -2 259 97 88 112 137 240 147 384 9 138
-19 209 -105 269 -37 26 -54 31 -115 33 -48 2 -83 -2 -105 -12z"/>
<path d="M145 1507 c-47 -22 -113 -103 -130 -160 -30 -102 -13 -228 51 -365
40 -88 98 -153 167 -188 126 -65 291 -5 350 126 70 156 -60 487 -225 571 -54
28 -168 36 -213 16z"/>
<path d="M1693 1445 c-74 -37 -137 -111 -188 -218 -68 -144 -77 -251 -30 -363
22 -53 42 -73 100 -100 98 -46 176 -24 271 79 130 141 190 378 126 503 -58
112 -171 152 -279 99z"/>
<path d="M845 1143 c-66 -23 -110 -70 -169 -181 -50 -95 -80 -123 -186 -177
-61 -32 -164 -143 -201 -220 -31 -65 -34 -77 -34 -170 0 -87 3 -107 26 -155
37 -79 97 -133 205 -187 82 -40 104 -47 171 -50 69 -4 92 0 191 31 63 20 131
36 152 36 20 0 82 -14 136 -32 81 -26 116 -32 189 -32 109 0 176 21 270 89 55
39 69 56 102 121 32 66 37 87 41 164 7 134 -13 186 -102 275 -39 39 -103 90
-142 113 -74 45 -104 79 -187 219 -47 77 -90 115 -164 143 -80 31 -228 37
-298 13z"/>
</g>
      PAW

  end
              
  
end

