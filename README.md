# PAK.rb

**PAK.rb** is a command-line PAK packer/unpacker for Quake.


## Features

* Commands
    - List PAK archive files.
    - Extract PAK archive files.
    - Extract PAK archive files to stdout; pipe files.
    - Create PAK archive.
    - Find duplicate file paths in PAK archives.
* All commands support converting files to lowercase filenames.
* All commands, except create, support regular expression filtering.
* Extract and create commands have a no-op/dry-run mode.
* List and create commands have verbose and very verbose modes.


## Requirements

* Ruby 3.0+
* Tested on Linux
* Not tested on Windows


## Installation

* Use `pak` as is or copy it somewhere included in the `PATH`.
* **NOTE:** `pak` can be renamed to something else if desired.


## Usage

```
Usage: pak -l PAK_FILE [REGEX]        [-L]      [-v | -vv]
       pak -x PAK_FILE [REGEX] -d DIR [-L] [-n]
       pak -p PAK_FILE [REGEX]        [-L]
       pak -c PAK_FILE         -d DIR [-L] [-n] [-v | -vv]
       pak -D [EXCLUDE_PAKS]

Commands:
    -l PAK_FILE   : list PAK archive files
    -x PAK_FILE   : extract PAK archive
    -p PAK_FILE   : extract PAK archive files to stdout (pipe)
    -c PAK_FILE   : create PAK archive
    -D            : read {pak0.pak,pak1.pak,...} and print duplicates
    -D help       : print more details about -D usage
    --help, -h    : print this message
    --version     : print version

Options:
    REGEX         : filter files by a regular expression
    EXCLUDE_PAKS  : comma-separated pak set 'pak0,pak1,...' to exclude
    -d DIR        : create from/extract to directory
    -L            : convert filenames to lowercase
    -n            : no-op, dry-run
    -v            : verbose
    -vv           : verbose with extra info (very verbose)
    --debug       : print more detailed error messages
```


## Usage: Find Duplicates

```
Usage: pak -D [EXCLUDE_PAKS]

-D
    Finds duplicate file paths in pak archives, as Quake would load them.
    This is useful for finding conflicting files.

    Quake only reads pak files in sequential order. Given pak0.pak,
    pak1.pak, and pak3.pak, Quake only reads pak0.pak and pak1.pak.
    It skips pak3.pak, because there is no pak2.pak.


EXCLUDE_PAKS
    Comma-separated set of paks to exclude, in the form 'pak0,pak1,...'.
    The paks in the set do not need to include the '.pak' extension.

    A duplicate file prints only if there is at least one pak not
    included in the EXCLUDE_PAKS set.

    Examples:
      pak0.pak -> maps/a.bsp
      pak1.pak -> maps/a.bsp
      pak1.pak -> maps/b.bsp
      pak2.pak -> maps/b.bsp
      pak2.pak -> maps/c.bsp
      pak3.pak -> maps/c.bsp

      $ pak -D
      maps/a.bsp: pak0.pak, pak1.pak
      maps/b.bsp: pak1.pak, pak2.pak
      maps/c.bsp: pak2.pak, pak3.pak

      $ pak -D pak0
      maps/a.bsp: pak0.pak, pak1.pak
      maps/b.bsp: pak1.pak, pak2.pak
      maps/c.bsp: pak2.pak, pak3.pak

      $ pak -D pak0,pak1
      maps/b.bsp: pak1.pak, pak2.pak
      maps/c.bsp: pak2.pak, pak3.pak

      $ pak -D pak1,pak2
      maps/a.bsp: pak0.pak, pak1.pak
      maps/c.bsp: pak2.pak, pak3.pak

      $ pak -D pak0,pak1,pak2
      maps/c.bsp: pak2.pak, pak3.pak

      $ pak -D pak0,pak1,pak2,pak3
      <no output>
```
