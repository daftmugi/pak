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

`USAGE_BLOCK`


## Usage: Find Duplicates

`FIND_DUPLICATES_USAGE_BLOCK`
