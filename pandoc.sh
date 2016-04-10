#!/bin/bash
pandoc -f html -t markdown_github -o "$1".markdown master_file.html
