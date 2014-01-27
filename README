simplecct: simple scripts that can be used to build a gcc-based
 cross-compilation toolchain

== INSTALL
You have nothing to build or to install here - unless you are missing
some crucial dependencies

* quilt (used to apply patches if needed)
* make
* gcc

These should be on your system - if quilt is not installed on your
system, I stringly suggest you to install it and to git it a try.

== HOW TO USE

* Create a user-config.sh file in the current directory.
* Start ./build-toolchain.sh
* Wait for some time (from 30 minutes to much more if your machine is
  a bit slow)
* And voilà !

== COMMAND LINE OPTIONS

The build-toolchain.sh script allows you to specify a few options

* help: show the usage screen
* config=XXX: make user-config.sh a link to one of the config from
  the configs/ directory. You can find the list of available configs
  by using <<./build-toolchain.sh help>>.
* clean: remove all built artefacts.

There are many more options that are used to skip some particular steps
if needed.

You can also start any script (but config.sh). For example, calling
00-tc-download.sh will download all the required files to build the
toolchain.

== CREATING YOUR OWN CONFIGURATION

All the proposed configurations in configs/ are redefining all the
variables used during the build so it should be straightforward to
set-up a specific configuration to build your own toolchain.

== SUPPORTED C STANDARD LIBRARIES

For the first release, only the musl C library is supported. I plan to
add more in the future (uClibc, eglibc, glibc...)

== SUPPORTED LANGUAGES

As of today, the toolchain builds both a C and a C++ compile. I may add
more supported languages in the future (including Go, Java, ObjC)
although this is clearly not a priority for me.

== KNOWN BUGS

* I had to revert a change that would have allowed you to spawn
  multiple processes to build the toolchain (that dramatically reduce
  the build time on a multicore machine). However, each and every build
  I made in this mode broke badly.

* I tested only a few number of (ARMv7-based) configurations. There
  might be issued on other architectures.

* Of course, there are probably many bugs I'm not aware of. The shell
  code, while not optimal, is clear enough to enable you to spot an
  error.