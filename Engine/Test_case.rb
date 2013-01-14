$main_path = File.dirname(__FILE__)

require("#{$main_path}/methods_new")

xy = Matrix[[1.4234,44.456],[3.0,6345.21222345645656],[0.00000000000000000000001232134,12.4545645632434545623424423]]

xy.mputs

xy = xy.collect { |e| e.round(2) }

xy.mputs

# r_node = xy.row_size()
# c_node = xy.column_size()
# 
# for n in 1..(r_node)
  # for m in 1..(c_node)
    # xy.[]=(n - 1 , m - 1,xy.[](n - 1 , m - 1).round(2))
  # end
# end
# 
# xy.mputs