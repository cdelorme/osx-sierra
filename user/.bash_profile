#!/bin/bash
# if the terminal has stdin (eg. is interactive) and ~/.bashrc exists then load it
test -t 0 && [ -f ~/.bashrc ] && . ~/.bashrc
