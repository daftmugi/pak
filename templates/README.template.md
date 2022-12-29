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

`USAGE_BLOCK`


## Usage: Find Duplicates

`FIND_DUPLICATES_USAGE_BLOCK`
