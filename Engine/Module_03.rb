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
elnode = Matrix[[1, 2], [2, 3], [1, 4], [2, 4], [3, 4]]
# Global coordinates of nodes. 
xynode = Matrix[[-4, 3], [0, 3], [4, 3], [0, 0]]
# Elastic modulus and cross sections of elements.
ema = Matrix[[3000, 2], [3000, 2], [3000, 2], [3000, 2], [3000, 2]]    

puts "Input data:"
puts "Numbers of start and end nodes of elements (evoz)."
puts elnode.mputs
puts "Global coordinates of nodes (xyvoz)."
puts xynode.mputs
puts "Elastic modulus and cross sections of elements (ema)."
puts ema.mputs


# Defines class Plane_Truss and opens it.
class Plane_Truss

  # Defines method plane_element_stiffness_m which calculates the stiffness matrix of an element in its local coordinate system.
  def plane_element_stiffness_m(xynodei, xynodej, em, a) 
    @x1 = xynodei.[](0)
    @y1 = xynodei.[](1)
    @x2 = xynodej.[](0)
    @y2 = xynodej.[](1)
    
    @x21 = @x2 - @x1
    @y21 = @y2 - @y1
    
    @ema = em*a
    
    @ll = (@x21)**2 + (@y21)**2
    @l = Math.sqrt( @ll )
    @lll = @ll * @l
    
    @ke = @ema / @lll * Matrix.rows(
      [[@x21*@x21, @x21*@y21, (-1)*@x21*@x21, (-1)*@x21*@y21],
      [@y21*@x21, @y21*@y21, (-1)*@y21*@x21, (-1)*@y21*@y21],
      [(-1)*@x21*@x21, (-1)*@x21*@y21, @x21*@x21, @x21*@y21],
      [(-1)*@y21*@x21, (-1)*@y21*@y21, @y21*@x21, @y21*@y21]]
      )
      
    return @ke  
  end
  
  # Defines method add_element_in_the_construction_stiffness_m which 'repairs' the stiffness matrix of the entire construction.
  def add_element_in_the_construction_stiffness_m(ke, nodei, nodej, ks)
    @k = ks
    puts "@k = #{@k}"
    @i1 = (nodei - 1) * 2 + 1
    puts @i1
    @i2 = (nodej - 1) * 2 + 1
    puts @i2
    @place_in_k = [@i1 - 1, @i1, @i2 - 1, @i2]
    puts @place_in_k
    
    for i in 0..3
      @ii = @place_in_k[i]
      for j in 0..3
        @jj = @place_in_k[j]
        @k.[]=(@ii, @jj, @k.[](@ii, @jj) + ke.[](i,j))
      end    
    end
    
    return @k  
  end


  # Defines method truss_stiffness_m ....
  def truss_stiffness_m(elnode, xynode, ema)
    puts "truss_stiffness_m"
    
    @dof = xynode.row_size()*2 # Degrees of freedom.
    puts "dof = #{@dof}"
    
    @k = Matrix.build(@dof) { 0 }
    puts @k
    
    @nuel = elnode.row_size() # Number of elements in the truss.
    puts @nuel
    
    for l in 1..(@nuel)
      puts "l = #{l}"
      
      @nodei = elnode.[](l - 1 , 0)
      puts @nodei
      @nodej = elnode.[](l - 1, 1)
      puts @nodej
      xynode.mputs
      @xynodei = xynode.row(@nodei - 1)
      puts @xynodei
      @xynodej = xynode.row(@nodej - 1)
      puts @xynodej
      @em = ema.[](l - 1, 0)
      puts @em
      @a = ema.[](l - 1, 1)
      puts @a
      @ke = plane_element_stiffness_m(@xynodei, @xynodej, @em, @a)       
      @ke.mputs
      @k.mputs    
      @k = add_element_in_the_construction_stiffness_m(@ke, @nodei, @nodej, @k)
      @k.mputs
           
    end
    
    return @k
    
  end 
        
end




truss = Plane_Truss.new
puts truss

k = truss.truss_stiffness_m(elnode, xynode, ema)

k.mputs



