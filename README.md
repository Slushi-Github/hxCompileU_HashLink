# PLEASE DON'T USE THIS PROJECT, IT IS USELESS AND IT WAS JUST AN EXPERIMENT. 
Use [HxCompileU](https://github.com/Slushi-Github/hxCompileU) instead as this project was based on it in the first place.

---------------------------------------------------------------------

# HxCompileU (HashLink version)

### CURRENTLY THIS PROJECT IS NOT FULLY FUNCTIONAL, AND YOU MUST USE LINUX TO USE IT (Maybe WSL is also useful?).

![mainImage](https://github.com/Slushi-Github/hxCompileU_HashLink/blob/main/docs/readme/MainImage.png)

Using this small utility you can compile code from Haxe to PowerPC and finally the Nintendo Wii U using DevKitPro and [HashLink](https://github.com/HaxeFoundation/hashlink).

## How?
In this project, it is made to work with a Lime project, for example a simple HaxeFlixel project like [FlxSnake](https://haxeflixel.com/demos/FlxSnake), first you compile the normal Lime project to [HashLink](https://github.com/HaxeFoundation/hashlink), in conjunction with the ``-hlc`` argument to get the HashLink/C, or HLC for short. With the C code ready, you use a MakeFile prepared to try to compile this project using the DevKitPro utilities to bring it to the Nintendo WIi U.

Clearly the basis of this project is the original project, [HxCompileU](https://github.com/Slushi-Github/hxCompileU), which uses [reflaxe.CPP](https://github.com/SomeRanDev/reflaxe.CPP) as an alternative to HXCPP.

However, this project is currently useless, on the side of compiling to the console, because I need the HashLink library (``libhl``) compiled for PowerPC and in static version (by default for Linux is a dynamic library, which DevKitPro apparently does not support).

This project is even more unstable than the original project itself, [HxCompileU.](https://github.com/Slushi-Github/hxCompileU)


## Why?
Read [this.](https://github.com/Slushi-Github/hxCompileU?tab=readme-ov-file#why)

## Usage
You need [DevKitPro](https://devkitpro.org/wiki/Getting_Started), in addition to DevKitPPC and [WUT](https://github.com/devkitPro/wut), and PPC version of libpng and SDL2 for the Wii U.

First, you need compilate this project, 

```bash
# Just clone the repository
git clone https://github.com/Slushi-Github/hxCompileU_HashLink.git

# Compile the project
cd hxCompileU_HashLink
haxe build.hxml
```

After that, you will get your executable “haxeCompileU” in the ``export`` folder, for the moment, copy it to the root of the project you need it.

#### First, initialize your project, that is, create the configuration JSON file that HxCompileU_HashLink will use, you can create it using this command:
``{haxeCompileUHLProgram} --prepare``

#### Once you have configured your JSON file to what your project needs, you can use the following command to compile it:
``{haxeCompileUHLProgram} --compile``

If you want to compile only Haxe but not to Wii U, you can use the following command:
``{haxeCompileUHLProgram} --compile --haxeOnly``

and that's it! if your compilation was successful on both Haxe and Wii U side, your ``.rpx`` and ``.elf`` will be in ``yourOuputFolder/wiiuFiles``.
