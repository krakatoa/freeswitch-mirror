freeswitch-mirror
=================

An easy to spin-up Freeswitch (Debian wheezy packages) mirror.

## How to use

    $ vagrant up

Check the IP associated to the new VM (for this example I will use 192.168.1.100).
Then in the host where you are going to install Freeswitch:

    $ echo 'deb http://192.168.1.100/ wheezy main' >> /etc/apt/sources.list.d/freeswitch.list
    $ curl http://files.freeswitch.org/repo/deb/debian/freeswitch_archive_g0.pub | apt-key add -
    $ apt-get update

You can now install Freeswitch packages:

    $ apt-get install freeswitch-meta-vanilla
