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
vkor = Matrix[[-4,3],[0,3]]    # Coordinates of nodes in the truss. 
em = 3000                       # Elastic modulus of 
a = 2
vstev = [1, 3]

kzac = Matrix.build(6) { 0 }


# Defines class Ravninska_Palica and opens it.
class Ravninska_Palica
  # Defines method ravninska_palica_togostna_m which 
  def ravninska_palica_togostna_m(vkor,em,a)
    @x1 = vkor.[](0,0)
    @y1 = vkor.[](0,1)
    @x2 = vkor.[](1,0)
    @y2 = vkor.[](1,1)
    
    @x21 = @x2 - @x1
    @y21 = @y2 - @y1
    
    @ea = em * a
    
    @ll = (@x21)**2 + (@y21)**2
    @l = Math.sqrt( @ll )
    @lll = @ll * @l
    
    @ke = @ea / @lll * Matrix.rows(
      [[@x21*@x21, @x21*@y21, (-1)*@x21*@x21, (-1)*@x21*@y21],
      [@y21*@x21, @y21*@y21, (-1)*@y21*@x21, (-1)*@y21*@y21],
      [(-1)*@x21*@x21, (-1)*@x21*@y21, @x21*@x21, @x21*@y21],
      [(-1)*@y21*@x21, (-1)*@y21*@y21, @y21*@x21, @y21*@y21]]
      )
      
    return @ke  
  end
  
  
  # Defines method dodaj_palico_v_togostno_m_konst which 'repairs' the stiffness matrix of the entire construction.
  def dodaj_palico_v_togostno_m_konst(ke, vstev, kzac)
    @k = kzac
    @i1 = (vstev[0] - 1) * 2 + 1
    @i2 = (vstev[1] - 1) * 2 + 1
    @mesto_v_k = [@i1 - 1, @i1, @i2 - 1, @i2]
    
    for i in 0..3
      @ii = @mesto_v_k[i]
      for j in 0..3
        @jj = @mesto_v_k[j]
        @k.[]=(@ii, @jj, ke.[](i,j))
      end    
    end
    
    return @k  
  end
end

palica = Ravninska_Palica.new
ke = palica.ravninska_palica_togostna_m(vkor,em,a)

ke.mputs
puts ke.symmetric? 
keeig = Matrix::EigenvalueDecomposition.new(ke)

puts keeig.eigenvalues
puts keeig.eigenvectors
k = palica.dodaj_palico_v_togostno_m_konst(ke, vstev, kzac)
 
k.mputs


