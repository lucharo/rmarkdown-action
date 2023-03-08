#!/bin/sh -l

echo "Thanks for using this GH action!"
input_file=$1
output_format=$2

ln -s /render.R .

Rscript render.R $input_file $output_format
