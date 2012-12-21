$main_path = File.dirname(__FILE__)

require("#{$main_path}/new_methods")



original = Matrix[[0,0], [4,0], [9,0], [13,0], [4,4], [9,4]]
puts "original:"
puts original.object_id
original.mputs


copy = original.clone
puts "copy:"
puts copy.object_id
copy.mputs



copy.[]=(3,0,9999)
puts "copy:"
copy.mputs
puts "original:"
original.mputs