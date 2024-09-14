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
  
  echo "Content-Type: text/plain"
  echo
  # check if partition exist
  if [ -e /dev/mmcblk0p1 ]
  then
    echo "Content of the SD card (mmcblk0p1):"
    echo
    mkdir /run/mount/sd
    mount /dev/mmcblk0p1 /run/mount/sd
    ls -lh /run/mount/sd/
    umount /dev/mmcblk0p1 /run/mount/sd
    rm -r /run/mount/sd
  else
    echo
    echo "error: mmcblk0p1 does not exist"
  fi
fi

#echo 
#echo $sd_feedback
echo
echo "Done"

exit 0