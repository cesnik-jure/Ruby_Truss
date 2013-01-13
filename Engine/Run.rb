$main_path = File.dirname(__FILE__)

require("#{$main_path}/methods_new")

puts %{--- RUBY TRUSS ---
  
Welcome to Ruby Truss, a simple FEM program for plane truss analysis.

This program was created as a project for a Programming course at the
Faculty of Civil and Geodetical Engineering, University of Ljubljana.

---------------------------------------------------------------------
Version: 0.1
Author: Jure Cesnik
Mentor: doc. dr. Matevz Dolenc
---------------------------------------------------------------------


Starting Ruby Truss program.
  
}

quit = false
choice = ""

until quit == true
   
  case choice
    
  when "1"
    $truss_name = ""
    while $truss_name == ""
    
    puts "File name of the truss:"
    $truss_name = gets.chomp
    
    require("#{$main_path}/data_input")
    require("#{$main_path}/data_output")
    require("#{$main_path}/file_save")
    end
    
    choice = ""
    
  when "2"
    $truss_name = ""
    while $truss_name == ""
    puts "Name of the truss you want to open and examine:"
    $truss_name = gets.chomp
    end
    
    require("#{$main_path}/file_load") 
    require("#{$main_path}/data_output")
    
    choice = ""
 
  when "3"
    $truss_name = ""
    while $truss_name == ""
    puts "Name of the truss you want to analyse:"
    $truss_name = gets.chomp
    end
    
    require("#{$main_path}/file_load")
    require("#{$main_path}/engine")
    require("#{$main_path}/results_output")
    
    choice = ""
    
  when "4"
    puts "TO BE..."
    sleep 5
    quit = true
      
  when "5"
    puts %{      
  /\\_/\\       This kitty is sad to see you go...
 ( o.o )      Do you really want to exit? [Y/anykey]
  > ^ <
  
      }
    
    if gets.chomp == ("y" or "Y")
      puts %{      
  /\\_/\\       Poor kitty...
 ( x.x )      The program will terminate in 5 seconds.
  > ^ <
  
      }
      sleep 5
      quit = true
    else
      puts %{      
  /\\_/\\       Kitty is happy.
 ( ^.^ )      
  > v <
  
(The program will still terminate in 10 seconds.)  
  
      }
    
      sleep 10
      quit = true
    end
    
    quit = true
    
  else
        
    puts %{
Choose one of the following options:
1 - Create and save a new example. 
2 - Open an existing example and examine it.
3 - Run an analysis of a defined example.
4 - View results of an analysis.
5 - Exit the program.
      }
    
    choice = gets.chomp
    redo
  end

end


