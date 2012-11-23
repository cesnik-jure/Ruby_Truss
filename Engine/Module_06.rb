require 'matrix'
require 'matrix/eigenvalue_decomposition.rb'


# Opens up the Matrix class.
class Matrix
  # Defines a method to change a single value of an element in a matrix row i and collum j to the value of x.
  def []=(i, j, x)
    @rows[i][j] = x
  end
  
  # Puts matrixes in a prettier/more readable form.
  def mputs
    puts self.each_slice(self.column_size) {|r| p r }
  end
end


puts "-----Start try:------"
puts

# Input of all the data and its preparation for the FEM_Engine.rb.
# Numbers of start and end nodes of elements.
el_node = Matrix[[1, 2], [2, 3], [1, 4], [2, 4], [3, 4]]
# Global coordinates of nodes. 
xy_node = Matrix[[-4, 3], [0, 3], [4, 3], [0, 0]]
# Elastic modulus and cross sections of elements.
em_a = Matrix[[3000, 2], [3000, 2], [3000, 2], [3000, 2], [3000, 2]]  
# Supports in [node, direction] for the truss.
su = Matrix[[1,1], [1,2], [3,1], [3,2]] 
#
f = [0,0,0,-80,0,0,0,0] 

puts "Input data:"
puts "Numbers of start and end nodes of elements (el_node)."
puts el_node.mputs
puts "Global coordinates of nodes (xy_node)."
puts xy_node.mputs
puts "Elastic modulus and cross sections of elements (em_a)."
puts em_a.mputs


