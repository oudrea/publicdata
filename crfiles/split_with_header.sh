#!/bin/bash

header=$(head -1 $1)
tail -n +2 $1 >output.data
split -l $2 output.data rel_part
for part in `ls -1 rel_part*`
do
   printf "%s\n%s" "$header$" "`cat $part`" >"${part}.csv"
   rm -rf $part
done
rm -rf output.data
