#!/bin/sh

if [ "$REQUEST_METHOD" = "POST" ]; then
  read boundary
  read disposition
  read ctype
  read junk
	#echo $boundary > /tmp/boundary
	#echo $disposition > /tmp/disposition
	#echo $ctype > /tmp/ctype
	#echo $junk > /tmp/junk
fi

echo "Content-Type: text/plain"
echo 
echo "Erase flash mtd0, please wait ... "
flash_erase /dev/mtd0 0 0; 
echo "done";
echo 
echo "Flash erase mtd0 ... finished"


exit 0

