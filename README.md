# Phase1 - openEye/CamSI
<p align="center">
   <img width="240" src="0.doc/open-eye-logo.png">
</p>

## Objective I
### Upgrade openCam Performance and Functionality
The goals of this development are to deliver complete video pipeline for three popular hi-rez imaging/camera sensors:
 - `2-lane RPiV2.1`, based on Sony IMX219, in `1280x720P@60Hz` RGB888 - `HD`
 - `4-lane OneInchEye`, based on Sony IMX283, in `1920x1080P@60Hz` RGB888 - `FHD`
 - `2-lane OV2740`, in a "Webcam" setup for Lukas Henkel's [openLaptop](https://resources.altium.com/p/open-source-laptop-part-one)

This is for mature, low-cost **Artix7 FPGAs**, by using its **IBUFDS, IDELAY, ISERDES** primitives in the camera front-end. These primitives are available in all IOBs, hence ubiquitous, relatively easy to work with, and already supported by opensource PNR for Xilinx Series7. This also allows future reduction of the total solution cost by migrating to [Spartan7](https://www.xilinx.com/video/fpga/spartan-7-technical-overview.html?_ga=2.252819658.271111311.1715447274-1421952438.1715447272), which does not have GTP transceivers (aka "true SerDes").

>To be clear -- We don't plan on using any of the 3rd party D-PHY front-end silicon devices specified in [XAPP894](https://github.com/chili-chips-ba/openeye-CamSI/blob/main/0.doc/Xilinx/MIPI/xapp894-d-phy-solutions.pdf). Moreover, we won't even use the passive signal conditioning networks that Xilinx is recommending. Instead, our objective is to achieve robust *Signal Integrity* (SI) and flawless HD/FHD video flow by pulling-in only on-chip resources.

This brings about multiple challenges. Compared to [StereoNinja's](https://github.com/StereoNinja/StereoNinjaFPGA) original work, which was for LatticeSemi ECP5 FPGA, our target device does not come with D-PHY receiver circuit *(no wonder why Artix7 costs less* :innocent:*)*.

On top of it, we are doing it on meager internal-to-FPGA BRAM budget, without expending much storage. In other words, PSRAM, SDRAM, DDR or similar external chips are NOT called to rescue. That's a major upgrade to StereoNinja's design, who realized end-to-end, camera-to-monitor streaming for only 640x480 VGA, and only in Grayscale, far below our vibrant RG888 color palette and HD/FHD quality. 

>This design is simpler and more affordable, hence uniquely appealing to the makers. It also paves a path to a cost-efficient openLaptop camera subsystem.

It is indeed the NLnet's objective for this project to bring StereoNinja's pioneering work to an order of magnitude higher performance and functionality level.

On the video feed sink side, we plan to showcase real-time streaming to:
 - **HDMI** monitor
 - **1Gbps Ethernet**, using UDP packets, rendered on a PC with [VLC Player](https://www.videolan.org)

The follow on "Webcam" project (aka Phase2) is to add **UVC** (USB2.0 Video Class) to this list. In prep for this future work, we plan to develop a number of add-on functions:
 - `Enable OV2740 camera chip`
 - `Image Signal Processing (ISP) 4 Webcam`
    > White Balance, Color Correction, Gamma Correction
 - `Video Compression 4 Webcam` - JPEG
    > Not needed for 1GE. But, compression is a must-have for the 1024P@30Hz over USB2

While our design is pushing Artix7 to its limits, it's these very silicon limits that stand in the way of getting more from the given imaging sensors. Recall that even StereoNinja's generally faster and better LatticeSemi FPGA cannot generate HDMI at 1920x1080@60Hz. 

Using Vivado tool chain, we were able to bring this design to the point where the only remaining factor preventing further resolution increase is the *Max Specified Toggle Rate* for Artix7 I/O structures and clock distribution networks.

## Objective II
### Add to opensource ecosystem 4 Xilinx

We are thrilled to use [openXC7](https://github.com/openXC7) toolkit, including its web-based CI/CD flow. That's both for the security of images taken, and to help openXC7 attain the level of robustness found in commercial / proprietary CAE tools, Xilinx Vivado in particular. In that sense, OpenEye-CamSI is the continuation of our [TetriSaraj](https://github.com/chili-chips-ba/openXC7-TetriSaraj), which was the first openXC7 test case for a design more complex than a mere blinky. 

>Our goal is to bring to the light issues that arrive from openXC7's first-ever exposure to demanding, cutting-edge designs like this one. 

It is important to note that, in its current state, openXC7 is rather immature, without even the basic timing awareness, yet alone timing-driven optimizations. It has never been used for designs that push the underlying silicon to the max. The as-is openXC7 is simply not adequate for proper timing closure.

While another project is underway and looking to plug this major opensource STA gap, it won't be ready for our Phase1. We're therefore planning Phase2 and Phase3, hoping to try this new timing closure prowess... Stress-testing, congesting, overwhelming it, all for the sake of making it more amenable to realizing higher Utilization and Fmax metrics with silicon at hand. 

The choice of our development platform was governed by the benefit for the greater community. The boards were selected for their opensource [CRUVI](https://github.com/micro-FPGA/CRUVI/blob/master/docs/CRUVI_Specification.pdf) connectivity spec. Yes, they are hardly used and don't come with support collateral found on the more popular hardware platforms. That's exactly why we opted for them!

We have indeed come across quite a few board problems and idiosyncrasies, spending a fair amount of time chasing issues that simply should not have been there. Still, since those are both opensource and EU products, this extra effort was for a good cause. We are certain that this project will help increase their visibility, and boost their acceptance rate among open makers. 

## Execution Play 1
### Laying a foundation
- [x] Familiarize with [Trenz](https://github.com/chili-chips-ba/openeye-CamSI/tree/main/0.doc/Trenz) hardware platform: Connectivity, clocking, power, etc. 
- [x] Bring up Blinky on Trenz
>___
- [x] Standalone HDMI image generation: 1280x720P@60Hz  RGB888 (HD)
- [x] Standalone HDMI image generation: 1920x1080P@30Hz RGB888 (FHD@30Hz)
- [x] Standalone HDMI image generation: 1920x1080P@60Hz RGB888 (FHD@60Hz). Established that FHD@60Hz is physically impossible with given silicon
>___
- [x] Experiments with IMX219 configuration and resolution options
- [x] Sniff Raspberry Pie interactions with Camera
- [x] Familiarize with *libcamera* drivers
>___  
- [x] Experiments with LVDS and termination schemes.
      How to do better than XAPP894, sharing insights with Lukas
>___
- [x] Test opensource [4-lane adapter](https://github.com/chili-chips-ba/openeye-CamSI/tree/main/0.doc/CRUVI-camera-adapter), sharing feedback with Edmund
- [x] Full redesign, fixing [bugs](https://github.com/chili-chips-ba/openeye-CamSI/blob/main/0.doc/CRUVI-camera-adapter/Technical-Note.TN-mipi.REV1.pdf) and expanding scope, to now include 2 and 4 lanes
>___
- [x] Clock Detection logic without standard LP I/O
- [x] SYNC Decoding logic and Byte Alignement
- [x] Word Alignement
- [x] Header Decoding and Stripping
- [x] Acquire static image from Camera, transfer it to DualPort BRAM, then HDMI
>___
- [x] Uncovered & debugged crosstalk problems on VHDPlus CRUVI adapter
- [x] Found Trenz [signal inversions and inconsistencies](https://github.com/chili-chips-ba/openeye-CamSI/blob/main/0.doc/CRUVI-camera-adapter/CRUVI-Pinout-4-and-2-lanes.xlsx), then shared with Antti
>___
- [x] HD video transfer from Camera to HDMI - At first jerky, with visible frame loss
- [x] Found CDC bug in opensource AsyncFIFO, sharing insights with IP owners
>___
- [x] Debayering logic for Color Space Conversion     
- [x] Synchronization logic for smooth video streaming, w/o external storage
>___

For this first play, the hardware was used in the following config:
- Trenz Carrier Card (TEB0707-02)
- Trenz 4x5 SoM with Artix-7 FPGA (TE0711-01)
- VHDPlus HDMI + 2-lane CSI Camera adapter
- Raspberry Pi V2.1 camera (Sony IMX219)

<p align="center">
  <img width="600" src="https://github.com/chili-chips-ba/openeye-CamSI/assets/113214949/105a7569-75c5-4f2c-8f15-a408bb72cdc6">
</p>

#### *Standalone HDMI image generation*
Our HDMI [image generator](https://github.com/chili-chips-ba/openeye-CamSI/tree/main/1.hw/lib/ip/hdmi) is limited by the toggle rate that's realistically possible with Artix7 clock and I/O primitives. The max we can get from it is:
- 720P@60Hz
- 1080P@30Hz
  
More about this and silicon limitations in [HDMI issue](https://github.com/chili-chips-ba/openeye-CamSI/issues/1#issue-2278453405). Here is the test image that our HDMI RTL outputs on its own, w/o camera connected to it:
<p align="center">
  <img src="https://github.com/chili-chips-ba/openeye-CamSI/assets/113214949/c405a0d6-2086-452a-aa2a-435240055c48" width="500">
</p>

#### *I2C for Camera Configuration*
There are many configurable registers in the IMX219 imaging sensor. Having fully familiarized with them, both by sniffing RPi I2C transactions and running own experiments, we've settled on the 720P@60Hz. I2C Controller was developped from the scratch, and used to load camera registers. More on it in [I2C issue](https://github.com/chili-chips-ba/openeye-CamSI/issues/3). 

Here is an illustration of I2C waveforms, i.e. our Control Plane protocol.
<p align="center">
  <img src="https://github.com/chili-chips-ba/openeye-CamSI/assets/113214949/2b54bf12-1366-4819-8080-df7d5cf8fa20" width="600">
</p>

#### *Camera Connection*
Sony [IMX219](0.doc/Sensor.2-lane.RPi2.1/IMX219PQ.Datasheet.pdf) camera sensor is used for image acquisition. It is connected to FPGA with a 15-pin flex cable (FFC), using [VHDPlus](https://vhdplus.com/docs/components/camera) CRUVI module. We recommend checking our [blog](https://www.chili-chips.xyz/blog/untwisting-rpi5-camera-connectivity) for additional detail on this topic.

It turned out that the 4-lane CRUVI connector had a serious design flaw, essentially shorting system power. Having identified its root cause, we had to fully redesign it. We have also run into Trenz I2C wiring and supply complications related to onboard CPLD. Luckily, we managed to find a way around it without having to open the CPLD and change its internals.

#### *High-speed Signaling and Signal Integrity*
The VHDPlus CRUVI carries three 100 Ohm termination resistors, one for clock, plus two for data, as shown below: 
<p align="center">
  <img width="400" src="https://github.com/chili-chips-ba/openeye-CamSI/assets/113214949/31957cba-ea2c-4b42-942e-e01f8f4e62a8">
</p>
  
Location of these resistors close to data source is a major SI problem. Termination must be placed at the end of *Transmission Line* (TL), next to sink. Yet, on this system, the termination is not only misplaced, but there are also three connectors in the path of high speed signals:
- Camera to CRUVI -> `that's where the stock termination is placed`
- CRUVI to Carrier Card
- Carrier to FPGA SOM Card.

Consequently, we had to remove the stock termination and replace it with internal-to-FPGA resistors, so essentially relocating it to the very end of TL.

When Artix7 internal termination is used in connecton to LVDS_25 IOSTANDARD, it is important to set the correspoding bank's VCCIO to 2.5V. Only then will their differential resistance be 100 Ohms. 

That's on Trenz hardware done in the following way:
- switch DIP 2 to ON state, to set the IOV to 2.5V
- use Jumpers J14, J16, and J17 to connect VCCIO to IOV.
  
#### *Detection of Camera Clock Activity Intervals*
Once all these hardware and board problems were put behind, we turned focus back to RTL design. 

Given the goal to minimize overhead and eliminate the need for LP pins (see XAPP894), RTL had to provide a clever substitute for our non-existent I/O compared to standard Camera Serial Interface. After some experimentation, we settled on a scheme that detects blanking intervals between frames by using *Clock_Lock_FSM* with thresholds and timeouts. The output of this *Clock_Lock_FSM* is then used as global reset for the camera side of pipeline. That's to say that the video pipeline is out of reset only when camera clock is active and stable.

#### *CDC and Video Synchronization*
To have fluid and seamless video, we need to pass Pixel data with Line and Frame synchronization pulses from Camera to HDMI clock. Aiming for low-cost solution, this *Clock Domain Crossing* (CDC) and *Timebase Handoffs* are accomplished using Line Buffering instead of full Frame Buffering, so saving storage resources. More on this topic in [Line buffering issue](https://github.com/chili-chips-ba/openeye-CamSI/issues/2).

In addition to AsyncFIFO for **csi_clock->hdmi_clock** CDC, the signals that play crucial role in the *Timebase Handoffs* process are:
- csi_line_in
- hdmi_line_in

They mark the beginning of each new scan line in incoming video from Camera, as well as outgoing line to HDMI.

Furthermore, Async FIFO is kept in reset when either Camera or HDMI are Out-Of-Frame. It is through this **fifo_areset_n** and **hdmi_reset_n** that we are forcing HDMI to track the Camera. **rgb2hdmi** is the bridge between Camera and HDMI+GE worlds. Timing diagram below contains additional detail.
<p align="center">
  <img src="https://github.com/chili-chips-ba/openeye-CamSI/blob/main/0.doc/Timing-Diagram.png">
</p>

In all honesty, it took us a bit of trial-and-error to get it right. That was to some extent due to CDC bug we found in the fullness count of AsyncFIFO, which is the IP block we pulled from one of the opensource libraries. 

In the end, when everything was tuned, and AsyncFIFO CDC problem factored out of the solution, the final result came to be as nice and polished as follows:
[![image (1)](https://github.com/chili-chips-ba/openeye-CamSI/assets/113214949/e333f585-1f67-4c4a-9ce0-ecf5bda4edde)](https://www.youtube.com/watch?v=BGku8TeV_AA)

#### *Clock and Block Diagram*

The following diagram illustrates design clocking scheme and block structure:

<p align="center">
  <img src="https://github.com/chili-chips-ba/openeye-CamSI/blob/main/0.doc/FPGA-Block-Diagram.png">
</p>
 
Design operates off of a single **external 100MHz** clock, from which we generate **200MHz refclk** for IDELAY and detection of camera activity. The camera clock comes in two forms:
- **CSI Bit** clock, for sampling and capturing incoming DDR data
- **CSI Byte** clock (= Bit clock / 4) for the rest of CSI video pipeline

The frequency of camera *Bit* and *Byte* clocks is the function of sensor resolution. A PLL on HDMI side generates two specific clocks from the common 100MHz input:
- **Parallel**, for RGB888 HDMI data
- **Serial**, (x5) for OSERDES and transmission of multiplexed video to monitor

The frequency of these two clocks is the function of HDMI resolution. We provide Verilog macros in the central *`top_pkg.sv`* for selection of HDMI resolution. 

The datapath is a straight video pipeline with option for width scaling via `NUM_LANE` parameter, which is also located in the central *top_pkg.sv*. 

The pipeline starts with circuits for capturing serial *Double Data Rate* (DDR) camera stream, eye-centering it using IDELAY, converting it to paralell format with ISERDES, then searching for *Byte boundaries*, followed by *Word alignement*, followed by *Packet Header* parsing and extraction of video *Payload* pixels.

It is only at this point, where video is *unpacked*, that we may engage in ISP. The ISP is a set of functions that could be as elaborate as one is willing to invest in them. Here is a [good read on it](https://www.eecs.yorku.ca/~mbrown/ICCV19_Tutorial_MSBrown.pdf). The extent of ISP for this project is clearly defined. The future Phase2 and Phase3 would add more. 

*Debayer* is the first ISP function we implemented. Without it, the displayed colors would have looked weird. More on it in [Debayer issue](https://github.com/chili-chips-ba/openeye-CamSI/issues/4).

## Execution Play 2
### Widening up the pathway
- [x] Repeat the same for the 4-lane IMX283 camera sensor
- [x] Step-by-step introduce the following 3 ISP elements:
  - [x] Debayer
  - [x] Dead Pixel Management
  - [x] Manual Exposure Control 
- [x] Implement another (lower) resolution of our choice

### *IMX283 Sensor Configuration for Different Resolutions*

Configuring the IMX283 sensor for different resolutions requires precise adjustment of its registers. For each data entry, the first four digits represent the register address, while the last two digits indicate the value to be written. Below, we describe the configuration process for achieving both **720p** and **1080p** resolutions at 60 FPS using **Mode 3** and **Mode 2**, respectively.

This sensor requires specific delays after setting some registers. In the [.mem](https://github.com/chili-chips-ba/openeye-CamSI/tree/main/1.hw/lib/ip/i2c_master) files, this is implemented as an additional byte appended to the three bytes representing the address and value of each register. These delays are crucial for ensuring proper operation and stability of the camera. More details can be found in our [issue](https://github.com/chili-chips-ba/openeye-CamSI/issues/29).

### **720p Resolution (60 FPS)**

For 720p resolution, **Mode 3** is used, which applies **3x3 horizontal/vertical binning**. This method combines pixel values within a 3x3 grid for each raw color channel, reducing resolution while maintaining image quality.

#### *Mode Settings*
The following registers enable **Mode 3** operation:
- `3004 1e`
- `3005 18`
- `3006 10`
- `3007 00`

#### *Frame Dimensions*
- **Y_OUT_SIZE**: Set the vertical size to 722 (0x2D2) to account for skipping 2 rows for debayer processing:
  - `302f d2`
  - `3030 02`
- **WRITE_VSIZE**: Set the vertical output size to 726 (0x2D6):
  - `3031 d6`
  - `3032 02`

#### *Frame Cropping*
- **H_TRIMMING_START**: Start the horizontal cropping at position 840 (0x348):
  - `3058 48`
  - `3059 03`
- **H_TRIMMING_END**: End the horizontal cropping at position 4584 (0x11E8):
  - `305a e8`
  - `305b 11`

These settings result in **1920 8-bit data points per line**, equivalent to **1280 12-bit raw data points** used for color processing.

#### *Timing Configuration for 60 FPS*
- **VMAX**: Set to 2551 (0x9F7) to ensure frame blanking:
  - `3038 f7`
  - `3039 09`
- **HMAX**: Set to 470 (0x1D6) to ensure line blanking:
  - `3036 d6`
  - `3037 01`

These settings ensure a frame rate of **60 FPS**.

### **1080p Resolution (60 FPS)**

For 1080p resolution, **Mode 2** is used, which applies **2x2 horizontal/vertical binning**. This method combines pixel values within a 2x2 grid for each raw color channel, maintaining higher resolution while reducing the overall pixel count.

#### *Mode Settings*
The following registers enable **Mode 2** operation:
- `3004 0d`
- `3005 11`
- `3006 50`
- `3007 00`

#### *Frame Dimensions*
- **Y_OUT_SIZE**: Set the vertical size to 1082 (0x43A):
  - `302f 3a`
  - `3030 04`

#### *Frame Cropping*
- **H_TRIMMING_START**: Start the horizontal cropping at position 840 (0x348):
  - `3058 48`
  - `3059 03`
- **H_TRIMMING_END**: End the horizontal cropping at position 4584 (0x11E8):
  - `305a e8`
  - `305b 11`

These settings result in **2880 8-bit data points per line**, equivalent to **1920 12-bit raw data points** used for color processing.

#### *Timing Configuration for 60 FPS*
- **VMAX**: Set to 2234 (0x8BA) to ensure frame blanking:
  - `3038 ba`
  - `3039 08`
- **HMAX**: Set to 540 (0x21C) to ensure line blanking:
  - `3036 1c`
  - `3037 02`

These settings ensure a frame rate of **60 FPS**.

### **Comparison of Configurations**

| Resolution | Mode   | Binning | Y_OUT_SIZE | VMAX   | HMAX | Frame Rate |
|------------|--------|---------|------------|--------|------|------------|
| 720p       | Mode 3 | 3x3     | 722        | 2551   | 470  | 60 FPS     |
| 1080p      | Mode 2 | 2x2     | 1082       | 2234   | 540  | 60 FPS     |

These configurations leverage the IMX283's advanced binning capabilities to optimize performance while maintaining high image quality.

You can watch a demonstration of this setup in action at the following link:

[![image](https://github.com/user-attachments/assets/a2ed28d3-c6f0-4a5d-b290-4a1bb19fae8f)](https://www.youtube.com/watch?v=YFaDeECKaqY&ab_channel=Armin%C5%BDuni%C4%87)


#### *Dead Pixel Management*

One of the key challenges in working with high-resolution sensors, like the IMX283, is managing dead pixels. These are defective pixels on the sensor that can negatively impact image quality. On this system, several strategies were implemented to effectively eliminate the impact of dead pixels.

#### *Resolution Constraints and the Use of Binning*

Due to the limitations of the Artix-7 FPGA, it is not possible to support the full resolution output of the IMX283 sensor. To address this, the resolution was reduced while still preserving image quality by utilizing all available pixels on the sensor. This was achieved through **binning**, a preprocessing step offered by the sensor itself.

- **For 720p Resolution**:  
  A **3x3 binning** method is used. From an 8x8 matrix of pixels, a 2x2 matrix is generated. This means that each new pixel is a combination of several neighboring pixels.
  
- **For 1080p Resolution**:  
  A **2x2 binning** method is used. From a 4x4 matrix of pixels, a 2x2 matrix is generated, combining adjacent pixels into one.

This process is illustrated in the image below:

![image](https://github.com/user-attachments/assets/81913f89-6972-4531-b9d6-6cc87d35f9c0)
![image](https://github.com/user-attachments/assets/abea9982-522b-4e66-ae66-dacdce66180c)

By combining neighboring pixels, binning effectively acts as a form of filtering. This directly mitigates the effect of dead pixels, as their contribution is averaged out with surrounding pixel data.

#### *Debayering and Additional Averaging*

In addition to binning, the **debayering algorithm** implemented on this system further reduces the impact of dead pixels. The algorithm performs additional averaging across pixels to reconstruct color information. This further minimizes the possibility of dead pixels appearing in the final image.

#### *Manual Exposure Control*

Manual exposure control in the IMX283 sensor is achieved through the configuration of the `SVR` (Start Vertical Readout) and `SHR` (Start Horizontal Readout) registers. These registers determine the timing of the sensor's integration period, which is critical for controlling exposure and image brightness.

In our configuration we use:
1. **SVR = 0**: This value sets the integration start vertical period to the minimum possible value, effectively aligning the start of integration with the beginning of the readout period.
2. **SHR = 16**: This value specifies the integration start horizontal period. A higher `SHR` value reduces the integration time by shifting the horizontal readout window closer to the end of the frame.

By selecting these values, the integration time is minimized, which is suitable for scenarios with bright lighting conditions or high frame rate requirements.

## Execution Play 3
### Ethernet streaming
- [ ] Add 1GE as second video sink, then move display to remote PC, via UDP VLC
- [x] Document implementation via block diagram and project repo

## Execution Play 4
### Porting to openXC7
- [ ] Port final design from Vivado to openXC7
- [x] Simulate it with Verilator and cocoTB, in CI/CD system
- [ ] Document scripts and flows used in this process

## Execution Play 5
### Prepping for Webcam
(__Chili.CHIPS*ba team__)
- [x] Enable OV2740 camera chip: 
   - [x] Bring up Lukas' new adapter board
   - [x] Reverse-engineer I2C settings
   - [x] Demonstrate CAM-to-HDMI video path

### *OV2740 Sensor Configuration for 720p resolution*

Configuring the OV2740 sensor for 720p resolution requires precise adjustment of its registers. Each data entry comprises a six-digit code: the first four digits specify the register address, while the final two digits denote the value to be written.

The first step is to configure the sensor's output type. For this setup, the 8-bit mode was selected by writing the value 0x08 to the register 0x3031, as shown below:

- `3031 08`

Although the camera outputs RAW 10-bit data, the ISP block processes the data and enables an 8-bit RAW output at the interface.

A crucial step in setting up the OV2740 sensor is configuring the PLL to generate two essential clocks:

MIPI PHY Clock: This clock is critical for the MIPI interface and must match the clock frequency on the FPGA side to ensure proper communication.

SCLK (System Clock): This clock is used by the Image Sensor Processor (ISP) block. It is vital to set the frequency high enough; otherwise, the ISP block will not have sufficient time to complete all its tasks, potentially leading to image processing errors.

The correct clock frequencies are ensured by configuring the following registers.

- **MIPI PHY**: 450 MHz
- `0302 4b`
- `030a 01`
  
- **SCLK**:   
- `030d 4b`
- `030e 01`
- `0312 11`

#### *720p resolution*
- **H_OUTPUT_SIZE**: Set the horizontal size to 1280 (0x500): 
- `3808 05`
- `3809 00`
- **V_OUTPUT_SIZE**: Set the vertical size to 720 (0x2d0): 
- `3801 02`
- `380b d0`

The next step is configuring the frame rate to 60 FPS. This is achieved by setting two key registers: HTS (Horizontal Timing Size) and VTS (Vertical Timing Size). Understanding how these registers affect the camera's data (signals) is essential for proper configuration.

HTS (Horizontal Timing Size):
Increasing the value of HTS extends the duration of sending a complete line, including both the useful data and the blanking period. However, it is crucial to maintain the duty cycle of the entire frame while adjusting HTS, as this directly impacts the frame rate.

VTS (Vertical Timing Size):
Increasing the value of VTS extends the duration of sending the entire frame, including the blanking period. By adjusting VTS, you control the total frame time, which also influences the resulting frame rate.

The duration of a line or frame does not depend on the number of pixels per line or per frame, but only on the values of HTS and VTS.

- **HTS**: Set the HTS to 1816 (0x718): 
- `380c 07`
- `380d 18`
- **VTS**: Set the VTS to 1000 (0x3e8): 
- `380e 03`
- `380f e8`

A demonstration of this configuration is provided below, using a test image generated by the camera.

<div align="center">
  <img src="https://github.com/user-attachments/assets/c8ec47aa-e985-4fd1-bf54-0f016279d965" alt="OV2740_test_image" width="500px">
</div>

(__Silicon Highway Technologies webcam team__)
- [x] Add 3 new ISP functions
   - [x] White Balance
   - [x] Color Correction
   - [x] Gamma Correction
- [x] JPEG video compression

### *Color Balance and JPEG Image Processing Blocks*

The goal of this part of the project was to implement and test (1) a **color balancing IP block** and (2) a **JPEG image compression IP block**, both to be parts of an image or video pipeline. 

- (1) was based on https://www.ipol.im/pub/art/2011/llmps-scb/?utm_source=doi which is a color balance algorithm performing ***white balance*, *color correction* and *gamma correction* simultaneously**. The **Simple Color Balance (SCB)** block was thus implemented from scratch and tested first using behavioural simulations in *Verilator* and *Vivado* and subsequently using post-PNR simulations in the *Vivado Simulation Environment* for the target device.

- (2) is based on an IP implemented by Robert Metchev in Verilog RTL: https://github.com/brilliantlabsAR/frame-codebase/tree/main/source/fpga/modules/camera/jpeg_encoder. The provided *JPEG* block was tested using behavioural simulation with *Cocotb*.

#### **JPEG**
The *JPEG* design was tested on `1280x720` images, initially on one single frame, and afterwards on multiple frames, simulating a video. Each frame is successfully converted from a bitmap image to a converted image in the *JPEG* format. To add the required headers, in order to display each *JPEG* image, external python functions are used.

This specific *JPEG* module requires three clocks of different frequencies: the pixel clock, which always runs at `36MHz`, a *JPEG* slow clock and a *JPEG* fast clock. The slow clock can run at `12MHz`, `18MHz`, `24MHz` or `36MHz`, while the fast clock must be at least twice as fast as the slow clock.

The *JPEG* module can take four discrete **Quality Factor (QF)** values as input. These are `10%`, `25%`, `50%` and `100%`. The functionality of the design was verified for each of these values, with visual differences being observed.

Below, two compressed images with different *QF* are displayed. The left image has a `10%` *QF* and the right has a `50%` *QF*:
<p float="left">
  <img src="https://github.com/user-attachments/assets/8a81159a-f816-4ac5-9adc-0e1cf650e085" width="40%" />
  <img src="https://github.com/user-attachments/assets/cb805ff7-9335-4011-9a16-5a0a622ac52c" width="40%" /> 
</p>

To model the three clocks, we use an **MMCM** (Mixed Mode Clock Manager) to generate them from the `100MHz` clock of the board. For the slow clock, we choose a frequency of `12MHz`, and for the fast clock, we choose a frequency of `72MHz`.

In the simulation screenshot below, two frames are processed and a compressed output file is produced for each one. The signal image_valid_out rises when a compressed image is ready. The *JPEG* data words are sampled from the output signal data_out.
<p align="left">
  <img width="60%" src="https://github.com/user-attachments/assets/c511c217-e092-4b61-8fdf-d55cbfe66ff8">
</p>

#### **Simple Color Balance (SCB)**
**SCB** IP Block available software code was available from https://www.ipol.im/pub/art/2011/llmps-scb/?utm_source=doi. 

A hardware implementation must work with “live” images, however, i.e. groups of pixels per frame, flowing through an image pipeline. The hardware implementation of the *SCB* thus works on a frame by frame basis, correcting the colours of frame `n` in frame `(n + 1)`. The gap between frames is sufficient to compute the colour balance frame ratios, i.e. 
`frameratio = 255/(max RGB – min RGB)` per RGB channel, using dividers. Then, colours are balanced “live”, during frame `(n + 1`), by multiplying the input pixel colour `i` by `(i – min) x frameratio`.

The pixel clock frequency of `36MHz` is sufficient to perform multiplications “live”, as pixels come in and go out through the SCB IP Block. This was checked using post-PNR simulations in Vivado as both timing was closed for the design and entire images were validated to be balanced correctly.

In the following two figures, the effect of the *SCB* algorithm can be seen. On the left is the original image, which appears to be faded out, and on the right is the balanced image, which appears brighter and livelier, due to the color balancing:

<p align="left">
  <img src="https://github.com/user-attachments/assets/aec2abe9-594f-43c7-a6d0-f2eaaf4e6a84">
&nbsp; &nbsp; &nbsp; &nbsp;
  <img src="https://github.com/user-attachments/assets/7f9973be-c9e4-400e-8ff4-6cfb03cb38a5">
</p>

Similarly, a sequence of frames that represents a video, can be displayed in the following figures. The range of the RGB values changes from frame to frame, and the *SCB* algorithm tries to balance them, based on each previous frame.
- Input Frames:
<p float="left">
  <img src="https://github.com/user-attachments/assets/527ff207-5331-4c40-a34b-1ed341b4690a" width="18%" />
  <img src="https://github.com/user-attachments/assets/bc37ffe4-7ace-45fb-bc02-e044579ede9a" width="18%" /> 
  <img src="https://github.com/user-attachments/assets/a91d4c1c-d96a-48ae-99c4-b38b54a1ba86" width="18%" /> 
  <img src="https://github.com/user-attachments/assets/c8fb4cc7-178d-423f-b505-2e0584a19056" width="18%" /> 
  <img src="https://github.com/user-attachments/assets/16fd01d7-9381-43c8-a354-a948236908f8" width="18%" /> 
</p>

- Output Frames:
<p float="left">
  <img src="https://github.com/user-attachments/assets/0a874c4d-f052-4829-a3da-9bc904bac58f" width="18%" />
  <img src="https://github.com/user-attachments/assets/712e3aa3-fe47-4a54-9038-d62fdeaebd5a" width="18%" /> 
  <img src="https://github.com/user-attachments/assets/1839e3b2-f9a4-472e-8f36-52422991797e" width="18%" /> 
  <img src="https://github.com/user-attachments/assets/165a87a1-581e-4ee9-afe6-ae1686fefdc7" width="18%" /> 
  <img src="https://github.com/user-attachments/assets/7a8be7f0-7643-400a-bfc1-416880abc9df" width="18%" /> 
</p>

In the screenshot below, the processing of one of the frame lines is shown. Previously, one identical frame has already been loaded, to configure the min-max ranges. In the input frame, all RGB values are within the range `[64, 196]`, so the SCB algorithm translates them to the range `[0, 255]`, with minor precision inaccuracies that do not have a large visible impact. The balancing is performed using multipliers which have a single cycle delay, thus this algorithm converts each frame with a single-cycle delay.
<p align="left">
  <img width="70%" src="https://github.com/user-attachments/assets/14ace642-50b9-4f24-9c23-7e8b3e501cb5">
</p>

## Trenz and CRUVI in retrospect

The hardware platform originally selected for this project proved to be a capital miss and source of most of our troubles. 

We ended up having to debug board and connectivity issues on PCBAs that no one used before, or combinations thereof that the manufacturer never tested. Be it incorrect termination resistors, straight shorts, cold solder joints and opens on flaky connectors, signal integrity degradation from too much modularity / discontinuity on the path, swaps of differential pairs, or wiring high-speed clocks to the non-Clock Capable (CC) FPGA pins, the share of board issues we had to deal with was overwhelming.

On top of that comes scarce availability of Trenz board, with lead times in excess of three months for a simple passive CRUVI Debug Card. All that has cost us dearly in time and effort. Yes, CRUVI is open-source. Yes, Trenz is European. But, we cannot afford to keep investing and loosing so much in order to support that cause.

Going forward, we are parting away with Trenz CRUVI system, and switching to Puzhitech [PA-StarLite](https://www.aliexpress.us/item/3256806434967523.html?gps-id=pcStoreJustForYou&scm=1007.23125.137358.0&scm_id=1007.23125.137358.0&scm-url=1007.23125.137358.0&pvid=c1d02f3c-8f66-4b76-a24a-a72144960d79&_t=gps-id%3ApcStoreJustForYou%2Cscm-url%3A1007.23125.137358.0%2Cpvid%3Ac1d02f3c-8f66-4b76-a24a-a72144960d79%2Ctpp_buckets%3A668%232846%238107%231934&pdp_npi=4%40dis%21USD%21128.44%21102.75%21%21%21901.32%21721.06%21%402101c67a17281960440137763ec377%2112000037845115402%21rec%21US%212013047485%21XZ&spm=a2g0o.store_pc_home.smartJustForYou_2010082555490.1005006621282275&gatewayAdapt=glo2usa). This compact card brings everything we need for video projects off-the-bat, within basic package, including 2-lane MIPI CSI connector, HDMI output and 1Gbps Ethernet. No need for multiple add-on cards and connectors to put together a useable system that's 3x more expensive, more fragile, and not in stock.

This card also comes with solid expension potential via two 40-pin standard 100mil headers. They are mechanically robust, physically accessible for debugging, and still can carry relatively high-speed signals thanks to short, balanced wiring on the mainboard.

<p align="center">
<img width="300" src="0.doc/Puzhitech/Images/PA.1.png">
<img width="300" src="0.doc/Puzhitech/Images/PA.2.png">
<img width="300" src="0.doc/Puzhitech/Images/PA.3.png">
   
<img width="300" src="0.doc/Puzhitech/Images/PA.4.png">
<img width="300" src="0.doc/Puzhitech/Images/PA.5.png">
   
<img width="300" src="0.doc/Puzhitech/Images/PA.7.png">

<img width="900" src="0.doc/Puzhitech/Images/Puzhi-vs-Trenz.jpg">
</p>

While [Puzhitech](http://www.puzhitech.com/en) board already comes with 15-pin 0.5mm FPC for 2-lane MIPI CSI, the 40-pin 100mil headers can be used to hook up additional RPi cameras via its [15-pin 1mm](https://tinkersphere.com/cables-wires/3843-15-pin-05mm-1mm-pitch-fpc-to-dip-breakout.html#/soldered_side-1mm) FPC, as well as 22-pin 0.5mm connector for the 4-lane interface. Below is a picture of the [adapters](https://www.ebay.com/itm/175795228114?mkcid=16&mkevt=1&mkrid=711-127632-2357-0&ssspo=1cGlwdPqS5y&sssrc=4429486&ssuid=QKddZKcUTzu&var=475196039437&widget_ver=artemis&media=MORE) we used. We recommend fitting them with DIP connectors that have longer legs, so that they protrude on the bottom side, and also serve as attachment points for oscilloscope. That alleviates the need for the €36 Trenz Debug Connector and its impossibly long lead time of 3+ months.

<p align="center">
<img width="400" src="0.doc/Puzhitech/Images/FPC-0.5mm--to--DIP-100mil.png">
</p>

# Phase2 - USB Webcam
- See: https://nlnet.nl/project/FPGA-ISP-UVM-USB2

# Phase3 - openCam/Event

This project aims to introduce the field of Event Cameras to open-source domain. It does it by developing the following three outcomes:
  1) interface to an entry-level Prophesee/Sony event imaging sensor, and its integration with PC systems
  2) novel algorithms for processing event-based video data
  3) efficient FPGA-based hardware acceleration platform for these algorithms.

The interface will enable physical connectivity, configuration, and live data transfer via Ethernet. The algorithm development will decode and interpret event video frames, extracting key features such as rapid motion events. The acceleration track will port these algorithms to an FPGA embedded system that implements a soft processor customized for video workloads, programmable in high-level languages, blending hardware and software methods for high throughput and efficiency.

Together, these three outcomes will create the first fully open-source platform for exploring and utilizing Event Camera technology, paving the way for future applications.

All these elements are new, not only for the open-source community, but also the professional industry.

The project goal is to form a solid base from which the makers can start developing open-source apps with Event Camera. It is in that sense similar to uberDDR3. The scope of this initial project will include a couple of Getting Started examples, such as recording the mechanical vibrations of an industrial motor, or inside a high-voltage switch, or counting the free-falling beans.

There are many other possible applications of this technology. They span industrial, medical, automotive, IOT, VR, mobile, high-speed photography, aerospace, and beyond. New applications and use-cases are also constantly invented. We intend to exploit some of them in the subsequent project proposals.

Just for background, here are a few references to what can be done with this technology:
- https://inivation.com/solutions
- https://www.prophesee.ai/event-based-vision-industrial
- https://www.prophesee.ai/event-based-vision-automotive
- https://www.prophesee.ai/event-based-vision-medical
- https://www.prophesee.ai/event-based-vision-xr
- https://www.prophesee.ai/event-based-vision-mobile
- https://www.prophesee.ai/event-based-vision-iot
- https://www.prophesee.ai/event-based-vision-more-applications
  
The primary objective of this project is to open the door for open-source developers to enter this vast and mostly unexplored application space.

## Public Announcements
  [2024/12/14](https://www.linkedin.com/posts/chili-chips_sony-imx283-camera-1080p-60fps-stream-with-activity-7273936850312916992-ZF01?utm_source=share&utm_medium=member_desktop)

## *Acknowledgements*
We are grateful to:
 - NLnet Foundation's sponsorship for giving us an opportunity to work on this fresh new take at FPGA video processing.
 - StereoNinja, whose project has set the stage for this major upgrade of opensource camera performance and functionality, as well as its expansion from LatticeSemi to Xilinx ecosystem.

<p align="center">
    <img src="https://github.com/chili-chips-ba/openeye/assets/67533663/18e7db5c-8c52-406b-a58e-8860caa327c2">
    <img width="115" alt="NGI-Entrust-Logo" src="https://github.com/chili-chips-ba/openeye-CamSI/assets/67533663/013684f5-d530-42ab-807d-b4afd34c1522">
</p>

#### End of Document