# Defines class Plane_Truss and opens it.
class Plane_Truss

  # Defines method plane_element_stiffness_m which calculates the stiffness matrix of an element in its local coordinate system.
  def plane_element_stiffness_m(xy_node_i, xy_node_j, em, a) 
    @x1 = xy_node_i.[](0)
    @y1 = xy_node_i.[](1)
    @x2 = xy_node_j.[](0)
    @y2 = xy_node_j.[](1)
    
    @x21 = @x2 - @x1
    @y21 = @y2 - @y1
    
    @em_a = em*a
    
    @ll = (@x21)**2 + (@y21)**2
    @l = Math.sqrt( @ll )
    @lll = @ll * @l
    
    @k_el = @em_a / @lll * Matrix.rows(
      [[@x21*@x21, @x21*@y21, (-1)*@x21*@x21, (-1)*@x21*@y21],
      [@y21*@x21, @y21*@y21, (-1)*@y21*@x21, (-1)*@y21*@y21],
      [(-1)*@x21*@x21, (-1)*@x21*@y21, @x21*@x21, @x21*@y21],
      [(-1)*@y21*@x21, (-1)*@y21*@y21, @y21*@x21, @y21*@y21]]
      )
      
    return @k_el  
  end
 
  # Defines method plane_element_axial_force which calculates the axial force in an element.
  def plane_element_axial_force(xy_node_i, xy_node_j, node_i, node_j, em, a, d)
    puts
    puts "plane_element_axial_forces"
     
    @x1 = xy_node_i.[](0)
    puts "x1"
    puts @x1
    @y1 = xy_node_i.[](1)
    puts "y1"
    puts @y1
    @x2 = xy_node_j.[](0)
    puts "x2"
    puts @x2
    @y2 = xy_node_j.[](1)
    puts "y2"
    puts @y2
    
    
    @x21 = @x2 - @x1
    puts "x21"
    puts @x21
    @y21 = @y2 - @y1
    puts "y21"
    puts @y21
    @l = Math.sqrt((@x21)**2 + (@y21)**2)
    puts "l"
    puts @l
    @cos = @x21/@l
    puts "cos"
    puts @cos
    @sin = @y21/@l
    puts "sin"
    puts @sin
    
    @em_a = em*a
    
    @i1 = (node_i - 1) * 2 + 1
    puts "i1"
    puts @i1
    @i2 = (node_j - 1) * 2 + 1
    puts "i2"
    puts @i2
    
    # fix = @sin * d.[](@i2 + 1, 0)
    # puts fix
    # puts fix.class


    # Array of displacements (in local coordinates) of element nodes.
    @d_el_11 = @cos * d.[](@i1 - 1, 0) + @sin * d.[](@i1, 0)
    @d_el_12 = @cos * d.[](@i1, 0) - @sin * d.[](@i1 - 1, 0)
    @d_el_21 = @cos * d.[](@i2 - 1, 0) + @sin * d.[](@i2, 0)
    @d_el_22 = @cos * d.[](@i2, 0) - @sin * d.[](@i2 - 1, 0)
    @d_el = [@d_el_11, @d_el_12, @d_el_21, @d_el_22]
    
    puts "d_el"
    puts @d_el
    
    # Specific deformation of the element (in the axial direction). 
    @sp_def = (@d_el[2] - @d_el[0])/@l
    puts "sp_def"
    puts @sp_def
    
    @f = (@em_a * @sp_def)
    puts "f"
    puts @f    
    
    return @f 
  end
  
  # Defines method add_element_in_the_truss_stiffness_m which includes the stiffness matrix of one element in
  # the stiffness matrix of the entire truss construction.
  def add_element_in_the_truss_stiffness_m(k_el, node_i, node_j, k_s)
    @k = k_s
    @i1 = (node_i - 1) * 2 + 1
    @i2 = (node_j - 1) * 2 + 1
    @place_in_k = [@i1 - 1, @i1, @i2 - 1, @i2]
    
    for i in 0..3
      @ii = @place_in_k[i]
      for j in 0..3
        @jj = @place_in_k[j]
        @k.[]=(@ii, @jj, @k.[](@ii, @jj) + k_el.[](i,j))
      end    
    end
            
    return @k  
  end


  # Defines method truss_stiffness_m which combines the stiffness matrixes of all the elements in
  # the stiffness matrix of the entire truss construction.
  def truss_stiffness_m(el_node, xy_node, em_a)
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
      @k_el = plane_element_stiffness_m(@xy_node_i, @xy_node_j, @em, @a)  
      @k = add_element_in_the_truss_stiffness_m(@k_el, @node_i, @node_j, @k)
    end
    
    return @k
    
  end 
        
  # Defines method reduced_truss_stiffness_m which prepares the truss stiffnes matrix k for further processing by
  # replacing the values of elements in rows and columns, which represent supported nodes, with 0.  
  def reduced_truss_stiffness_m(su, k)
    @su_dof = su.row_size()
    @dof = k.row_size()
    @k_r = k
    
    for l in 0..(@su_dof - 1)
      @i_dof = (su.[](l, 0) - 1) * 2 + su.[](l, 1) - 1
      for i in 0..(@dof - 1)
        @k_r.[]=(@i_dof, i, 0)
        @k_r.[]=(i, @i_dof, 0)
      end
      @k_r.[]=(@i_dof, @i_dof, 1) 
    end   
   
    return @k_r
  end
        
  # Defines method reduced_forces_v which prepares the forces vector f for further processing by
  # replacing the values of elements, which represent supported nodes, with 0.         
  def reduced_forces_v(su, f)
    @su_dof = su.row_size()
    @dof = f.length
    @f_r = f
    
    for l in 0..(@su_dof - 1)
      @i_dof = (su.[](l, 0) - 1) * 2 + su.[](l, 1) - 1
      @f_r.map! { |x| x == @i_dof ? 0 : x }
    end   
    
    return @f_r
  end
  
 
  # Defines method truss_axial_forces which prepares the data for the plane_element_axial_force method and sends it.
  # It then recieves back the axial forces in the elements which are written to the vector of forces v_f.  
  def truss_axial_forces(el_node, xy_node, em_a, d)
    puts
    puts "truss_axial_forces"
    
    @nu_el = el_node.row_size() # Number of elements in the truss.
    puts "nu_el"
    puts @nu_el
    @v_f = Array.new(@nu_el, 0) # Array of axial forces (create empty).
    puts "v_f"
    puts @v_f
    
    for l in 0..(@nu_el - 1)
      puts "l"
      puts l
      @node_i = el_node.[](l, 0)
      puts "node_i"
      puts @node_i
      @node_j = el_node.[](l, 1)
      puts "node_j"
      puts @node_j
      @xy_node_i = xy_node.row(@node_i - 1)
      puts "xy_node_i"
      puts @xy_node_i
      @xy_node_j = xy_node.row(@node_j - 1)
      puts "xy_node_j"
      puts @xy_node_j
      @em = em_a.[](l, 0)
      @a = em_a.[](l, 1)
      
      @v_f[l] = plane_element_axial_force(@xy_node_i, @xy_node_j, @node_i, @node_j, @em, @a, d)
      puts "v_f"
      puts @v_f
    end   
    
    return @v_f
  end         
end



truss = Plane_Truss.new

# Calculate truss stiffness matrix.
k = truss.truss_stiffness_m(el_node, xy_node, em_a)

# Reduce the truss stiffness matrix (preparation for martix multiplicaiton).
k_r = truss.reduced_truss_stiffness_m(su, k)

# Reduce the forces array and put it into column vector form (preparation for martix multiplicaiton).
f_r = Matrix.column_vector(truss.reduced_forces_v(su, f))

# Calculate the displacements of nodes. 
d = k_r.inverse * f_r
puts "Displacements of nodes (d)."
d.mputs

# Recalculate truss stiffness matrix!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
k = truss.truss_stiffness_m(el_node, xy_node, em_a)

# Calculate the reactions in truss supports.
f_v = Matrix.column_vector(f)
r = k * d - f_v
puts "Reactions in truss supports (r)."
r.mputs

# Calculate the axial forces in truss elements.
v_f = truss.truss_axial_forces(el_node, xy_node, em_a, d)
puts "Axial forces in truss elements (v_f)."
puts v_f
