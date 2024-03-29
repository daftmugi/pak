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

* [Ruby 3.0+](https://www.ruby-lang.org/en/downloads/)
* Linux
    - Ubuntu: `apt install ruby`
* Windows
    - [RubyInstaller](https://rubyinstaller.org/downloads/) 3.0 builds are known to work.
        + [Ruby+Devkit 3.0.6-1 (x64)](https://github.com/oneclick/rubyinstaller2/releases/download/RubyInstaller-3.0.6-1/rubyinstaller-devkit-3.0.6-1-x64.exe)
        + [Ruby 3.0.6-1 (x64)](https://github.com/oneclick/rubyinstaller2/releases/download/RubyInstaller-3.0.6-1/rubyinstaller-3.0.6-1-x64.exe)
    - "MSYS2 development toolchain" is not required.
    - "ridk install" is not required.
    - **NOTE:** As of this writing, RubyInstaller 3.1 and 3.2 builds are not compatible,
      since the program may not run due to an error with the message
      ["unexpected ucrtbase.dll"](https://github.com/oneclick/rubyinstaller2/issues/308).


## Installation

* `pak` is in the `bin/` directory.
* Use `pak` as is or copy it somewhere included in the `PATH`.
* **NOTE:** `pak` can be renamed to something else if desired.
* **NOTE:** Windows users may need to prepend `ruby` to `pak` to
  run it. For example, `ruby pak`.


## Usage

```
Usage: pak -l PAK_FILE [-m REGEX]        [-L]      [-v | -vv]
       pak -x PAK_FILE [-m REGEX] -d DIR [-L] [-n]
       pak -p PAK_FILE [-m REGEX]        [-L]
       pak -c PAK_FILE            -d DIR [-L] [-n] [-v | -vv]
       pak -D [PATHS]  [-m REGEX] [--checksum] [-e EXCLUDE_PAKS]

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
Usage: pak -D [PATHS] [-m REGEX] [--checksum] [-e EXCLUDE_PAKS]

-D [PATHS]
    Find duplicate file paths in pak archives, as Quake would load them.
    This is useful for finding conflicting files.

    Quake only reads pak files in sequential order. Given pak0.pak,
    pak1.pak, and pak3.pak, Quake only reads pak0.pak and pak1.pak.
    It skips pak3.pak, because there is no pak2.pak. The files in
    the last loaded pak have priority over earlier loaded paks.

    PATHS
        Comma-separated list of paths to search for '.pak' files.
        When PATHS is omitted, the current directory is searched for '.pak' files.
        The load priority of the list is highest (left) to lowest (right).
        For example:
            "-D" -> search current directory './'
            "-D mod1" -> from current directory, search './mod1'
            "-D mod1,mod2,mod3" -> search './mod1', './mod2', './mod3'
            "-D mod1,mod2,." -> search './mod1', './mod2', './'
              NOTE: './' is the current directory.


-m REGEX
    Match file paths by a regular expression
    For example:
        "-m 'bsp'" -> match names that include 'bsp'
        "-m '\.bsp$'" -> match names that end with '.bsp'
        "-m 'maps/.*'" -> match path 'maps'


--checksum
    Use CRC32 checksum-based file matching.
    When a file path matches, duplicates are determined by their checksums.

    Output Column Labels:

        Type          File Path  List of Matching PAK Files
    ------------  -------------  ----------------------------
    [identical]     maps/a.bsp:  mod1/pak3.pak, mod4/pak0.pak
    [identical]     maps/b.bsp:  mod1/pak2.pak, mod2/pak1.pak


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
      maps/c.bsp: pak3.pak, pak2.pak
      maps/b.bsp: pak2.pak, pak1.pak
      maps/a.bsp: pak1.pak, pak0.pak

      $ pak -D -e pak0
      maps/c.bsp: pak3.pak, pak2.pak
      maps/b.bsp: pak2.pak, pak1.pak
      maps/a.bsp: pak1.pak, pak0.pak

      $ pak -D -e pak0,pak1
      maps/c.bsp: pak3.pak, pak2.pak
      maps/b.bsp: pak2.pak, pak1.pak

      $ pak -D -e pak1,pak2
      maps/c.bsp: pak3.pak, pak2.pak
      maps/a.bsp: pak1.pak, pak0.pak

      $ pak -D -e pak0,pak1,pak2
      maps/c.bsp: pak3.pak, pak2.pak

      $ pak -D -e pak0,pak1,pak2,pak3
      <no output>
```
