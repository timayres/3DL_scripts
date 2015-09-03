
#3DP Scripts
Bash shell script library for [MeshLab](http://meshlab.sourceforge.net/) scripting; small apps to help prepare 3D mesh models for 3D printing

###About
This project consists of two main parts:

1. For programmers, an improved interface to generate and run meshlabserver xml filter scripts. No more exporting and hand editing .mlx files, now these can be generated straight from the command line! There are also several functions to measure various properties of the mesh (size, volume, center of mass, barycenter),take a dimensional measurement, take a cross section, and more.

2. For end users, a number of small interactive apps (the 3DP apps) to perform helpful tasks on 3D unstructured triangular meshes, such as scaling, converting, and hollowing. These apps are command line based and are intended to be run by dragging and dropping a 3D mesh model onto the app. These apps make extensive use of part 1.

This project is written primarily in [Bash](https://en.wikipedia.org/wiki/Bash_%28Unix_shell%29), the Unix shell scripting language, however it also (in fact, primarily) runs on Windows via Cygwin. These scripts use various other programs to do most of the heavy lifting.

###Status
This code should be considered ALPHA quality at best. Interfaces and usage may change at any time, many planned features have not yet been implemented, some features have had little or no testing, any many bugs are surely waiting to be found. You have been warned! Still, even in its current state many features work well and reliably, so give it a shot!

##3DP Apps
Small (generally) single purpose scripts to help prepare 3D models (especially 3D scans with color textures) for 3D printing. Run by dragging & dropping the 3D model onto the script.

###Metadata
In order to automate some tasks the 3DP apps need to know additional metadata about the model; this includes the model's scale ratio and "up" axis. This metadata is added to the end of the file name before the extension; it consists of a number and a letter enclosed in parentheses, such as "model(-10Y).obj" or "model(1Z).stl".

When you use the 3DP apps they will prompt you for this metadata if it is needed but is not found; it is added to all output files automatically. You can also easily add it to your files with the 3DP_rename app.

- Scale Ratio: Particularly for 3D scans of real world subjects it is important to know how the size of the 3D model relates to reality. This number indicates the scale ratio of the model; this can be positive or negative, integer or float.
  - Positive numbers greater than 1 indicate that the model is scaled up, e.g. "2" indicates the model is twice its original size.
  - "1" indicates the model is original size (no scaling).
  - Positive decimal numbers indicate that the model is scaled down, e.g. ".1" indicates that the model is one tenth (or 10%) its original size.
  - Negative numbers indicate an inverse scale ratio, for example "-10" indicates that the model is at 1:10 (or 1/10) scale, which is also equivalent to ".1".
- Up axis: an annoying fact of the 3D software world is that no one can agree on which way is up. Valid values are "Y" and "Z". Generally speaking, 3D modeling programs assume "Y" is up and 3D printing programs assume "Z" is up, however there are exceptions, and some software (such as Blender and Shapeways) assume a different orientation based on the file type.
  
###Units
Model units are assumed to be in mm. This is true even if the file type specifies the units (such as x3d files, which are defined to be in meters). These units are reflected in the output of all measurements (length, area & volume), although in practice all operations are unitless.

###Supported file types
The following two file types and options are primarily supported:

- [obj](https://en.wikipedia.org/wiki/Wavefront_.obj_file) - for models with color texture data (UV mapping). Obj is a nice format, easily human readable, and enjoys widespread support (second only to stl).
- [stl](https://en.wikipedia.org/wiki/STL_%28file_format%29) - for geometry data only (no color). Stl has the widest support. Note that there are some color extensions to stl, however these are not widely supported and we do not attempt to support them either. If you want color IMO you're better off using a better format.
  
Additional formats supported in some way:

- [x3d](https://en.wikipedia.org/wiki/X3D) - supports color textures, primarily used to submit models to Shapeways.
- xyz - a simple format containing just a list of xyz vertices (a point cloud).
- [dxf](https://en.wikipedia.org/wiki/AutoCAD_DXF) - primarily a 2D format, used here to export 2D planar sections.
  
Support for additional model types ([ply](https://en.wikipedia.org/wiki/PLY_%28file_format%29), [dae](https://en.wikipedia.org/wiki/COLLADA), etc.) is planned for the future, however only formats supported by MeshLab can be added. Note that based on the app additional input file types may work, but have not been tested.

Vertex colors are not currently explicitly supported. They may work fine, however no testing has been done. Explicit support is planned for the future.

### Installation & Dependencies
####Windows
Download the repository and put it wherever you like.

You will need to manually install the required dependencies; if you install them in a location different than described below you will need to edit the file "3DP-main.bsh" with the new locations.
- [MeshLab](http://meshlab.sourceforge.net/) version 1.34BETA, C:/Program Files/VCG/MeshLab
- [ADMesh](https://github.com/admesh/admesh) version 0.98.2, C:/Program Files/admesh
- [OpenSCAD](http://www.openscad.org/) version 2015.03, C:/Program Files/OpenSCAD
- [Cygwin](https://www.cygwin.com/), C:/cygwin64 (if different this location needs to be changed in 3DP-generate_apps.bsh, 3DP-generate_apps.cmd & 3DP-remove_apps.cmd)
  
__Note that version 1.3.4BETA for 64 bit Windows is required.__ Older versions will mostly work but are missing some key features. Most notably, the measure geometry & measure topology filters do not work from meshlabserver in older versions (including 1.3.3), so any apps that depend on these will not work.
  
After installing Cygwin, you can run the file `bash/3DP-cyg-install.bsh` to automatically install additional dependencies within Cygwin. Note that this uses [apt-cyg](https://github.com/transcode-open/apt-cyg) to install additional programs.

To generate the app shortcuts, double click on `bash/3DP-generate_apps.cmd`. This will generate cmd files in the top directory suitable for dragging & dropping models on.

####Linux
Linux is kinda sorta supported; I've actually given up on fully supporting Linux at the moment since it's just too hard to get the latest versions of software installed. For example, as of this writing (August 2015) the latest version of Meshlab packaged with Ubuntu (15.04) is 1.3.2, released over 3 years ago. There's a PPA for 1.3.3 but it's missing features. As noted above, MeshLab version 1.3.4BETA is needed for full support, however this was never released for Linux (even in source form), so what's needed is to compile a later version from SVN (but not TOO late or you'll encounter breakage). 

In any case, after installing all dependencies run `bash/3DP-generate_apps.bsh` script to generate .desktop shortcuts that you can drag & drop models onto. If you can get a later version of MeshLab compiled it should work, or you can live with the reduced functionality of older versions.

####OS X
OS X should work with a bit of work, again provided you can get an updated copy of MeshLab compiled & installed. However, I don't own a Mac and am unsure how to create files to support dragging & dropping, so you're on your own at the moment. Contributions welcome!

### App Brief Descriptions & Usage
Apps are run by dragging & dropping a 3D mesh model on the script file.

All apps are designed to be non-destructive; they will create new files but will not overwrite the original. However, things happen, and this is not a replacement for proper backups! Note that 3DP-2stl is an exception to this; if you drag an stl on this app it will re-save it as a binary stl.

You should ensure that models are "clean" (manifold, no holes, etc.) before running these scripts or they may not work.

##### Conversions - convert model to a different type
- _3DP-2objNC_ - this will drop all color info from an obj file. Creates a new file with "NC" (for "no color") added to the end of the filename; the original is not changed. 'Cause sometimes you just want to deal with the geometry! Should work on any (mesh) input file MeshLab supports.
- _3DP_2objz_ - this will take your obj file, find any associated .mtl material file and texture files and wrap them all together in a zip file. Useful for transferring the complete model (with color data) to another location or uploading to a 3D printing service (e.g. Sculpteo). Currently only works on obj files (it will not convert other formats).
- _3DP-2stl_ will convert input mesh (will re-save stls) to a Z up binary stl and run it through ADMesh for a check (note that ADMesh will not try to fix any problems found since this can fail on some models). Should work on any mesh input file MeshLab supports.
- _3DP-2x3dz_ - this will convert your model to x3d format, find any associated texture files, wrap them all together in a zip file, and delete the x3d file. Primarily intended for submitting models to Shapeways. Should work on any (mesh) input file MeshLab supports. _NOTE: I've had issues with the x3d format for some models, so this is planned to be replaced with 2daez in the not too distant future._

##### Miscellaneous - scripts to perform helpful actions on 3D models to prepare them for 3D printing.
- _3DP-rename_ - renames the model and any associated secondary files (e.g. materials & textures), which are tedious to rename on their own. You can also keep the current name and use this to just add metadata. App creates new files with the new name, but does not delete the originals. Contains some special rules for handling models produced by itSeez3D.
- _3DP-scale_ - will scale the model to a different scale ratio. Note that this scales the model based on the new scale ratio, not based on the current model size. For example, if you have a model at 1:10 and you want to make it twice as big, you would enter "-5" (to convert to 1:5 scale), not "2". Creates a new model with different metadata; the original is not changed.
- _3DP-simplify_ - simplifies the model to a desired number of faces; automatically detects & supports textured models. Will create a new model with "-simp#K" appended to the filename, where "#" is the number of faces in thousands.
- _3DP-swapYZ_ - swaps the "up" axis, e.g. from Y to Z or vice versa. In actuality the model is rotated by 90° about the X axis. Creates a new model with different metadata.
- _3DP-check_mesh_ - currently just measures geometry & topology of mesh. _Will be changed in the future._
- _3DP-pricing_ - calculates prices in full color gypsum stone material for various 3D printing services; currently supports Shapeways & i.Materialize. More services could be added if they publish their pricing formula (Sculpteo, for example, doesn't).
- _mlx_scratch_ - a scratch file for development or writing your own scripts. Contains some sample code, including a silly script to generate Captain America's shield entirely in Meshlab vertex colored 2D surfaces.

##### Modeling - scripts to substantially modify the source model's geometry
- _3DP-hollow_ - a rather complicated script to hollow models for binder jetting (powder based) 3D printing, e.g. full color stone. A work in progress; expect significant changes in the future. Note that this currently doesn't actually hollow the model; instead it will create the interior "negative volume". You will still need to import the original model into Blender & perform a boolean difference with the negative volume to actually create a hollow model. This app can currently hollow out the bottom of prints, create half-bust magnets, and bobbleheads (just the head). The model must be properly oriented before running the app.
- _3DP-half_bust_FFF_ - creates a half bust magnet & wall hanger suitable for FFF printers.
- _3DP-platform_FFF_ - takes an input mesh and puts it on a 3mm high round platform. Primarily intended for standing full length figures, but will work on anything. Does not support textures (uses MeshLab's flatten layers filter).

##mlx.bsh  - MeshLab filter script generation

The mlx.bsh script contains functions to programmatically run MeshLab filters via generation of MeshLab xml filter scripts (.mlx files). Thus, it is able to automate many of the tasks that you can perform in the MeshLab gui.

One particular use case is to take measurements of a mesh to input into OpenSCAD; it is used in just this way in the script modeling.bsh (contains the hollowing functions).

### Usage
Here is a general overview of how to use the functions to write your own scripts. You can also examine the 3DP app functions for practical examples.

First define the variable `ml_SF` with the filename of the script file you want to create, for example `temp.mlx`. WARNING: if this filename already exists it will be overwritten.

####Write the mlx script
Functions that begin with `mlx` actually write xml code to the `ml_SF` filename.

`mlx_begin` - must always be the first mlx function called. This writes the opening tags, and also adds `mlx_merge_V` for stl files (this is the same as selecting "Unify Duplicate Vertices" when importing STLs in the gui).

`mlx_end` - must always be the last mlx function called; this writes the closing tag.

Here's a sample script to scale a model to half size and move 1 mm down in the Z axis:

```
ml_SF="temp.mlx"
mlx_begin
mlx_scale scale=.5
mlx_translate z=-1
mlx_end
```

####Filters
Not all MeshLab filters have been implemented yet, however a useful subset has. It's reasonably straightforward to add additional filters, so it you need something extra please send a request! Currently the best documentation on implemented filters and their usage is the code itself.

mlx.bsh uses a few abbreviations to shorten names for common terms:
- V = vertex, vertexes, vertices
- E = edge, edges
- F = face, faces, facets
- sel = select, selected
- del = delete, deleted
- parts = same as "components" in MeshLab (but fewer letters ;); some other programs call these "shells". These are any separate, unconnected geometries in the mesh.
- layer = MeshLab uses "layer" and "mesh" somewhat interchangeably. This isn't entirely correct, as a layer could contain something other than a mesh (e.g. a point cloud), so the more general term is used.

MeshLab likes to give filters long and highly technical names; while accurate, this can be confusing for newcomers (and some oldtimers ;), and is a bit much to type out in scripts. Therefore, some filters have been renamed to give them shorter (and hopefully clearer) names. For example, filter "Quadric Edge Collapse Decimation" is called with the function `mlx_simplify`.

Additional filter combinations are also included for convenience. For example, `mlx_del_small_parts` combines `mlx_sel_small_parts` with `mlx_del_sel_V_F`. 

Some filters have additional features added or a different interface defined. For example, `mlx_simplify` will run a different version of the filter depending if the model has a UV texture. The mesh creation filters have been changed extensively to give them more of an OpenSCAD-like interface.

All filter options are specified when calling the filter using the pattern `option=value`. Read the code to see specifics. All options that are available can be specified unless they serve no purpose in a script (such as the rotation snap angle). All options have default values so it is not required to specify any options at all (although for some filters such as the transformations a call with no options won't actually do anything). Please note that the default values are those we've found to be the most useful and may differ from MeshLab's defaults. Check first!

####Run the script in meshlabserver
You have two primary options to run mlx scripts, the `run_meshlab` function or just calling meshlabserver directly. A third option is to load and run the scripts in the GUI, which can be especially useful for debugging.

#####run_meshlab
`run_meshlab` adds a few features and conveniences, such as the ability to silence meshlab's output, track its run time, and automatically determine file output options. The  downside is that not all meshlabserver features are currently supported, so if you need these features meshlabserver is your only option. To use `run_meshlab` you need to define the following variables first:

- `ml_IF` = MeshLab input filename - required (see note below)
- `ml_OF` = MeshLab output filename - optional
- `ml_LF` = MeshLab log filename - optional

There are several features which are currently NOT supported:
- Output file types other than those listed above. Note that most input file types should be fine.
- Output options that are not yet supported, such as vertex colors without textures.
- MeshLab project files.
- Multiple input files.
- Multiple output files.

#####meshlabserver
meshlabserver's usage can be viewed by running `meshlabserver` with no options.

Additional notes on usage:
- The `-d` flag causes a seg fault with v1.3.4BETA
- You must supply an input file, even if you don't want one (i.e. you are creating a new mesh). No input file causes a seg fault with v1.3.4BETA. A workaround is to import a simple mesh such as `test_models/PLANE.obj` and run `mlx_del_layer` immediately after `mlx_begin`.
- `-w proj.mlp` will export all layers as separate mesh files; the layer labels are the filenames. For non-imported meshes the default export format is ply.
- You can specify multiple output filenames with multiple -o instances, however this will still be the same (current) layer. This is useful for outputting a layer in multiple file formats in the same command.

### Other Useful Functions

There are other functions included that may be useful for general scripting, such as those found in `measure.bsh`.

##Licensing
The original code in this repository is released under the LGPLv2.1. This means that you are free to use them as you please, and even use the various scripts and functions (such as mlx.bsh) in your own programs and scripts without being required to share your code (but it would be nice). However, if you make any changes or improvements to the scripts and functions included here you need to share those changes back. Fair enough?

mlx_scratch.bsh is an example & testing script & is released into the public domain.

Models in the test_models directory are licensed under the Creative Commons Attribution-ShareAlike 4.0 International License. To view a copy of this license, visit http://creativecommons.org/licenses/by-sa/4.0/ or send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.

Additional software that is include in this repository that we didn't write, but am extremely grateful for!

- funcs.bc
  - Source: http://phodd.net/gnu-bc/
  - License: unspecified, but it is certainly freely available
