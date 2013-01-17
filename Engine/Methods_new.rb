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


class Plane_Truss
  # Defines self methods for calling the instance variables inside the Plane_Truss class.
  def self.xy_node; @xy_node end
  def self.su; @su end
  def self.f; @f end
  def self.em_a; @em_a end
  def self.el_node; @el_node end
  def self.d; @d end
  def self.r; @r end
  def self.v_f; @v_f end
  
  class Graphics
    # Defines self methods for calling the instance variables inside the Plane_Truss::Graphics class.
    def self.xy_node; @xy_node end
    def self.su; @su end
    def self.f; @f end
    def self.em_a; @em_a end
    def self.el_node; @el_node end
  end
  
end