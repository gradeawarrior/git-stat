# git-stat

A collection of useful utilities and libraries for Ruby development (not Rails)

## Installation

The toolset can be installed via:

	gem install git-stat
	
## Usage

It's really quite simple! You execute `git-stat` inside a project, and it will print out a yaml with all the statistics. There is an option to pass it a git directory, that way you don't have to explicitly be in the directory to execute `git-stat`:

	Usage: git-stat [options]
	    -d, --dir GIT_DIR                A git directory to get stats on (Default: current directory)
    	-h, --help                       Display this screen
	
Executing the command on the local repo, will give you an output like this:

	$ git-stat
	---
	project_name: git-stat
	total_files: 13
	total_lines: 665
	file_types:
	  UNKNOWN: 6
	  .rb: 3
	  .gemspec: 1
	  .txt: 1
	  .lock: 1
	  .md: 1
	authors_line_count:
	  Peter Salas: 659
	  Not Committed Yet: 6
	line_counts_by_type:
	  .rb: 249
	  UNKNOWN: 171
	  .lock: 81
	  .md: 80
	  .gemspec: 64
	  .txt: 20
	branches:
	- remotes/origin/master
	tags:
	- v1.0.0
	
## Documentation

The projects homepage can be found [here](https://github.com/gradeawarrior/git-stat). You can also refer to the [Rubydoc YARD Server](http://rubydoc.info/gems/git-stat/frames)

# Development

The project is built by [jeweler](https://github.com/technicalpickles/jeweler). See the project's page for more details about how to manage this gem. However, I will list out quick guidance on a typical release.

## Active Gem Development

It may be useful to load this project for use in other local projects. The easiest way to configure Ruby is to set `RUBYLIB` environment variable to include all Ruby paths (Separated by colons ':'):

	$ export RUBYLIB=$YOUR_PATH_TO_LIB_DIRECTORY:$OTHER_PATHS

### 1. Version Bump

When you are ready to release, you will need to up-rev the version via the
following methods depending if it's (i) a major, (ii) a minor, or (iii) a patch
release:

    # version:write like before
    $ rake version:write MAJOR=0 MINOR=3 PATCH=0
    
    # bump just major, ie 0.1.0 -> 1.0.0
    $ rake version:bump:major
    
    # bump just minor, ie 0.1.0 -> 0.2.0
    $ rake version:bump:minor
    
    # bump just patch, ie 0.1.0 -> 0.1.1
    $ rake version:bump:patch

### 2. Local Testing of Gem

While doing active work on your project, it is helpful to actively install your gem into your local gem repo using `rake install` on the command-line.

	$ rake install

Do note that discovering what files to include in the gem is written around git. The file must be at least be tracked. You may need to do a `git init` and a `git add .` to at least satisfy the requirements for building a gem from source.

### 3. Releasing

At last, it's time to ship it! Make sure you have everything committed and pushed, then go wild:

	$ rake release

# Contributing to git-stat
 
* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet.
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it.
* Fork the project.
* Start a feature/bugfix branch.
* Commit and push until you are happy with your contribution.
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

# Copyright

Copyright (c) 2014 Peter Salas. See LICENSE.txt for
further details.

