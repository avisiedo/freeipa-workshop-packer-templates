# Freeipa Workshop Packer

This repository just store templates to build the vagrant images used at
freeipa-workshop.

This document will guide you to prepare your environment for building and
publishing the images for different distributions.

## Preparing the environment

This basically consist on installing the needed packages to fix all the
dependencies.

To make life easier a script has been created, so we only have to run the
below:

```shell
./helper.sh install-dependencies
```

And now you need to create the `credentials.env` file by:

```shell
cp credentials.env.example credentials.env
```

Finally edit `credentials.env` and modify the values at your convenience.

## Preparing the upload

1. Go to [vagrant cloud site](https://app.vagrantup.com/) and login.

1. Do click on **[Create a New Vagrant Box](https://app.vagrantup.com/boxes/new)**,
   if it were not already created.

1. Append a new box version (start with 1.0.0).

1. Finally copy the version string to your `credentials.env` file, so it is
   passed on packer when it is launched.

## Running the process on Fedora 32

For building and publish the Fedora 32 image, you will need to do:

```shell
./helper.sh build fedora/32
```

## Final notes

* The system doesn't allow to push to a current version or revoked version
  of the VM even passing the argument `-force`, so everytime you need to update
  the VM you will need to create a new version for the VM.
* To run the process viewing the VM interface, change `"headless"` to
  `"false"` in the `template.json` file.
* I found issues using **virtualbox-iso** provider, so I decided to force
  the `qemu` provider so far.
* No other providers have been tested yet but `qemu` and `virtualbox-iso`.

## References

The work on this repository have been possible to Fraser Tweedal and the effort
of the community on several repositories which I have used as inspiration for
the work on this one:

* [kaorimatz/packer-templates](https://github.com/kaorimatz/packer-templates).
* [mrlesmithjr/packer-templates](https://github.com/mrlesmithjr/packer-templates).
* [Packer Documentation](https://www.packer.io/docs).
