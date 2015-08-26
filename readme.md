

##About
This project consists of two main parts:
1. For end users, a number of small interactive apps (the 3DP apps) to perform helpful tasks on 3D unstructured triangular meshes, such as scaling, converting, and hollowing. These apps are command line based and are intended to be run by dragging and dropping a 3D mesh model onto the app. These apps make extensive use of part 2.
2. For programmers, an improved interface to generate and run meshlabserver xml filter scripts. No more exporting and hand editing .mlx files, now these can be generated straight from the command line.

This project is written primarily in [Bash](https://en.wikipedia.org/wiki/Bash_%28Unix_shell%29), the Unix shell scripting language, however it also (in fact, primarily) runs on Windows via Cygwin. These scripts use various other programs to do most of the heavy lifting.


##History
This project was created to automate many of the repetitive tasks involved with processing and preparing 3D scans with color textures for 3D printing, although it is applicable to other use cases as well.

Although there are a growing number of tools to prepare models for 3D printing, many of these do not work with color or textures. In the Free software world [MeshLab](http://meshlab.sourceforge.net/) and [Blender](https://www.blender.org/) are the primary tools of choice for working with such models. Additional tools used include ADMesh and OpenSCAD.

While creating these programs, a simple yet improved interface to meshlabserver (the command line scripting version of MeshLab) was created. This may be useful to others (anyone who wants to script MeshLab) even if the 3DP apps are not used.

##Status
This code should be considered ALPHA quality at best. Interfaces and usage may change at any time, many planned features have not yet been implemented, some features have had little or no testing, any many bugs are surely waiting to be found. You have been warned! Still, even in its current state many features work well and reliably, so give it a shot!

#3DP APPS

##Metadata
In order to automate some tasks the 3DP apps need to know additional metadata about the model that it cannot determine on its own; this includes the model's scale ratio and "up" axis. This metadata is added to the end of the file name (before the extension); it consists of a number and a letter enclosed in parentheses, such as "model(-10Y).obj" or "model(1Z).stl".
  -Scale Ratio: the number indicates the scale ratio of the model; this can be positive or negative, integer or float. Positive numbers greater than 1 indicate that the model is scaled up, e.g. "2" indicates the model is twice its original size. "1" indicates the model is original size (no scaling). Positive decimal numbers indicate that the model is scaled down, e.g. ".1" indicates that the model is one tenth (or 10%) its original size. Negative numbers indicate an inverse scale ratio, for example "-10" indicates that the model is at 1:10 (or 1/10) scale, which is also equivalent to ".1".
  -Up axis: an annoying fact of the 3D software world is that no one can agree on which way is up! Generally speaking, 3D modeling programs assume "Y" is up and 3D printing programs assume "Z" is up, however there are exceptions, and some software (such as Blender and Shapeways) assume a different direction based on the file type. Valid values are "Y" and "Z".
When you use the 3DP apps they will prompt you for this metadata if it is needed but is not found; it is added to all output files automatically. You can also easily add it to your files with the 3DP_rename app.

##Units
Model units are assumed to be in mm, which is reflected in the output of all measurements, although in practice all operations are unitless. 

##Supported file types
With our current workflow we primarily use and support the following two file types:
  -[.obj](https://en.wikipedia.org/wiki/Wavefront_.obj_file) - for models with color texture data (UV mapping). Obj is a nice format, easily human readable, and enjoys widespread support (second only to stl).
  -[.stl](https://en.wikipedia.org/wiki/STL_%28file_format%29) - for geometry data only (no color). Stl has the absolutely widest support. Note that there are some color extensions to stl, however these are not widely support, and we do not attempt to support them either. If you want color IMO you're better off using a better format.
  
Additional formats supported in some way:
  -[.x3d](https://en.wikipedia.org/wiki/X3D) - supports color textures, primarily used to submit models to Shapeways.
  -[.xyz] - a simple format containing just a list of xyz vertices (a point cloud).
  -[.dxf](https://en.wikipedia.org/wiki/AutoCAD_DXF) - a primarily 2D format, used here to export 2D planar sections.
  
Additional model types ([.ply](https://en.wikipedia.org/wiki/PLY_%28file_format%29), [.dae](https://en.wikipedia.org/wiki/COLLADA), etc.) will almost certainly be added in the future (especially if they are requested), however for obvious reasons only formats supported by MeshLab can be added and likely only ASCII text formats can be fully supported. Note that based on the app additional input file types may work, but have not been tested.

Note that vertex colors are not currently explicitly supported. They may work fine, however no testing has been done. Explicit support will likely be added in the future.

##License
The 3DP apps are released under the GPLv2.

The meshlabserver interface (mlx.bsh) is released under the LGPLv2.1 so that you can use these functions in your own scripts, even if you do not publish your source code.

## Installation & Dependencies
###Windows
You will need to manually install the required dependencies; if you install them in a location different than described below you will need to edit the file "3DP-main.bsh" with the new locations.
  -[MeshLab](http://meshlab.sourceforge.net/) version 1.34BETA, C:/Program Files/VCG/MeshLab
  -[ADMesh](https://github.com/admesh/admesh) version 0.98.2, C:/Program Files/admesh
  -[OpenSCAD](http://www.openscad.org/) version 2015.03, C:/Program Files/OpenSCAD
  -[Cygwin](https://www.cygwin.com/), C:/cygwin64 (if different this location needs to be changed in 3DP-generate_apps.bsh, 3DP-generate_apps.cmd & 3DP-remove_apps.cmd)
  
  __Note that version 1.3.4BETA for 64 bit Windows is required.__ Older versions will mostly work but are missing some key features. Most notably, the measure_geometry & measure_topology filters do not work from meshlabserver in older versions (including 1.3.3), so any apps that depend on these will not work.
  
  3DP-cyg-install.bsh
  
  Install the 1.3.4BETA

###Linux
Linux is kinda sorta supported; I've actually given up on supporting Linux at the moment since it's just too hard to get the latest versions of software installed. For example, as of this writing (August 2015) the latest version of Meshlab packaged with Ubuntu (15.04) is 1.3.2, released over 3 years ago. There's a PPA for 1.3.3 but it's missing features. As noted above, MeshLab version 1.3.4BETA is needed for full support, however this was never released for Linux (even in source form), so what's needed is to compile a later version from SVN. 

In any case, the 3DP-generate_apps.bsh script should generate .desktop shortcuts that you can drag & drop models onto. If you can get a later version of MeshLab compiled it should work, or you can live with the reduced functionality of older versions.

###OS X
OS X should work with a bit of work, again rpovided you can get an updated copy of MeshLab compiled & installed. However, I don't own a Mac and am usure how to creat files to support dragging & dropping, so you're on your own at the moment.



## App Descriptions & Usage

  -3DP-2objNC - this will drop all color info from an obj file. Creates a new file with "NC" (for "no color") added to the end of the filename; the original is not changed. 'Cause sometimes you just want to deal with the geometry! Should work on any (mesh) input file MeshLab supports.
  -3DP_2objz - this will take your obj file, find any associated .mtl material file and texture files and wrap them all together in a zip file. Useful for transferring the complete model (with color data) to another location or uploading to a 3D printing service (e.g. Sculpteo). Currently only works on obj files.
  -3DP-2stl - if a non-stl file is dropped on this app it will make sure it is Z up, convert it to stl, run it through ADMesh for checks & automatic cleaning & save it as an ASCII stl. If an stl is dropped on this it will still run it through ADMesh for checks & automatic cleaning. __Note that this will overwrite the original stl file with the ADMesh output.__ Usually this is perfectly safe and desirable, however if your model has severe issues that ADMesh can't fix this may make it worse. Should work on any (mesh) input file MeshLab supports.
  -3DP-2x3dz - this will convert your model to x3d format, find any associated texture files,   wrap them all together in a zip file, and delete the x3d file. Primarily intended for submitting models to Shapeways. Should work on any (mesh) input file MeshLab supports.
  -3DP-center_x - currently just centers the x axis based on a measurement taken midway on the height of the object. _Will be changed in the future._
  -3DP-check_mesh - currently just measures geometry & topology of mesh. _Will be changed in the future._
  -3DP-hollow - a rather complicated script to hollow models for binder jetting 3D printing, e.g. full color stone. A work in progress; expect significant changes in the future. Note that this currently doesn't actually hollow the model; instead it will create the interior "negative volume". You will still need to import the original model into Blender & perform a boolean difference with the negative volume to actually create a hollow model.
  -3DP-pricing - calculates prices in full color stone for various 3D printing services; currently supports Shapeways & i.Materialize.
  -3DP-rename - renames the model and any associated secondary files (e.g. materials & textures), which are tedious to rename on their own. You can also keep the current name and use this to just add metadata. Contains some special rules for handling models produced by itSeez3D. Create new files with the new name, but does not delete the original.
  -3DP-scale - will scale the model to a different scale ratio. Note that this scales the model based on the new scale ratio, not based on the current model size. For example, if you have a model at 1:10 and you want to make it twice as big, you would enter "-5" (to convert to 1:5 scale), not "2". Creates a new model with different metadata; the original is not changed.
  -3DP-simplify - simplifies the model to a desired number of faces; automatically detects & supports textured models. Will create a new model with "-simp#K" appended to the filename, where "#" is the number of faces in thousands.
  -3DP-swapYZ - swaps the "up" axis, e.g. from Y to Z or vice versa. In reality the model is simply rotated by 90° about the X axis. Creates a new model with different metadata; the original is not changed.
  -mlx_scratch - a scratch file for development or writing your own scripts.

You should ensure that models are "clean" (2-manifold, no holes, etc.) before running these scripts or they may not work.



#MLX.BSH (meshlabserver interface)



##License
Mlx.bsh is released under the LGPLv2.1 so that you can use these functions in your own scripts, even if you do not publish your source code.

## Usage
ml_IF = meshlabserver input filename
ml_OF = meshlabserver output filename
ml_SF = meshlabserver .mlx filter script filename
ml_LF = meshlabserver log filename

#    ml_SF="TEMP3DP_filter_script.mlx"
#    mlx_begin
#    mlx_scale scale=-10
#    mlx_end
