Connect IQ app boilerplates
===========================

Instructions for a Debian-based
[Connect IQ](https://developer.garmin.com/connect-iq/)
[SDK](https://developer.garmin.com/connect-iq/sdk/)
installation, and Makefile-based basic apps.

Links
-----

- [programmer's guide](https://developer.garmin.com/connect-iq/programmers-guide/)
- [API](https://developer.garmin.com/connect-iq/api-docs/)

Prerequisites
-------------

### Environment

Set the following environment variable:
- `CONNECTIQ_SDK_HOME`: folder containing your Connect IQ SDK
  installation, especially:
  * a private `developer_key.der`
  * a `current` folder containing the SDK, including:
    - a `bin` folder containing `connectiq`, `monkeyc`, `monkeydo`, and
      other programs

### OpenSSL

    $ openssl genrsa -out ${CONNECTIQ_SDK_HOME}/developer_key.pem 4096
    $ openssl pkcs8 -topk8 -inform PEM -outform DER -in ${CONNECTIQ_SDK_HOME}/developer_key.pem -out ${CONNECTIQ_SDK_HOME}/developer_key.der -nocrypt

### SDK

For use without Eclipse, just download one of these:
- [3.0.12 / 2019-06-12 / 77ed6f47e](https://developer.garmin.com/downloads/connect-iq/sdks/connectiq-sdk-lin-3.0.12-2019-06-12-77ed6f47e.zip)
- [3.1.0.Beta3 / 2019-06-14 / bf21fff97](https://developer.garmin.com/downloads/connect-iq/beta/sdks/connectiq-sdk-lin-3.1.0.Beta3-2019-06-14-bf21fff97.zip)

### Libraries

`connectiq` depends on old libraries:
- `libwebkitgtk-1.0.so.0` and `libjavascriptcoregtk-1.0.so.0` are
  available in Debian `stretch` (`oldstable`):

      # cat stretch.list >> /etc/apt/sources.list.d/stretch.list
      # apt-get install libwebkitgtk-1.0-0
      # apt-get install libjavascriptcoregtk-1.0-0
- `libjpeg.so.8` can be built from the `libjpeg-turbo` sources,
  available in Debian `buster` (`stable`):

      # cat buster.list >> /etc/apt/sources.list.d/buster.list
      $ mkdir -p ${CONNECTIQ_SDK_HOME}/libjpeg-turbo
      $ cd ${CONNECTIQ_SDK_HOME}/libjpeg-turbo
      $ apt-get source libjpeg-turbo
      $ cd libjpeg-turbo-1.5.2
      # apt-get install debhelper nasm
      $ ./configure --with-jpeg8
      $ dh_auto_build
      $ cd .libs
      # install --mode=644 libjpeg.so.8 libjpeg.so.8.1.2 /usr/lib/x86_64-linux-gnu/

### JDK setup

The SDK will work out of the box with the JDK 8, which is required by
[Garmin's instructions](https://developer.garmin.com/connect-iq/programmers-guide/getting-started/),
and is available in Debian `stretch` (`oldstable`).

Actually, JDK 9 or JDK 10 (which are discontinued, and *not* in Debian
anymore) can be used instead, but the `monkeydo` program has to be
patched the following way:

    $ patch ${CONNECTIQ_SDK_HOME}/current/bin/monkeydo monkeydo.openjdk9.patch
or

    $ patch ${CONNECTIQ_SDK_HOME}/current/bin/monkeydo monkeydo.openjdk10.patch

There is no patch yet for JDK 11 (which is the current LTS version,
and is available in Debian `buster` (`stable`)).

### ANT+ usb stick

The following device:

    $ lsusb | grep ANT
    Bus 001 Device 036: ID 0fcf:1008 Dynastream Innovations, Inc. ANTUSB2 Stick
can be accessed thanks to the following `udev` rule:

    $ grep 1008 /etc/udev/rules.d/80.ant-usb-sticks.rules
    SUBSYSTEM=="usb", ATTR{idVendor}=="0fcf", ATTR{idProduct}=="1008", MODE="0664", GROUP="plugdev", SYMLINK+="ttyANT2", ACTION=="add"
if the user is in the `plugdev` group.

### Setup

`Makefile` contains default information that should be tweaked, such as
`udev_id`, `device_id` and `sources`.

Commands
--------

- (compile and) run

      $ make run

- (compile and) deploy

      $ make mount
      $ make deploy
      $ make umount

- view logs

      $ make mount
      $ make logs
      $ make umount

Layout
------

- bin: compiled program and compilation output
- resources
- source
- manifest.xml
- monkey.jungle
