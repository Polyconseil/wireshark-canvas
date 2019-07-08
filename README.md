CANvas-Wireshark plugin
=======================

This plugin is provided for free by CSS Electronics and is very useful
to decode CAN data in Wireshark as well as its live CAN mode for
reverse engineering.

You can find a complete description of its usages and advantages on
the [CSS Electronics
website](https://www.csselectronics.com/screen/page/can-interface-streaming-obd2-data-with-wireshark).
You will also be able to download on their website the [Windows
binaries and
sources](https://canlogger.csselectronics.com/downloads.php?q=wireshark).

Sadly they don't provide a Linux version, neither sources ready to
build. It's this lack that this repository try to fill. You will be
able to find here the Linux shared libraries ready to use with Wireshark
together with a script to help you rebuild Wireshark and the plugin if
you want or need to.


Plugin binaries
---------------

NOTE: Users of a recent Ubuntu release (such as 19.04) can skip this section 
and have to proceed to build from source, as the Ubuntu package repositories do 
no longer provide Wireshark-gtk in version 2.4 but only 2.6. 
Below build process was tested on Ubuntu 19.04 though and works. 

First a note of caution, this plugin only works with Wireshark-gtk (or
Wireshark-legacy in some distribution) version 2.4.X. So you first
need to be sure to have the right version of Wireshark installed on
your computer before to continue.

Depending of your distribution and how are managed the packages versions, you
may not be able to install the correct version of Wireshark from your
distribution repositories. In this case you may want to go to the next
section to build it yourself.

You will find a i386 (32bits) and a x86_64 (64bits) version of the
plugin in the `binaries/` folder. The plugin is only composed of the
`canvas.so` file, to use it you simply need to drop it in the plugin
folder of your Wireshark install. As a matter of example a typical
path is used but it may be in a different path in your computer.

Then you only need to restart Wireshark and if everything is fine you
should have a `CAN Live IDs` option in the Statistics menu.


Building the sources
--------------------

To build Wireshark and/or the CANvas plugin you will need to have the
common build tools installed on your system and the necessary
dependencies.
You will at least need packages like `libgtk2.0-dev`, `libglib2.0-dev`, `libtool-bin` and
`libtoolkit-perl` (depending of your distribution). If you want to be
sure to install all the dependencies that may be needed to build
Wireshark you can run (on a Debian-like OS) `apt build-dep wireshark`.


You will first need to execute the script
`prepare-wireshark-canvas-sources.sh` that will download all the
needed sources (Wireshark 2.4.14 and CANvas v7.1) and arrange them to
be ready to build Wireshark and/or CANvas plugin. Then you can build
with the usual commands:

```console
$ ./prepare-wireshark-canvas-sources.sh
$ cd wireshark-2.4.14/
$ ./autogen.sh
$ ./configure --with-gtk=2 --without-qt
$ make
```

It will build everything, Wireshark and all the plugins. You then only
need to run it to get Wireshark with your Canvas plugin inside:

```console
$ ./wireshark-gtk
```

If you only want to build the plugins and not the entire Wireshark
(it's a lot faster) you can do it with:

```console
$ make -C plugins
```


Streaming CAN from remote hosts
-------------------------------

If you have a Linux system connected to a CAN bus you may want to stream
the CAN data to your computer to confortably analyze it from your computer with Wireshark. One obvious method is to capture a log file and then load it on your computer but it takes time and means no live usage... Here I propose you 2 methods to stream the CAN bus on Wireshark like if your computer was directly connected to the CAN bus.

This first one only needs to have can-utils tools installed on the remote host. It will stream the content of the remote CAN bus to a local virtual CAN interface that you will then be able to use from Wireshark like any interface on your system:

```console
$ modprobe vcan
$ ip link add dev vcan0 type vcan
$ ssh W.X.Y.Z "candump -L can0" | canplayer vcan0=can0
```

The second one will need to have tcpdump installed on the remote host (you can find static binaries for multiple architectures on the Internet). It will stream the tcpdump content directly to your Wireshark:
```console
$ ssh W.X.Y.Z "tcpdump -i can0 -s0 -w -" | ./wireshark-gtk -k -i -
```
