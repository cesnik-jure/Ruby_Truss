class Square
  def f(x,y)
    @z1 = x
    @z2 = y
    @z1 = @z1 + @z2
    return @z1
  end
end

sq = Square.new
x = 5
y = 1
puts sq.f(x,y)
puts x
puts y
