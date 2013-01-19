
$spacing = 80
$x_max = ($pt_g.xy_node.column_vectors[0].max.abs +
  $pt_g.xy_node.column_vectors[0].min.abs + 4) * $spacing
$y_max = ($pt_g.xy_node.column_vectors[1].max.abs +
  $pt_g.xy_node.column_vectors[1].min.abs + 4) * $spacing


img = Rasem::SVGImage.new($x_max+1, $y_max+1) do  
  
  pt_g = $pt_g

  # Gather basic data for graphics from the input and define some basic geometry parameters.
  # One spacing represents a distance of 1 meter.
  @spacing = $spacing
  @rad = @spacing/13
  @n_node = pt_g.xy_node.row_size()
  @n_element = pt_g.el_node.row_size()
  @x_max = $x_max
  @y_max = $y_max
  @x_min = pt_g.xy_node.column_vectors[0].min.abs
  @y_min = pt_g.xy_node.column_vectors[1].min.abs
  @x_co = pt_g.xy_node.column_vectors[0]
  @y_co = pt_g.xy_node.column_vectors[1]
  @f_max = [pt_g.f.min.abs, pt_g.f.max.abs].max
  
  # Draw the grid and only then everthing else on it.  
  draw_grid(@x_max, @y_max, @spacing)

  # Display the headline of the picture.
  text(@spacing , @spacing-30, "Model of #{$truss_name} truss:", :font_family=>"Verdana",
    "font-size"=>20, "font-weight"=>"bold", "fill"=>"black", "text-anchor"=>"start")
  
  # Draw all the elements.
  n = 0
  while n < @n_element do
    s_node = pt_g.el_node.[](n,0)
    f_node = pt_g.el_node.[](n,1)
    
    x_s = (@x_co[s_node-1] + 2 + @x_min) * @spacing
    y_s = @y_max - (@y_co[s_node-1] + 2 + @y_min) * @spacing
    x_f = (@x_co[f_node-1] + 2 + @x_min) * @spacing
    y_f = @y_max - (@y_co[f_node-1] + 2 + @y_min) * @spacing
    
    draw_element(x_s, y_s, x_f, y_f, 2, "black", "(#{(n+1)})")
    
    n += 1
  end
  
  # Draw all the nodes, their supports and forces that are applied.
  n = 0
  while n < @n_node do
    x = (@x_co[n] + 2 + @x_min) * @spacing
    y = @y_max - (@y_co[n] + 2 + @y_min) * @spacing
    
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
    
    draw_arrow_x(x, y, @spacing*force_x/@f_max, "red", 3, force_x.abs.to_s)
    draw_arrow_y(x, y, @spacing*force_y/@f_max, "red", 3, force_y.abs.to_s)
    
    n += 1
  end  
  
  draw_Toby(@x_max-0.875*@spacing, @y_max-0.125*@spacing, @spacing)
    
end


# Create a new .svg file.
picture = File.new("Samples/#{$truss_name}/#{$truss_name}_normal.svg", "w")

# Open the created .svg file and write img in it.
File.open("Samples/#{$truss_name}/#{$truss_name}_normal.svg", "w") do |f|
  f << img.output
end

puts %{
A graphic file of the model was created in 
Samples/#{$truss_name}/#{$truss_name}_normal.svg.
}

f = ""
