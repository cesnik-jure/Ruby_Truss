# Input of all the data and its preparation for the Engine.rb.

class Plane_Truss
  class Graphics
     
    e = 2.1*10**8 # [kPa]
    a_o = 0.4*10**(-2) # [m^2]
    a_z = 0.2*10**(-2) # [m^2]
     
    # Global coordinates of nodes.
    # Input shape: @xy_node = Matrix[[1st node coordinates], [2nd node coordinates], ... , [last node coordinates]]
    # @xy_node = Matrix[[0,0], [4,0], [9,0], [13,0], [4,4], [9,4]]
    @xy_node = Matrix[
      [0,0], [4,0], [0,4], [4,4],
      [0,8], [4,8], [0,12], [4,12],
      [-4,16], [-4,20], [0,16], [0,20],
      [4,16], [4,20], [8,16], [6,19.5],
      [12,16], [10,18.5], [16,16], [14,17.5],
      [20,16]
      ]
    
    # Supports in [node, direction] for the truss.
    # Input shape: @su = Matrix[[1st node supports], [2nd node supports], ... , [last node supports]] 
    #              0 - no support in that direction, 1 - support in that direction
    # @su = Matrix[[1,1], [0,0], [0,0], [1,1], [0,0], [0,0]]
    @su = Matrix[
      [1,1], [1,1], [0,0], [0,0],
      [0,0], [0,0], [0,0], [0,0],
      [0,0], [0,0], [0,0], [0,0],
      [0,0], [0,0], [0,0], [0,0],
      [0,0], [0,0], [0,0], [0,0],
      [0,0]
      ]
    
    # Forces on the nodes.
    # Input shape: @f = Matrix[[1st node forces], [2nd node forces], ... , [last node forces]] 
    # @f = Matrix[[0,0], [0,0], [0,0], [0,0], [0,-100], [0,-100]]
    @f = Matrix[
      [0,0], [0,0], [0,0], [0,0],
      [0,0], [0,0], [0,0], [0,0],
      [0,-400], [0,0], [0,0], [0,0],
      [0,0], [0,0], [0,0], [0,0],
      [0,0], [0,0], [0,-200], [0,0],
      [0,0]
      ]
    
    # Labels of start and end nodes of elements.
    # Input shape: @el_node = Matrix[[1st element start/end nodes], [2nd element start/end nodes], ... , [last element start/end nodes]] 
    # @el_node = Matrix[[1,2], [2,3], [3,4], [1,5], [2,5], [3,5], [3,6], [4,6], [5,6]]
    @el_node = Matrix[
      [1,2], [1,3], [2,3], [2,4],
      [3,4], [3,5], [4,5], [4,6],
      [5,6], [5,7], [6,7], [6,8],
      [7,8], [7,11], [8,11], [8,13],
      [9,11], [9,10], [9,12], [10,12],
      [11,12], [11,13], [13,12], [12,14],
      [13,14], [13,15], [13,16], [14,16],
      [15,16], [15,17], [15,18], [16,18],
      [17,18], [17,19], [17,20], [18,20],
      [19,20], [19,21], [20,21]
      ]
    
    # Elastic modulus and cross sections of elements.
    # Input shape: @el_node = Matrix[[1st element E and A], [2nd element E and A], ... , [last element E and A]] 
    # @em_a = Matrix[[3000,0.5], [3000,0.5], [3000,0.5], [3000,2], [3000,1], [3000,1], [3000,1], [3000,2], [3000,2]]
    @em_a = Matrix[
      [e,a_o], [e,a_o], [e,a_z], [e,a_o],
      [e,a_o], [e,a_o], [e,a_z], [e,a_o],
      [e,a_o], [e,a_o], [e,a_z], [e,a_o],
      [e,a_o], [e,a_o], [e,a_z], [e,a_o],
      [e,a_o], [e,a_o], [e,a_z], [e,a_o],
      [e,a_o], [e,a_o], [e,a_z], [e,a_o],
      [e,a_o], [e,a_o], [e,a_z], [e,a_o],
      [e,a_z], [e,a_o], [e,a_z], [e,a_o],
      [e,a_z], [e,a_o], [e,a_z], [e,a_o],
      [e,a_z], [e,a_o], [e,a_o]
      ]
    
  end
end
   
