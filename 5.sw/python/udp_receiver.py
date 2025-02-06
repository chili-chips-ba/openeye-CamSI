#!/usr/bin/env python
"""
UDP echo test
"""
import numpy as np
import argparse
import socket
import time
import cv2
import threading

BUFF_SIZE = 8192

def display_thread(canvas):
   while True:
      cv2.imshow('Image', canvas)
      time.sleep(0.5)
      if cv2.waitKey(10) & 0xFF == ord('q'):
         break

def main():
   parser = argparse.ArgumentParser(description=__doc__.strip())
   parser.add_argument('port', help="UDP port", nargs='?', type=int, default=1234)
   args = parser.parse_args()
   port = args.port
   sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
   sock.bind(('',port))
   sock.settimeout(10)
   
   # image of 1280 x 700 pixels , with 3 channels 
   xdim =1280
   ydim =700
   channels=3
   color_bg=(0,0,0)
   imgdim = (ydim, xdim, channels)
   canvas = np.full(imgdim, color_bg, np.uint8)
   d = threading.Thread(target=display_thread, args=(canvas,))
   d.start()

   frame_count = 0
   frame_prev = 0
   y_prev = 0
   count = 0
   frame = 0
   recv = 0
   recv_prev = 0   
   while True:
      try:
         data, addr = sock.recvfrom(BUFF_SIZE)
         package_len = len(data)
         if(package_len == 1282):
            y = (data[0]&int(0x7f))<<8 | data[1]
            frame = data[0] >> 7
            for x in range(2, 1280, 2):
               rgb565 = data[x] << 8 | data[x+1]
               rgb888 = (rgb565&0x001F) << 3 | 0x07, (rgb565&0x07E0) >> 3 | 0x03, (rgb565&0xF800) >> 8 | 0x07
               if(frame == 0):
                  canvas[y,x-2,:] = rgb888
               else:
                  canvas[y,x-1,:] = rgb888
            #if(frame != frame_prev):
            #   frame_count = frame_count + 1
            #   if(frame_count == 10): 
            #      frame_count = 0
            #t.join()            
            #if(abs(y - y_prev) > 4):
            #   print(f"count ", y, y_prev, abs(y - y_prev) )
            #y_prev = y
         else:
            print("error:", package_len, data[0], data[1], data[2], data[3])
         recv_prev = recv
         recv += 1
         frame_prev = frame
      except socket.timeout:
         break
   print(f"Received {recv} packets")

if __name__ == "__main__":
   main()

