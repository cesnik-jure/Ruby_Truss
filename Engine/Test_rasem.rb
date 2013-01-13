require 'rasem'
img = Rasem::SVGImage.new(1000,1000) do
set_width 150
set_height 150
board = [['x', 'o', 'x'],
         ['o', '-', 'o'],
         ['x', 'o', 'x']]
def draw_x(x,y)
  group :stroke=>"red" do
    line x-20, y-20, x+20, y+20
    line x-20, y+20, x+20, y-20
  end
end

def draw_o(x,y)
  circle x, y, 20, :stroke=>"blue", :fill=>"white"
end

group :stroke=>"black" do  
  rectangle 0, 0, 150, 150, :stroke_width=>2, :fill=>"white"
  line 50, 0, 50, 150
  line 100, 0, 100, 150
  line 0, 50, 150, 50
  line 0, 100, 150, 100
end

board.each_with_index do |row, row_index|
  row.each_with_index do |cell, column_index|
    if cell == "x"
      draw_x row_index * 50 + 25, column_index * 50 + 25
    elsif cell == "o"
      draw_o row_index * 50 + 25, column_index * 50 + 25
    end
  end
end
end

puts img.output

picture = File.new("Samples/file.svg", "w")

File.open("Samples/file.svg", "w") do |f|
  f << img.output
end

