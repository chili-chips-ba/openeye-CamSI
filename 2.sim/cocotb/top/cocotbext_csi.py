import cocotb
from cocotb.triggers import Timer

class CSI:
   def __init__(self, dut, signal, period_ns, fps_Hz, line_length, frame_length, frame_blank, num_lane, dinvert, raw=8, uniform_data=True, start_value=0x00):
      self.dut          = dut
      self.signal       = signal
      self.period_ns    = period_ns
      self.fps_Hz       = fps_Hz
      self.line_length  = (
                          line_length if raw == 8 else
                          int(line_length * (5 / 4)) if raw == 10 else
                          int(line_length * (3 / 2)) if raw == 12 else
                          line_length
                          )
      self.frame_length = frame_length
      self.frame_blank  = frame_blank
      self.num_lane     = num_lane
      self.dinvert      = dinvert
      self.raw          = raw
      self.uniform_data = uniform_data
      self.start_value  = start_value
      self.temp_var     = (1_000_000_000 / fps_Hz) / (8 * period_ns)
      self.line_blank   = int(self.temp_var / (frame_length + frame_blank)) - int(self.line_length / num_lane)

   def invert_byte(self, byte, lane):
      """
      Function to invert byte based on the DINVERT setting.
      """
      if self.dinvert[lane]:
         return ~byte & 0xFF
      return byte
   
   def calculate_ecc(self, byte1, byte2, byte3):
      """
      Calculate the ECC for the given three bytes.
      The ECC is computed over the 24 bits formed by concatenating the three bytes.
      """
      data = (byte1 << 16) | (byte2 << 8) | byte3

      ecc = 0

      ecc_bit5 = ((data >> 10) & 1) ^ ((data >> 11) & 1) ^ ((data >> 12) & 1) ^ ((data >> 13) & 1) ^ ((data >> 14) & 1) ^ ((data >> 15) & 1) ^ ((data >> 16) & 1) ^ ((data >> 17) & 1) ^ ((data >> 18) & 1) ^ ((data >> 19) & 1) ^ ((data >> 21) & 1) ^ ((data >> 22) & 1) ^ ((data >> 23) & 1)
      ecc |= ecc_bit5 << 5

      ecc_bit4 = ((data >> 4) & 1) ^ ((data >> 5) & 1) ^ ((data >> 6) & 1) ^ ((data >> 7) & 1) ^ ((data >> 8) & 1) ^ ((data >> 9) & 1) ^ ((data >> 16) & 1) ^ ((data >> 17) & 1) ^ ((data >> 18) & 1) ^ ((data >> 19) & 1) ^ ((data >> 20) & 1) ^ ((data >> 22) & 1) ^ ((data >> 23) & 1)
      ecc |= ecc_bit4 << 4

      ecc_bit3 = ((data >> 1) & 1) ^ ((data >> 2) & 1) ^ ((data >> 3) & 1) ^ ((data >> 7) & 1) ^ ((data >> 8) & 1) ^ ((data >> 9) & 1) ^ ((data >> 13) & 1) ^ ((data >> 14) & 1) ^ ((data >> 15) & 1) ^ ((data >> 19) & 1) ^ ((data >> 20) & 1) ^ ((data >> 21) & 1) ^ ((data >> 23) & 1)
      ecc |= ecc_bit3 << 3

      ecc_bit2 = ((data >> 0) & 1) ^ ((data >> 2) & 1) ^ ((data >> 3) & 1) ^ ((data >> 5) & 1) ^ ((data >> 6) & 1) ^ ((data >> 9) & 1) ^ ((data >> 11) & 1) ^ ((data >> 12) & 1) ^ ((data >> 15) & 1) ^ ((data >> 18) & 1) ^ ((data >> 20) & 1) ^ ((data >> 21) & 1) ^ ((data >> 22) & 1)
      ecc |= ecc_bit2 << 2

      ecc_bit1 = ((data >> 0) & 1) ^ ((data >> 1) & 1) ^ ((data >> 3) & 1) ^ ((data >> 4) & 1) ^ ((data >> 6) & 1) ^ ((data >> 8) & 1) ^ ((data >> 10) & 1) ^ ((data >> 12) & 1) ^ ((data >> 14) & 1) ^ ((data >> 17) & 1) ^ ((data >> 20) & 1) ^ ((data >> 21) & 1) ^ ((data >> 22) & 1) ^ ((data >> 23) & 1)
      ecc |= ecc_bit1 << 1

      ecc_bit0 = ((data >> 0) & 1) ^ ((data >> 1) & 1) ^ ((data >> 2) & 1) ^ ((data >> 4) & 1) ^ ((data >> 5) & 1) ^ ((data >> 7) & 1) ^ ((data >> 10) & 1) ^ ((data >> 11) & 1) ^ ((data >> 13) & 1) ^ ((data >> 16) & 1) ^ ((data >> 20) & 1) ^ ((data >> 21) & 1) ^ ((data >> 22) & 1) ^ ((data >> 23) & 1)
      ecc |= ecc_bit0

      return ecc

   async def send_combined_bytes(self, byte0, byte1, byte2=0x00, byte3=0x00):
      """
      Coroutine to send two or four bytes combined on the differential signal.
      The bytes are decomposed into bits, and each bit is mapped to a lane.
      For differential signaling, each bit has a positive and a negative component.
      """
      for bit in range(8):
         bit_a = (byte0 >> bit) & 0x1
         bit_b = ~bit_a & 0x1
         bit_c = (byte1 >> bit) & 0x1
         bit_d = ~bit_c & 0x1

         if self.num_lane == 2:
            self.signal.value = (bit_a << 3) | (bit_b << 2) | (bit_c << 1) | bit_d
         elif self.num_lane == 4:
            bit_e = (byte2 >> bit) & 0x1
            bit_f = ~bit_e & 0x1
            bit_g = (byte3 >> bit) & 0x1
            bit_h = ~bit_g & 0x1
            self.signal.value = (bit_a << 7) | (bit_b << 6) | (bit_c << 5) | (bit_d << 4) | (bit_e << 3) | (bit_f << 2) | (bit_g << 1) | bit_h
         
         await Timer(self.period_ns, units='ns')

   async def send_incrementing_data(self, start_value, repeat_count=1):
      value0, value1, value2, value3 = (start_value,) * 4
      for i in range(repeat_count):
         if self.num_lane == 4:
            byte3 = self.invert_byte(value0 & 0xFF, 3)
            byte2 = self.invert_byte((value1 + 0) & 0xFF, 2)
         
         byte1 = self.invert_byte((value2 + 0) & 0xFF, 1)
         byte0 = self.invert_byte((value3 + 0) & 0xFF, 0)

         if self.num_lane == 2:
            await self.send_combined_bytes(byte1, byte0) #Because of the inversion of CSI2 protocol [1,0], not [0,1]
         elif self.num_lane == 4:
            await self.send_combined_bytes(byte3, byte2, byte1, byte0)
         
         if (self.raw == 8):
            value0, value1, value2, value3 = map(lambda v: v + 1, (value0, value1, value2, value3))
         elif (self.raw == 10):
            if (i % 5 == 0):
               value1, value2, value3 = map(lambda v: v + 1, (value1, value2, value3))
            elif (i % 5 == 1):
               value0, value2, value3 = map(lambda v: v + 1, (value0, value2, value3))
            elif (i % 5 == 2):
               value0, value1, value3 = map(lambda v: v + 1, (value0, value1, value3))
            elif (i % 5 == 3):
               value0, value1, value2 = map(lambda v: v + 1, (value0, value1, value2))
            elif (i % 5 == 4):
               value0, value1, value2, value3 = map(lambda v: v + 1, (value0, value1, value2, value3))
         elif (self.raw == 12):
            if (i % 3 == 0):
               value2, value3 = map(lambda v: v + 1, (value2, value3))
            elif (i % 3 == 1):
               value0, value1 = map(lambda v: v + 1, (value0, value1))
            elif (i % 5 == 2):
               value0, value1, value2, value3 = map(lambda v: v + 1, (value0, value1, value2, value3))


   async def send_data_pattern(self, byte0, byte1, byte2=0x00, byte3=0x00, repeat_count=1):
      """
      Coroutine to send a specific data pattern on a given lane for a specified number of repetitions.
      """
      byte0 = self.invert_byte(byte0, 0)
      byte1 = self.invert_byte(byte1, 1)
      if self.num_lane == 4:
         byte2 = self.invert_byte(byte2, 2)
         byte3 = self.invert_byte(byte3, 3)

      for _ in range(repeat_count):
         if self.num_lane == 2:
            await self.send_combined_bytes(byte0, byte1)
         elif self.num_lane == 4:
            await self.send_combined_bytes(byte0, byte1, byte2, byte3)

   async def start_frame(self):
      """
      Coroutine to send the start of a frame.
      """
      ecc = self.calculate_ecc(0x00, 0x12, 0x00)

      if self.num_lane == 2:
         await self.send_data_pattern(0x00, 0x00, repeat_count=1)  # Some random data at the start of the sequence
         await self.send_data_pattern(0xB8, 0xB8, repeat_count=1)  # Sync bytes b8b8
         await self.send_data_pattern(0x12, 0x00, repeat_count=1)  # Start of frame
         await self.send_data_pattern(ecc, 0x00, repeat_count=1)   # ECC
         await self.send_data_pattern(0x00, 0x00, repeat_count=6)  # Some random data at the end of the sequence
      elif self.num_lane == 4: # adjust as needed
         await self.send_data_pattern(0x00, 0x00, 0x00, 0x00, 1)
         await self.send_data_pattern(0xB8, 0xB8, 0xB8, 0xB8, 1)
         await self.send_data_pattern(ecc, 0x00, 0x12, 0x00, 1)
         await self.send_data_pattern(0x00, 0x00, 0x00, 0x00, 6)

   async def end_frame(self):
      """
      Coroutine to send the end of a frame.
      """
      ecc = self.calculate_ecc(0x00, 0x12, 0x01)

      if self.num_lane == 2:
         await self.send_data_pattern(0x00, 0x00, repeat_count=1)  # Some random data at the start of the sequence
         await self.send_data_pattern(0xB8, 0xB8, repeat_count=1)  # Sync bytes b8b8
         await self.send_data_pattern(0x12, 0x01, repeat_count=1)  # End of frame
         await self.send_data_pattern(ecc, 0x00, repeat_count=1)   # ECC
         await self.send_data_pattern(0x00, 0x00, repeat_count=5)  # Some random data at the end of the sequence
      elif self.num_lane == 4: # adjust as needed
         await self.send_data_pattern(0x00, 0x00, 0x00, 0x00, 1)
         await self.send_data_pattern(0xB8, 0xB8, 0xB8, 0xB8, 1)
         await self.send_data_pattern(ecc, 0x00, 0x12, 0x01, 1)
         await self.send_data_pattern(0x00, 0x00, 0x00, 0x00, 6)

   async def send_embedded_data(self, data):
      """
      Coroutine to send embedded data.
      """
      length_high = (self.line_length >> 8) & 0xFF
      length_low = self.line_length & 0xFF
      ecc = self.calculate_ecc(length_high, length_low, 0x12)

      if self.num_lane == 2:
         await self.send_data_pattern(0x00, 0x00, repeat_count=1)        # Some random data at the start of the sequence
         await self.send_data_pattern(0xB8, 0xB8, repeat_count=1)        # Sync bytes b8b8
         await self.send_data_pattern(length_low, 0x12, repeat_count=1)  # Start of long packet - EMBEDDED DATA
         await self.send_data_pattern(ecc, length_high, repeat_count=1)
         await self.send_data_pattern(data, data, repeat_count=int(self.line_length/self.num_lane)) # DATA
         await self.send_data_pattern(0x00, 0x00, repeat_count=self.line_blank)  # Some random data at the end of the sequence
      elif self.num_lane == 4: # adjust as needed
         await self.send_data_pattern(0x00, 0x00, 0x00, 0x00, 1)
         await self.send_data_pattern(0xB8, 0xB8, 0xB8, 0xB8, 1)
         await self.send_data_pattern(ecc, length_high, length_low, 0x12, 1)
         await self.send_data_pattern(data, data, data, data, int(self.line_length/self.num_lane))
         await self.send_data_pattern(0x00, 0x00, 0x00, 0x00, self.line_blank)
         
   async def send_line(self, data):
      """
      Coroutine to send a line of data.
      """
      length_high = (self.line_length >> 8) & 0xFF
      length_low = self.line_length & 0xFF
      ecc = self.calculate_ecc(length_high, length_low, 0x28)
      
      if self.num_lane == 2:
         await self.send_data_pattern(0x00, 0x00, repeat_count=1)        # Some random data at the start of the sequence
         await self.send_data_pattern(0xB8, 0xB8, repeat_count=1)        # Sync bytes b8b8
         await self.send_data_pattern(length_low, 0x28, repeat_count=1)  # Start of long packet - START OF LINE
         await self.send_data_pattern(ecc, length_high, repeat_count=1)
         
         if self.uniform_data:
            await self.send_data_pattern(data, data, repeat_count=int(self.line_length/self.num_lane)) # DATA
         else:
            await self.send_incrementing_data(self.start_value, repeat_count=int(self.line_length/self.num_lane)) #DATA
         
         await self.send_data_pattern(0x00, 0x00, repeat_count=self.line_blank)  # Some random data at the end of the sequence
      elif self.num_lane == 4: # adjust as needed
         await self.send_data_pattern(0x00, 0x00, 0x00, 0x00, 1)
         await self.send_data_pattern(0xB8, 0xB8, 0xB8, 0xB8, 1)
         await self.send_data_pattern(ecc, length_high, length_low, 0x28, 1)

         if self.uniform_data:
            await self.send_data_pattern(data, data, data, data, repeat_count=int(self.line_length/self.num_lane)) # DATA
         else:
            await self.send_incrementing_data(self.start_value, repeat_count=int(self.line_length/self.num_lane)) #DATA

         await self.send_data_pattern(0x00, 0x00, 0x00, 0x00, self.line_blank)

   async def send_frame(self):
      """
      Coroutine to send a full frame.
      """
      await self.start_frame()
      line_data = 0xFF  # Example data for a line

      for i in range(5):  # (self.frame_length + self.frame_blank) instead of 5
         if i > 2:        # (self.frame_length - 1) instead of 2
            line_data = 0x11
         await self.send_line(line_data)

      await self.end_frame()

   async def run(self, num_frames):
      """
      Coroutine to run the sequence of frame transmissions.
      """
      for _ in range(num_frames):
         await self.send_frame()
