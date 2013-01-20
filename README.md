# Ruby Truss

Ruby Truss is a pure Ruby project for calculation of displacements axial and internal axial forces of trusses via Finite Element Method or FEM in short.


## Idea and creation

Ruby Truss (RT) was initialy created as a project for the Programming course at Faculty of Civil and Geodetical Engineering (University of Ljubljana). However its reasons for being developed further are now known only to Toby (you'll meet him soon enough).

It explores one of the main areas in civil engineering, which is FEM. I wanted to keep it simple so RT can only analyse plane truss constructions with forces applied in its nodes.
Nevertheless, it still has all the basic functionality of more complex engineering programs and can be used for any find of plane trusses.


## Features

* Save a truss project in a .xml file.
* Load an existing project from the Samples folder.
* Analyse a project and calculate the displacements of nodes, reactions in supports and internal axial forces.
* Create .svg graphic files for the truss model, displacements and internal forces.

Be mindful that RT is still in alpha release. Please report your bugs, if you find any.

I have no idea if and when the project will be extented beyond simple trusses, but if anyone has the will and energy to clean the code and extend its functionality, he/she is welcome to e-mail me so we can talk about it or simply fork a repository.


## Setting Ruby Truss up

In order for RT to work, you have to have Ruby 1.9.3 installed on your computer. In addition to Ruby you also have to install a rasem gem, which handles the creation of .svg files.

There is no installation, you just have to copy/fork the entire Ruby\_Truss folder onto your computer without changing the content of it. You can copy and run it from any folder destination you want, since it's programmed in its own raletive environment.


## Usage

To run the RT, open the Ruby\_Truss/Engine folder and start Run.rb. You can also do this via command line. This will open a command line window with the starting text describing the program (Toby says: "Hi.") and the menu for the possible RT operations. You can choose one of the following:
1. Create and save a new example: Before you choose the 1st option (Save) you must change the Data\_input.rb file so it matches your truss constructions and not the default one. All the instructions for building input matrixes are inside the Ruby file itself. Only after you've changed the Data\_input.rb file, can you select the 1st option. RT will then save your input into the Samples/(your\_truss\_name)/(your\_truss\_name).xml and return to the main menu.
2. Open an existing example and examine it: After you've saved your truss construction, you can examine it using the 2nd option. You can also examine other examples in the Samples folder. The examination will return all the basic truss data and also create a (choosen\_file)\_normal.svg file with a graphic representation of the undeformed truss model with all the labels. After that you'll be shown the main menu again.
3. Run an analysis of a defined example and show results: You can choose one truss sample in the Samples folder and run a static analysis using FEM. The results of the analysis will be shown on the screen and also saved in the (choosen\_file)\_displacements.svg and (choosen\_file)\_forces.svg files inside the Samples/(choosen\_file) folder. After the analysis you've be prompted with the main menu.
4. Exit the program: You will be asked (by Toby) to confirm your decision to leave RT.


## Example 1

In this section I will describe how to run an analysis of a simple truss construction named Example 1 (such an example already exists in the Sample folders so you can check your results).

First, you change the content of Data\_input.rb to match the following code:

    class Plane_Truss
      class Graphics
        # Global coordinates of nodes.
        @xy_node = Matrix[[-4,3], [0,3], [4,3], [0,0]]
    
        # Supports in [node, direction] for the truss.
        su = Matrix[[1,1], [0,0], [1,1], [0,0]]
    
        # Forces on the nodes.
        @f = Matrix[[0,0], [0,-80], [0,0], [0,0]]
    
        # Labels of start and end nodes of elements.
        @el_node = Matrix[[1,2], [2,3], [1,4], [2,4], [3,4]]
    
        # Elastic modulus and cross sections of elements.
        @em_a = Matrix[[3000,2], [3000,2], [3000,2], [3000,2], [3000,2]]
      end
    end
   

Second, you save the file with the 1st option in the main menu. After the file is saved you run the 2nd and 3rd option of the main menu, which create the necessary .svg files of the analysis results. Finally you can check these files, opening them up with an Internet browser of your choosing.


## Conslusion

If you're going to use Ruby Truss, I hope it comes in handy at any of your Statics or Programming courses. For any questions or further explanations I’m available on my e-mail (cesnik.jure@gmail.com).

Again thank you for using Ruby Truss and please keep Toby happy.


## About the author

My name is Jure Èesnik and I'm a postgraduate student of Civil Engineering. My area of expertise are in Building Informatics and BIM construction. For further information, check my LinkedIn account: <http://www.linkedin.com/profile/view?id=76666217>.


## Copyright

Copyright (c) 2013 Jure Èesnik. See LICENSE.txt for further details.
