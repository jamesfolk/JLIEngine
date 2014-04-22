#!/bin/bash

cd ..
find `pwd` -type f -name *.h > bin/log/engine_files.log
perl bin/perl/replace.pl bin/log/engine_files.log


