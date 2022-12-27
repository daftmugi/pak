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

* `pak` is in the `bin/` directory.
* Use `pak` as is or copy it somewhere included in the `PATH`.
* **NOTE:** `pak` can be renamed to something else if desired.


## Usage

```
Usage: pak -l PAK_FILE [-m REGEX]        [-L]      [-v | -vv]
       pak -x PAK_FILE [-m REGEX] -d DIR [-L] [-n]
       pak -p PAK_FILE [-m REGEX]        [-L]
       pak -c PAK_FILE         -d DIR [-L] [-n] [-v | -vv]
       pak -D          [-m REGEX] [-e EXCLUDE_PAKS]

Commands:
    -l PAK_FILE    : list PAK archive files
    -x PAK_FILE    : extract PAK archive
    -p PAK_FILE    : extract PAK archive files to stdout (pipe)
    -c PAK_FILE    : create PAK archive
    -D             : read {pak0.pak,pak1.pak,...} and print duplicates
    -D help        : print more details about -D usage
    --help, -h     : print this message
    --version      : print version

Options:
    -m REGEX       : match file paths by a regular expression
    -d DIR         : create from/extract to directory
    -L             : convert filenames to lowercase
    -n             : no-op, dry-run
    -v             : verbose
    -vv            : verbose with extra info (very verbose)
    --debug        : more detailed error messages
```


## Usage: Find Duplicates

```
Usage: pak -D [-m REGEX] [-e EXCLUDE_PAKS]

-D
    Find duplicate file paths in pak archives, as Quake would load them.
    This is useful for finding conflicting files.

    Quake only reads pak files in sequential order. Given pak0.pak,
    pak1.pak, and pak3.pak, Quake only reads pak0.pak and pak1.pak.
    It skips pak3.pak, because there is no pak2.pak.


-m REGEX
    Match file paths by a regular expression
    For example:
        "-m 'bsp'" -> match names that include 'dds'
        "-m '.bsp$'" -> match names that end with '.dds'
        "-m 'maps/.*'" -> match path 'maps'


-e EXCLUDE_PAKS
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

      $ pak -D -e pak0
      maps/a.bsp: pak0.pak, pak1.pak
      maps/b.bsp: pak1.pak, pak2.pak
      maps/c.bsp: pak2.pak, pak3.pak

      $ pak -D -e pak0,pak1
      maps/b.bsp: pak1.pak, pak2.pak
      maps/c.bsp: pak2.pak, pak3.pak

      $ pak -D -e pak1,pak2
      maps/a.bsp: pak0.pak, pak1.pak
      maps/c.bsp: pak2.pak, pak3.pak

      $ pak -D -e pak0,pak1,pak2
      maps/c.bsp: pak2.pak, pak3.pak

      $ pak -D -e pak0,pak1,pak2,pak3
      <no output>
```
