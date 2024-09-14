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
  echo "write to SD1:"
  echo
  # check if partition exist
  if [ -e /dev/mmcblk1p1 ]
  then
    # read out file name
    eval `echo $disposition | tr -d '\r' | tr -d '\n' | cut -f4 -d " "`
    cat > /tmp/file.tmp
    
    # remove content-type from multipart/form-data body request 
    for (( i = 0; i <= 5; i++)) 
    do
      sed '$d' /tmp/file.tmp > /tmp/cut.tmp
      cp /tmp/cut.tmp /tmp/file.tmp
    done
    echo "write $filename to mounted SD card ..."
    mkdir /run/media/sd
    mount /dev/mmcblk1p1 /run/media/sd
    cp /tmp/file.tmp /run/media/sd/$filename
    sync
    sync
    rm /tmp/file.tmp
    rm /tmp/cut.tmp
    umount /dev/mmcblk1p1 /run/media/sd
    rm -r /run/media/sd
  else
    echo "error: mmcblk1p1 does not exist"
  fi
fi

#echo 
#echo $sd_feedback
echo
echo "Done"

exit 0

