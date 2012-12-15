require 'rubygems'
require 'builder'

favorites = {
  'candy' => 'Neccos', 'novel' => 'Empire of the Sun', 'holiday' => 'Easter'
}

# Ustvari novo mapo, če ta še en obstaja
truss_name = "truss_sample"
Dir::mkdir("Samples/" + truss_name) unless File.exists?("Samples/" + truss_name) 

file = File.new("Samples/" + truss_name + "/" + truss_name + ".xml", "w")
xml = Builder::XmlMarkup.new( :target => file, :indent => 2 )

xml.instruct! :xml, :version => "1.1", :encoding => "UTF-8"

xml.favorites do 
 favorites.each do | name, choice |
  xml.favorite( choice, :item => name )
 end
end

file.close

