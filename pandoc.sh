#!/bin/bash

incoming="$1"
outgoing="${incoming%.*}.markdown"
pandoc -f html -t markdown_github -o $outgoing $incoming
