#!/bin/sh

if [ "$REQUEST_METHOD" = "POST" ]; then
  read boundary
  read disposition
  read ctype
  read junk
  # read out file name
  eval `echo $disposition | tr -d '\r' | tr -d '\n' | cut -f4 -d " "` 
  echo "Content-Type: text/plain"
  echo ""
  echo "Write $filename to /dev/mtd2"
  echo
  cat > /tmp/file.tmp
  if [ $? -eq 0 ]; then
    echo "Get File PASSED"
  else
    echo "Get File FAILED"
    exit 404    
  fi
  # remove content-type from multipart/form-data body request 
  for (( i = 0; i <= 5; i++)) 
  do
    sed '$d' /tmp/file.tmp > /tmp/cut.tmp
    cp /tmp/cut.tmp /tmp/file.tmp
  done
  echo "Write Flash ... "
  flashcp -v /tmp/file.tmp /dev/mtd2 > /dev/null
  echo "done"
  # flashcp verification failes (first byte)
  # if [ $? -eq 0 ]; then
  #   echo "Write Flash PASSED"
  # else
  #   echo "Write Flash FAILED"
  #   exit 404
  # fi
  rm /tmp/file.tmp
  rm /tmp/cut.tmp
  if [ $? -eq 0 ]; then
    echo "Delete temp files PASSED"
  else
    echo "Delete temp files FAILED"
    exit 404
  fi
  echo "Done"
else
  echo "Content-Type: text/plain"
  echo ""
  echo "Unknown error"
  exit 404
fi
exit 0

