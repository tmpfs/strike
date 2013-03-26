# Installation

Installation is performed using `./configure`, `make` and `make install`.

Configure with no options to install into `/usr/local`:

```
./configure \
  && make \
  && make check \
  && make install \
  && make installcheck
```

At the end of the install target, `boilerplate.sh` is installed into PATH, if it already exists it is overwritten otherwise you will be presented with an interactive prompt to select where to install the file.

The `make check` target is optional but recommended - it will run the test suite.

Running the `installcheck` target is required to verify that the installation works as expected.

## Prefix

To install to a non-standard location use the `--prefix` option:

```
./configure --prefix=$HOME
```
