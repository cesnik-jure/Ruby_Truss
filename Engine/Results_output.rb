class Plane_Truss  
  class Graphics
   
    nu_of_row = Plane_Truss.d.row_size()
    
    # Builds new d, r and matrixes in Plane_Truss::Graphics class.
    @d = Matrix.build(nu_of_row/2, 2) {|row, col| 0 }
    @r = Matrix.build(nu_of_row/2, 2) {|row, col| 0 }
    @v_f = Plane_Truss.v_f.clone
    
    
    # Writes a new su 2 columns matrix. 
    row_nu = 0 
    for i in 0..(nu_of_row/2 - 1)
      for j in 0..1
        @d.[]=(i, j, Plane_Truss.d.[](row_nu, 0))
        @r.[]=(i, j, Plane_Truss.r.[](row_nu, 0))
        row_nu += 1
      end  
    end  
  
    
    puts "\n-----FEM Calculation results-----\n"
    
    puts "Displacements of nodes (d) in [m]."
    @d = @d.collect { |e| e.round(5) }
    @d.mputs
    puts "Reactions in truss supports (r) in [kN]."
    @r = @r.collect { |e| e.round(2) }
    @r.mputs
    puts "Axial forces in truss elements (v_f) in [kN]."
    @v_f = @v_f.collect { |e| e.round(2) }
    @v_f.mputs
    
  end 
end