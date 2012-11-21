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
puts "Numbers of start and end nodes of elements (evoz)."
puts el_node.mputs
puts "Global coordinates of nodes (xyvoz)."
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
        
        
  def reduced_forces_m(su, f)
    @su_dof = su.row_size()
    puts "su_dof = #{@su_dof}"
    @dof = f.length
    puts "dof = #{@dof}"
    @f_r = f
    puts "f_r = #{@f_r}"
    
    for l in 0..(@su_dof - 1)
      puts "l = #{l}"
      @i_dof = (su.[](l, 0) - 1) * 2 + su.[](l, 1) - 1
      puts "i_dof = #{@i_dof}"
      @f_r.map! { |x| x == @i_dof ? 0 : x }
      puts "f_r = #{@f_r}"
    end   
    
    return @f_r
  end
              
end



truss = Plane_Truss.new

k = truss.truss_stiffness_m(el_node, xy_node, em_a)
k.mputs

k_r = truss.reduced_truss_stiffness_m(su, k)
k_r.mputs
f_r = truss.reduced_forces_m(su, f)
puts f_r





