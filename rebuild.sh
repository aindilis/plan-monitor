#!/bin/sh

clean-emacs-backups -r
make clean
mojo generate makefile
perl Makefile.PL
make test
make manifest
make dist
