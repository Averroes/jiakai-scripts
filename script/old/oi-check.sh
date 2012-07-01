#!/bin/bash -e
prog=x
ans=`echo $1 | sed -e 's/in/out/g'`
if [[ (! -r $1)  || $1 == $ans  || (! -r $ans) ]]
then
	echo "Usage: $0 <input file>"
	exit 1
fi
ln -sf $1 "$prog.in"
ln -sf $ans "$prog.ans"
echo "Processing `echo $1 | sed -e 's/\.in//g'`"
time ./$prog
diff -bc "$prog.out" "$prog.ans"

