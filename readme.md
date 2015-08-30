

##About
This project consists of two main parts:
1. For end users, a number of small interactive apps to perform helpful tasks on 3D unstructured triangular meshes, such as scaling, converting, and hollowing. These apps are command line based and are intended to be run by dragging and dropping a 3D mesh model onto the app. These apps make extensive use of part 2.
2. For programmers, an improved interface to generate and run meshlabserver xml filter scripts. No more exporting and hand editing .mlx files, now these can be generated straight from the command line.

This project is written primarily in [Bash](https://en.wikipedia.org/wiki/Bash_%28Unix_shell%29), the Unix shell scripting language, however it also (in fact, primarily) runs on Windows via Cygwin. These scripts use various other programs to do most of the heavy lifting.


##History
This project was created to automate many of the repetitive tasks involved with processing and preparing 3D scans with color textures (primarily of people) for 3D printing, although it is applicable to other use cases as well.

Although there are a growing number of tools to prepare models for 3D printing, many of these do not work with color or textures. In the Free software world [MeshLab](http://meshlab.sourceforge.net/) and [Blender](https://www.blender.org/) are the primary tools of choice for working with such models. Additional tools used include ADMesh and OpenSCAD, however these only work with STLs and are thus suitable for colorless geometry data only.

While creating these programs, a simple yet improved interface to meshlabserver (the command line scripting version of MeshLab) was created. This may be useful to others (anyone who wants to script with MeshLab) even if the 3DP apps are not used.

##Status
This code should be considered ALPHA quality at best. Interfaces and usage may change at any time, many planned features have not yet been implemented, some features have had little or no testing, any many bugs are surely waiting to be found. You have been warned! Still, even in its current state many features work well and reliably, so give it a shot!

#3DP APPS

##Metadata
In order to automate some tasks the 3DP apps need to know additional metadata about the model that it cannot determine on its own; this includes the model's scale ratio and "up" axis. This metadata is added to the end of the file name (before the extension); it consists of a number and a letter enclosed in parentheses, such as "model(-10Y).obj" or "model(1Z).stl".
  -Scale Ratio: Particularly for 3D scans of real world subjects it is important to know how the size of the 3D model relates to reality. This number indicates the scale ratio of the model; this can be positive or negative, integer or float. Positive numbers greater than 1 indicate that the model is scaled up, e.g. "2" indicates the model is twice its original size. "1" indicates the model is original size (no scaling). Positive decimal numbers indicate that the model is scaled down, e.g. ".1" indicates that the model is one tenth (or 10%) its original size. Negative numbers indicate an inverse scale ratio, for example "-10" indicates that the model is at 1:10 (or 1/10) scale, which is also equivalent to ".1".
  -Up axis: an annoying fact of the 3D software world is that no one can agree on which way is up! Valid values are "Y" and "Z". Generally speaking, 3D modeling programs assume "Y" is up and 3D printing programs assume "Z" is up, however there are exceptions, and some software (such as Blender and Shapeways) assume a different orientation based on the file type. 
When you use the 3DP apps they will prompt you for this metadata if it is needed but is not found; it is added to all output files automatically. You can also easily add it to your files with the 3DP_rename app.

##Units
Model units are assumed to be in mm. This is true even if the file type specifies the units (such as X3D files, which are defined to be in meters). These units are reflected in the output of all measurements (such as length, area & volume), although in practice all operations are unitless.

##Supported file types
The following two file types and options are primarily supported:
  -[.obj](https://en.wikipedia.org/wiki/Wavefront_.obj_file) - for models with color texture data (UV mapping). Obj is a nice format, easily human readable, and enjoys widespread support (second only to stl).
  -[.stl](https://en.wikipedia.org/wiki/STL_%28file_format%29) - for geometry data only (no color). Stl has the absolutely widest support. Note that there are some color extensions to stl, however these are not widely support, and we do not attempt to support them either. If you want color IMO you're better off using a better format.
  
Additional formats supported in some way:
  -[.x3d](https://en.wikipedia.org/wiki/X3D) - supports color textures, primarily used to submit models to Shapeways.
  -[.xyz] - a simple format containing just a list of xyz vertices (a point cloud).
  -[.dxf](https://en.wikipedia.org/wiki/AutoCAD_DXF) - a primarily 2D format, used here to export 2D planar sections.
  
Support for additional model types ([.ply](https://en.wikipedia.org/wiki/PLY_%28file_format%29), [.dae](https://en.wikipedia.org/wiki/COLLADA), etc.) is planned for the future, however for obvious reasons only formats supported by MeshLab can be added and likely only ASCII text formats can be fully supported. Note that based on the app additional input file types may work, but have not been tested.

Note that vertex colors are not currently explicitly supported. They may work fine, however no testing has been done. Explicit support is planned for the future.

##Licensing
The original code in this repository is released under the LGPLv2.1. This means that you are free to use them as you please, and even use the various scripts and functions (such as mlx.bsh) in your own programs and scripts without being required to share your  scripts (but it would be nice). However, if you make any changes or improvements to the scripts and functions included here you need to share those changes back. 

mlx_scratch.bsh is an example & testing script & is released into the public domain.

Models in the test_models directory are licensed under the Creative Commons Attribution-ShareAlike 4.0 International License. To view a copy of this license, visit http://creativecommons.org/licenses/by-sa/4.0/ or send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.

Additional software that is include in this repository that we didn't write, but am extremely grateful for!

funcs.bc
Source: http://phodd.net/gnu-bc/
License: not sure, but it is certainly freely available

## Installation & Dependencies
###Windows
You will need to manually install the required dependencies; if you install them in a location different than described below you will need to edit the file "3DP-main.bsh" with the new locations.
  -[MeshLab](http://meshlab.sourceforge.net/) version 1.34BETA, C:/Program Files/VCG/MeshLab
  -[ADMesh](https://github.com/admesh/admesh) version 0.98.2, C:/Program Files/admesh
  -[OpenSCAD](http://www.openscad.org/) version 2015.03, C:/Program Files/OpenSCAD
  -[Cygwin](https://www.cygwin.com/), C:/cygwin64 (if different this location needs to be changed in 3DP-generate_apps.bsh, 3DP-generate_apps.cmd & 3DP-remove_apps.cmd)
  
__Note that version 1.3.4BETA for 64 bit Windows is required.__ Older versions will mostly work but are missing some key features. Most notably, the measure_geometry & measure_topology filters do not work from meshlabserver in older versions (including 1.3.3), so any apps that depend on these will not work.
  
After installing Cygwin, you can run the file bash/3DP-cyg-install.bsh to automatically install additional dependencies within Cygwin. Note that this uses [apt-cyg](https://github.com/transcode-open/apt-cyg)


###Linux
Linux is kinda sorta supported; I've actually given up on supporting Linux at the moment since it's just too hard to get the latest versions of software installed. For example, as of this writing (August 2015) the latest version of Meshlab packaged with Ubuntu (15.04) is 1.3.2, released over 3 years ago. There's a PPA for 1.3.3 but it's missing features. As noted above, MeshLab version 1.3.4BETA is needed for full support, however this was never released for Linux (even in source form), so what's needed is to compile a later version from SVN. 

In any case, the 3DP-generate_apps.bsh script should generate .desktop shortcuts that you can drag & drop models onto. If you can get a later version of MeshLab compiled it should work, or you can live with the reduced functionality of older versions.

###OS X
OS X should work with a bit of work, again provided you can get an updated copy of MeshLab compiled & installed. However, I don't own a Mac and am unsure how to create files to support dragging & dropping, so you're on your own at the moment.

## App Brief Descriptions & Usage

  -3DP-2objNC - this will drop all color info from an obj file. Creates a new file with "NC" (for "no color") added to the end of the filename; the original is not changed. 'Cause sometimes you just want to deal with the geometry! Should work on any (mesh) input file MeshLab supports.
  -3DP_2objz - this will take your obj file, find any associated .mtl material file and texture files and wrap them all together in a zip file. Useful for transferring the complete model (with color data) to another location or uploading to a 3D printing service (e.g. Sculpteo). Currently only works on obj files.
  -3DP-2stl - if a non-stl file is dropped on this app it will make sure it is Z up, convert it to stl, run it through ADMesh for checks & automatic cleaning & save it as an ASCII stl. If an stl is dropped on this it will still run it through ADMesh for checks & automatic cleaning. __Note that this will overwrite the original stl file with the ADMesh output.__ Usually this is perfectly safe and desirable, however if your model has severe issues that ADMesh can't fix this may make it worse. Should work on any (mesh) input file MeshLab supports.
  -3DP-2x3dz - this will convert your model to x3d format, find any associated texture files,   wrap them all together in a zip file, and delete the x3d file. Primarily intended for submitting models to Shapeways. Should work on any (mesh) input file MeshLab supports. _NOTE: I've had issues with x3d for some models, so this is planned to be replaced with 2daez in the not too distant future._
  -3DP-check_mesh - currently just measures geometry & topology of mesh. _Will be changed in the future._
  -3DP-hollow - a rather complicated script to hollow models for binder jetting 3D printing, e.g. full color stone. A work in progress; expect significant changes in the future. Note that this currently doesn't actually hollow the model; instead it will create the interior "negative volume". You will still need to import the original model into Blender & perform a boolean difference with the negative volume to actually create a hollow model.
  -3DP-pricing - calculates prices in full color stone for various 3D printing services; currently supports Shapeways & i.Materialize.
  -3DP-rename - renames the model and any associated secondary files (e.g. materials & textures), which are tedious to rename on their own. You can also keep the current name and use this to just add metadata. Contains some special rules for handling models produced by itSeez3D. Create new files with the new name, but does not delete the original.
  -3DP-scale - will scale the model to a different scale ratio. Note that this scales the model based on the new scale ratio, not based on the current model size. For example, if you have a model at 1:10 and you want to make it twice as big, you would enter "-5" (to convert to 1:5 scale), not "2". Creates a new model with different metadata; the original is not changed.
  -3DP-simplify - simplifies the model to a desired number of faces; automatically detects & supports textured models. Will create a new model with "-simp#K" appended to the filename, where "#" is the number of faces in thousands.
  -3DP-swapYZ - swaps the "up" axis, e.g. from Y to Z or vice versa. In reality the model is simply rotated by 90° about the X axis. Creates a new model with different metadata; the original is not changed.
  -mlx_scratch - a scratch file for development or writing your own scripts. Contains some sample code, including a silly script to generate Captain America's shield entirely in Meshlab vertex colored 2D surfaces.

You should ensure that models are "clean" (2-manifold, no holes, etc.) before running these scripts or they may not work.

#mlx.bsh (meshlabserver interface)

The mlx.bsh script contains functions to programmatically implement MeshLab filters via generation of MeshLab xml filter scripts (.mlx files). Thus, it is able to automate many of the tasks that you can perform in the MeshLab gui.

One particular use case is to take measurements of a mesh to input into OpenSCAD; it is used in just this way in the file modeling.bsh. 

## Usage
The best documentation at the moment is likely to just read the code, however here is a general overview of how to use the functions to write your own scripts.

First define the variable `ml_SF` with the filename of the script file you want to create, for example `temp.mlx`. WARNING: if this filename already exists it will be overwritten.

###Write the mlx script
Functions that begin with `mlx` actually write xml code to the `ml_SF` filename.

`mlx_begin` - must always be the first mlx function called. This writes the opening tags, and also adds `mlx_merge_V` for stl files (this is the same as selecting "Unify Duplicate Vertices" when importing STLs in tyhe gui).
`mlx_end` - must always be the last mlx function called; this writes the closing tag.

Here's a sample script to scale a model to half size and move 1 mm down in the Z axis:

```
ml_SF="temp.mlx"
mlx_begin
mlx_scale scale=.5
mlx_translate z=-1
mlx_end
```

###Run the script in meshlabserver
You have two options to run scripts, the `run_meshlab` function or just calling meshlabserver directly.

####run_meshlab
`run_meshlab` adds a few features and conveniences, such as the ability to silence meshlab's output, track its run time, and automatically determine file output options. The current downside is that not all meshlabserver features are currently supported, so if you need these features meshlabserver is your only option. To use `run_meshlab` you need to define the following variables first:

ml_IF = MeshLab input filename - required
ml_OF = MeshLab output filename - optional
ml_LF = MeshLab log filename - optional

There are several features which are currently NOT supported:
- Output file types other than those listed above. Note that most input file types should be fine.
- Output options that are not yet supported, such as vertex colors without textures.
- MeshLab project files
- Multiple input files
- Multiple output files

####meshlabserver
Here is a copy of meshlabserver's Usage:
```
meshlabserver [logargs] [args]
  where logargs can be:
    -d filename             dump on a text file a list of all the
                            filtering functions
    -l filename             log of the filters is output on a file
  where args can be:
    -p filename             meshlab project (.mlp) to be loaded
    -w filename [-v]        output meshlab project (.mlp) to be saved.
                            If -v flag is specified a 3D model meshfile.ext
                            contained in the input project will be overwritten,
                            otherwise it will be saved in the same directory of
                            input mesh as a new file called meshfile_out.ext.
                            All the mesh attributes will be exported in the
                            saved files
    -i filename             mesh that has to be loaded
    -o filename [-m <opt>]  the name of the file where to write the current mesh
                            of the MeshLab document.
                            If -m is specified  the specified mesh attributes will
                            be saved in the output file. the param <opt> can be a
                            space separated list of the following attributes:
                                vc -> vertex colors,  vf -> vertex flags,
                                vq -> vertex quality, vn-> vertex normals,
                                vt -> vertex texture coords,
                                fc -> face colors,  ff -> face flags,
                                fq -> face quality, fn-> face normals,
                                wc -> wedge colors, wn-> wedge normals,
                                wt -> wedge texture coords
    -s filename                   the script to be applied

   Examples:

    'meshlabserver -i input.obj -o output.ply -m vc fq wn -s meshclean.mlx'
           the script contained in file 'meshclean.mlx' will be applied to the
           mesh contained into 'input.obj'. The vertex coordinates and the
           per-vertex-color, the per-face-quality and the per-wedge-normal
           attributes will be saved into the output.ply file

    'meshlabserver -i input0.obj -i input1.ply -w outproj.mlp -v -s meshclean.mlx'
           the script file meshclean.mlx will be applied to the document
           composed by input0.obj and input1.ply meshes.
           The mesh input1.ply will become the current mesh of the document
           (e.g. the mesh to which the filters operating on a single model will
           be applied). A new output project outproj.mlp file will be generated
           (containing references to the input0.obj an input1.ply).
           The files input0.obj and input1.ply will be overwritten.

    'meshlabserver -l logfile.txt -p proj.mlp -i input.obj -w outproj.mlp -s meshclean.mlx'
           the mesh file input.obj will be added to the meshes referred by the
           loaded meshlab project file proj.mlp. The mesh input.obj will become
           the current mesh of the document, the script file meshclean.mlx will
           be applied to the meshes contained into the resulting document.
           the project file outproj.mlp will be generated
           A 3D model meshfile.ext contained in the input project proj.mlp will
           be saved in a new file called meshfile_out.ext
           (if you want to overwrite the original files use the -v flag after
           the outproject filename) all the attributes of the meshes will be
           saved into the output files; the log info will be saved into the
           file logfile.txt.

   Notes:
   There can be multiple meshes loaded and the order they are listed matters because
   filters that use meshes as parameters choose the mesh based on the order.
   The format of the output mesh is guessed by the used extension.
   Script is optional and must be in the xml format saved by MeshLab.
```

Additional notes on usage:
- The `-d` flag causes a seg fault with v1.3.4BETA
- You must supply an input file, even if you don't want one (i.e. you are creating a new mesh). No input file causes a seg fault with v1.3.4BETA. A workaround is to import a simple mesh such as `test_models/PLANE.obj` and run `mlx_del_layer` immediately after `mlx_begin`.
- `-w proj.mlp` will export all layers as separate mesh files in ply format; the layer labels are the filenames.
- You can specify multiple output filenames with multiple -o instances, however this will still be the same (current) layer. This is useful for outputting a layer in multiple file formats in the same command.


