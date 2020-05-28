#!/bin/sh

clean-emacs-backups -r
rm Makefile.PL
rm Makefile
mojo generate makefile
perl Makefile.PL
make test
make manifest
make dist
