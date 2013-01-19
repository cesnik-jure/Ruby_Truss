
$spacing = 80
$x_max = ($pt_g.xy_node.column_vectors[0].max + 3) * $spacing
$y_max = ($pt_g.xy_node.column_vectors[1].max + 3) * $spacing

img = Rasem::SVGImage.new($x_max+1, $y_max+1) do  
  
  pt_g = $pt_g

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

  # Display the headline of the picture.
  text(30, 50, "Model of #{$truss_name} truss:", :font_family=>"Verdana",
    "font-size"=>20, "font-weight"=>"bold", "fill"=>"black", "text-anchor"=>"start")
  
  # Draw all the elements.
  n = 0
  while n < @n_element do
    s_node = pt_g.el_node.[](n,0)
    f_node = pt_g.el_node.[](n,1)
    
    x_s = (@x_co[s_node-1]+2)*@spacing
    y_s = @y_max - (2+@y_co[s_node-1])*@spacing
    x_f = (@x_co[f_node-1]+2)*@spacing
    y_f = @y_max - (2+@y_co[f_node-1])*@spacing
    
    draw_element(x_s, y_s, x_f, y_f, 2, "black", "(#{(n+1)})")
    
    n += 1
  end
  
  # Draw all the nodes, their supports and forces that are applied.
  n = 0
  while n < @n_node do
    x = (@x_co[n]+2)*@spacing
    y = @y_max - (2+@y_co[n])*@spacing
    
    xy_su = 1*pt_g.su.[](n,0) + 2*pt_g.su.[](n,1)
    
    draw_node(x, y, "[#{(n+1)}]")
    
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


# Create a new .svg file.
picture = File.new("Samples/#{$truss_name}/#{$truss_name}_normal.svg", "w")

# Open the created .svg file and write img in it.
File.open("Samples/#{$truss_name}/#{$truss_name}_normal.svg", "w") do |f|
  f << img.output
end

f = ""
