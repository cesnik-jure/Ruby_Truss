# Opens Plane_Truss class and defines new methods in it.
class Plane_Truss

  # Defines method plane_element_stiffness_m which calculates the stiffness matrix of an element in its local coordinate system.
  def self.plane_element_stiffness_m 
    @x1 = @xy_node_i.[](0)
    @y1 = @xy_node_i.[](1)
    @x2 = @xy_node_j.[](0)
    @y2 = @xy_node_j.[](1)
    
    @x21 = @x2 - @x1
    @y21 = @y2 - @y1
    
    @ema = @em*@a
    
    @ll = (@x21)**2 + (@y21)**2
    @l = Math.sqrt( @ll )
    @lll = @ll * @l
    
    @k_el = @ema / @lll * Matrix.rows(
      [[@x21*@x21, @x21*@y21, (-1)*@x21*@x21, (-1)*@x21*@y21],
      [@y21*@x21, @y21*@y21, (-1)*@y21*@x21, (-1)*@y21*@y21],
      [(-1)*@x21*@x21, (-1)*@x21*@y21, @x21*@x21, @x21*@y21],
      [(-1)*@y21*@x21, (-1)*@y21*@y21, @y21*@x21, @y21*@y21]]
      )
      
  end
 
  # Defines method plane_element_axial_force which calculates the axial force in an element.
  def self.plane_element_axial_force
    
    @x1 = @xy_node_i.[](0)
    @y1 = @xy_node_i.[](1)
    @x2 = @xy_node_j.[](0)
    @y2 = @xy_node_j.[](1)
    
    @x21 = @x2 - @x1
    @y21 = @y2 - @y1
    @l = Math.sqrt((@x21)**2 + (@y21)**2)
    @cos = @x21/@l
    @sin = @y21/@l
    
    @ema = @em*@a
    
    @i1 = (@node_i - 1) * 2 + 1
    @i2 = (@node_j - 1) * 2 + 1    

    # Array of displacements (in local coordinates) of element nodes.
    @d_el_11 = @cos * @d.[](@i1 - 1, 0) + @sin * @d.[](@i1, 0)
    @d_el_12 = @cos * @d.[](@i1, 0) - @sin * @d.[](@i1 - 1, 0)
    @d_el_21 = @cos * @d.[](@i2 - 1, 0) + @sin * @d.[](@i2, 0)
    @d_el_22 = @cos * @d.[](@i2, 0) - @sin * @d.[](@i2 - 1, 0)
    @d_el = [@d_el_11, @d_el_12, @d_el_21, @d_el_22]
    
    # Specific deformation of the element (in the axial direction). 
    @sp_def = (@d_el[2] - @d_el[0])/@l
    
    @f = (@ema * @sp_def)
    
  end
  
  # Defines method add_element_in_the_truss_stiffness_m which includes the stiffness matrix of one element in
  # the stiffness matrix of the entire truss construction.
  def self.add_element_in_the_truss_stiffness_m
    @i1 = (@node_i - 1) * 2 + 1
    @i2 = (@node_j - 1) * 2 + 1
    @place_in_k = [@i1 - 1, @i1, @i2 - 1, @i2]
    
    for i in 0..3
      @ii = @place_in_k[i]
      for j in 0..3
        @jj = @place_in_k[j]
        @k.[]=(@ii, @jj, @k.[](@ii, @jj) + @k_el.[](i,j))
      end    
    end
  end


  # Defines method truss_stiffness_m which combines the stiffness matrixes of all the elements in
  # the stiffness matrix of the entire truss construction.
  def self.truss_stiffness_m
    @dof = xy_node.row_size()*2 # Degrees of freedom.
    @k = Matrix.build(@dof) { 0 }
    @nu_el = el_node.row_size() # Number of elements in the truss.
        
    for l in 1..(@nu_el)      
      @node_i = el_node.[](l - 1 , 0)
      @node_j = el_node.[](l - 1, 1)
      @xy_node_i = xy_node.row(@node_i - 1)
      @xy_node_j = xy_node.row(@node_j - 1)
      @em = em_a.[](l - 1, 0)
      @a = em_a.[](l - 1, 1)
      plane_element_stiffness_m
      add_element_in_the_truss_stiffness_m
    end
       
  end 
        
  # Defines method reduced_truss_stiffness_m which prepares the truss stiffnes matrix k for further processing by
  # replacing the values of elements in rows and columns, which represent supported nodes, with 0.  
  def self.reduced_truss_stiffness_m
    @su_dof = @su.row_size()
    @dof = @k.row_size()
    @k_r = @k.clone
    
    for l in 0..(@su_dof - 1)
      @i_dof = (@su.[](l, 0) - 1) * 2 + @su.[](l, 1) - 1
      for i in 0..(@dof - 1)
        @k_r.[]=(@i_dof, i, 0)
        @k_r.[]=(i, @i_dof, 0)
      end
      @k_r.[]=(@i_dof, @i_dof, 1) 
    end   
   
  end
        
  # Defines method reduced_forces_v which prepares the forces vector f for further processing by
  # replacing the values of elements, which represent supported nodes, with 0.         
  def self.reduced_forces_v
    @su_dof = su.row_size()
    @dof = f.row_size()
    @f_r = f
    
    for l in 0..(@su_dof - 1)
      @i_dof = (su.[](l, 0) - 1) * 2 + su.[](l, 1) - 1
      @f_r.each { |x| x == @i_dof ? 0 : x }
    end   
    
    return @f_r
  end
  
 
  # Defines method truss_axial_forces which prepares the data for the plane_element_axial_force method and sends it.
  # It then recieves back the axial forces in the elements which are written to the vector of forces v_f.  
  def self.truss_axial_forces
    
    @nu_el = el_node.row_size() # Number of elements in the truss.
    @v_f = Matrix.build(@nu_el, 1) {|row, col| 0 } # Array of axial forces (create empty).
    
    for l in 0..(@nu_el - 1)
      @node_i = el_node.[](l, 0)
      @node_j = el_node.[](l, 1)
      @xy_node_i = xy_node.row(@node_i - 1)
      @xy_node_j = xy_node.row(@node_j - 1)
      @em = em_a.[](l, 0)
      @a = em_a.[](l, 1)
      
      plane_element_axial_force
      @v_f.[]=(l, 0, @f)  
      
    end   
  end
  
  # Calculate truss stiffness matrix.
  truss_stiffness_m  
  # Reduce the truss stiffness matrix (preparation for martix multiplicaiton).
  reduced_truss_stiffness_m  
  # Reduce the forces array and put it into column vector form (preparation for martix multiplicaiton).
  reduced_forces_v  
  # Calculate the displacements of nodes. 
  @d = @k_r.inverse * @f_r
  # Calculate the reactions in truss supports.
  @f_v = @f
  @r = @k * @d - @f_v
  # Calculate the axial forces in truss elements.
  truss_axial_forces
   
end





