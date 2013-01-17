# Input of all the data and its preparation for the Engine.rb.

class Plane_Truss
  class Graphics
     
    # Global coordinates of nodes.
    # Input shape: @xy_node = Matrix[[1st node coordinates], [2nd node coordinates], ... , [last node coordinates]]
    @xy_node = Matrix[[0,0], [4,0], [9,0], [13,0], [4,4], [9,4]]
    # @xy_node = Matrix[[0,0], [0,5], [5,0]]
    
    # Supports in [node, direction] for the truss.
    # Input shape: @su = Matrix[[1st node supports], [2nd node supports], ... , [last node supports]] 
    #              0 - no support in that direction, 1 - support in that direction
    @su = Matrix[[1,1], [0,0], [0,0], [1,1], [0,0], [0,0]]
    # @su = Matrix[[1,1], [0,0], [1,1]]
    
    # Forces on the nodes.
    # Input shape: @f = Matrix[[1st node forces], [2nd node forces], ... , [last node forces]] 
    @f = Matrix[[0,0], [0,0], [0,0], [0,0], [0,-100], [0,-100]]
    # @f = Matrix[[0,0], [10,0], [0,0]]
    
    # Labels of start and end nodes of elements.
    # Input shape: @el_node = Matrix[[1st element start/end nodes], [2nd element start/end nodes], ... , [last element start/end nodes]] 
    @el_node = Matrix[[1,2], [2,3], [3,4], [1,5], [2,5], [3,5], [3,6], [4,6], [5,6]]
    # @el_node = Matrix[[1,2], [2,3], [1,3]]
  
    
    # Elastic modulus and cross sections of elements.
    # Input shape: @el_node = Matrix[[1st element E and A], [2nd element E and A], ... , [last element E and A]] 
    @em_a = Matrix[[3000,0.5], [3000,0.5], [3000,0.5], [3000,2], [3000,1], [3000,1], [3000,1], [3000,2], [3000,2]]
    # @em_a = Matrix[[100000,2], [100000,1], [100000,0.5]]
    
  end
end
   
