# Installation

Installation is performed using ./configure, make and make install.

Extract the archive and configure with no options to install into `/usr/local`:

```
./configure \
  && make \
  && make check \
  && make install \
  && make installcheck
```

The `make check` target is optional but recommended - it will run the test suite.

Running the `installcheck` target is required to verify that the installation works as expected.

## Prefix

To install to a non-standard location use the `--prefix` option:

```
./configure --prefix=$HOME
```
