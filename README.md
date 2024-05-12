# openEye-CamSI (Phase1)
<img src="https://github.com/chili-chips-ba/openeye/assets/67533663/07cb0f47-c9c7-483e-a028-0066342f5023" width="250">

## *Objective 1 - Upgrade Performance and Functionality*
The goals of this development are to deliver video pipeline for three popular hi-rez imaging sensors:
 - `2-lane RPiV2.1`, based on Sony IMX219, in `1280x720P@60Hz` RGB888 - `HD`
 - `4-lane OneInchEye`, based on Sony IMX283, in `1920x1080P@30Hz` RGB888 - `FHD`
 - `2-lane OV2740`, in a TBD "Webcam" setup for Lukas Henkel's [openLaptop](https://resources.altium.com/p/open-source-laptop-part-one) project

The intent is to do it with mature and affordable <b>Artix7 FPGA</b>, by using its <b>IBUFDS, IDELAY, ISERDES</b> primitives for the camera front-end. These primitives are available in all IOBs, hence ubiquitous, relatively easy to work with, and already supported by opensource PNR tool for Xilinx Series7. This also leaves the path open for future reduction of total solution cost by migrating to [Spartan7](https://www.xilinx.com/video/fpga/spartan-7-technical-overview.html?_ga=2.252819658.271111311.1715447274-1421952438.1715447272), which does not have the GTP transceivers (aka "true SerDes").

>To be clear -- We don't plan on using any of the 3rd party D-PHY front-end silicon devices specified in [XAPP894](https://github.com/chili-chips-ba/openeye-CamSI/blob/main/0.doc/Xilinx/MIPI/xapp894-d-phy-solutions.pdf). Moreover, we won't even use the passive signal conditioning networks that Xilinx is recommending. Instead, our objective is to achieve robust Signal Integrity (SI) and smooth video flow of HD and FHD quality by pulling in only on-chip resources.

That brings about multiple challenges. Compared to StereoNinja's original work, which was for LatticeSemi ECP5 FPGA, our target device does not have the built-in D-PHY receiver *(no wonder why Artix7 costs less* :innocent:*)*.

We are also doing it with meager internal-to-FPGA BRAM budget, without expending much storage. In other words, no PSRAM, SDRAM, DDR or similar external chips are called to rescue. That's a major upgrade to StereoNinja's design, where end-to-end, Camera-to-Monitor streaming was realized only for the 640x480 VGA, and only in Grayscale, far below our vibrant RG888 color palette with HD and FHD quality. This is indeed in line with NLnet's objective for this project to bring StereoNinja's pioneering work to an order of magnitude higher performance and functionality level.

>This design is simpler and more affordable, hence uniquely appealing to the makers *on the budget*. It's also paving a path for a cost-efficient openLaptop video subsystem.

On the video feed sink side, the plan is to showcase real-time streaming to:
 - **HDMI** monitor
 - **1Gbps Ethernet**, using UDP packets, rendered on a PC with [VLC Player](https://www.videolan.org)

The follow on "Webcam" project (aka Phase2) is to add **UVC** (USB2.0 Video Class) to this list. In prep for this future work, we plan to develop the following critical building blocks:
 - `Image Signal Processing (ISP)` - White Balance, Color Correction, Gamma Correction
 - `Video Compression` - JPEG. Possibly H.264 *(not needed for 1Gbps Ethernet, but compression is a must for 1024P@30Hz over USB2)*

While our design is pushing Artix7 to its limit, it is those very silicon limits that stand in the way of getting more from the given imaging sensors. Indeed, even StereoNinja's faster LatticeSemi FPGA cannot generate HDMI at 1920x1080@60Hz. 

Using Vivado tool chain, we brought this design to the point where the only factor preventing further resolution increase is the *Max Toggle Rate* that's realistically possible for Artix7 I/O structures and clock distribution networks.

## *Objective 2 - Opensource eco-system*

We intend to tap into [openXC7](https://github.com/openXC7) toolkit, including its web-based CI/CD flow. That's both for the security of images taken, and to help openXC7 attain the level of robustness found in commercial / proprietary CAE tools, Xilinx Vivado in particular. In that sense, OpenEye-CamSI is the continuation of our [TetriSaraj](https://github.com/chili-chips-ba/openXC7-TetriSaraj), which was the first openXC7 test case for a design more complex than a mere blinky. 

>Our goal is to bring to light the problems that arrive from openXC7's first exposure to top performance, cutting-edge designs. 

It is important to note that, in its current state, openXC7 is rather immature, without even the basic timing awareness, yet alone timing-driven optimizations. It has never been used for designs that push the underlying silicon to the wall. The as-is openXC7 is simply not adequate for proper timing closure.

While another project is underway, aiming to bridge this major opensource STA gap, its results won't be ready in time for our Phase1. We therefore plan for Phase2 and Phase3, hoping to try this new timing prowess, stress-testing, congesting, overwhelming it, all for the sake of making it more amenable to squeezing higher Fmax and Utilization metrics from the silicon at hand. 

The choice of our development platform is made with benefit for the greater ecosystem as the guiding factor. The boards we've selected are based on opensource [CRUVI](https://github.com/micro-FPGA/CRUVI/blob/master/docs/CRUVI_Specification.pdf) connectivity spec. Yes, they are hardly used in the dev community and don't come with support collateral we are accustomed to on the more popular hardware platforms. That's exactly why we opted for them!

Indeed, we have come across quite a few board problems and idiosyncrasies, spending a fair amount of time chasing issues that simply should not have been there. Still, since those were both opensource and EU products, this extra effort was for a good cause. We are certain that this project with help increase their visibility and boost acceptance rate amongst open makers. 

## *Play 1*
- [x] Familiarize with [Trenz](https://github.com/chili-chips-ba/openeye-CamSI/tree/main/0.doc/Trenz) hardware platform: Connectivity, clocking, power, etc. 
- [x] Bring up Blinky on Trenz
>___
- [x] Standalone HDMI Video generation: 1280x720P@60Hz  RGB888 (HD)
- [x] Standalone HDMI Video generation: 1920x1080P@30Hz RGB888 (FHD@30Hz)
- [x] Standalone HDMI Video generation: 1920x1080@60Hz  RGB888 (FHD@60Hz). Established that FHD@60Hz is not physically possible with given silicon
>___
- [x] Experiments with IMX219 configuration and resolution options
- [x] Sniffed Raspberry Pie interactions with Camera
- [x] Familiarized with *libcamera* drivers
>___  
- [x] Experiments with LVDS and termination schemes. How to do better than XAPP894, sharing insights with Lukas
>___
- [x] Test opensource 4-lane [CRUVI](https://github.com/chili-chips-ba/openeye-CamSI/tree/main/0.doc/CRUVI-camera-adapter) adapter, sharing feedback with Edmund
- [x] Full CRUVI redesign, fixing [bugs](https://github.com/chili-chips-ba/openeye-CamSI/blob/main/0.doc/CRUVI-camera-adapter/Technical-Note.TN-mipi.REV1.pdf) and expanding scope, to now include 2 and 4-lane
>___
- [x] Clock Detection logic without LP I/O
- [x] SYNC Decoding logic and Byte Alignement
- [x] Word Alignement
- [x] Header Decoding and Stripping
- [x] Acquire static image from Camera, transfer it to DualPort BRAM, then HDMI
>___
- [x] Debug crosstalk in VHDPlus CRUVI adapter, share with community
- [x] Uncover Trenz [signal inversions and inconsistencies](https://github.com/chili-chips-ba/openeye-CamSI/blob/main/0.doc/CRUVI-camera-adapter/CRUVI-Pinout-4-and-2-lanes.xlsx), sharing with Antti
>___
- [x] HD video transfer from Camera to HDMI - At first jerky and with visible frame loss
- [x] Battling issues with opensource Asynchronous FIFO, sharing insights with IP owners
>___
- [x] Debayering Logic for Color Space Conversion     
- [x] Synchronization logic for smooth video streaming w/o external storage
>___

For this first play, the hardware is used in the following config:
- Trenz Carrier Card (TEB0707-02)
- Trenz 4x5 SoM with Artix-7 FPGA (TE0711-01)
- VHDPlus HDMI + 2-lane CSI Camera adapter
- Raspberry Pi camera V2.1 module (Sony IMX219)
![system_no_background](https://github.com/chili-chips-ba/openeye-CamSI/assets/113214949/105a7569-75c5-4f2c-8f15-a408bb72cdc6)

### *HDMI output*
HDMI [source code](https://github.com/chili-chips-ba/openeye-CamSI/tree/main/1.hw/lib/ip/hdmi) supports:
- 720P@60Hz
- 1080P@30Hz
<br /> More about this and silicon limitations in [HDMI issue](https://github.com/chili-chips-ba/openeye-CamSI/issues/1#issue-2278453405).

Test pattern image 720P@60Hz:
<br /><img src="https://github.com/chili-chips-ba/openeye-CamSI/assets/113214949/c405a0d6-2086-452a-aa2a-435240055c48" width="500"><br />

### *I2C for Camera Configuration*
There are many configurable registers in the IMX219 imaging sensor. Having fully familiarized with them, both by sniffing RPi I2C transactions and running own experiments, we've settled on the 720P@60Hz. I2C Controller was developped from the scratch for loading camera registers. More on it in [I2C issue](https://github.com/chili-chips-ba/openeye-CamSI/issues/3). 

Here is an illustration of I2C waveforms and protocol used for sensor Control Plane.
<img src="https://github.com/chili-chips-ba/openeye-CamSI/assets/113214949/2b54bf12-1366-4819-8080-df7d5cf8fa20" width="700"><br />

### *Image Acquisition*
Sony [IMX219](0.doc/Sensor.2-lane.RPi2.1/IMX219PQ.Datasheet.pdf) camera sensor is used for image acquisition. It is connected to FPGA with a 15-pin flex cable (FFC), using [VHDPlus](https://vhdplus.com/docs/components/camera) CRUVI module. We strongly recommend checking our [blog](https://www.chili-chips.xyz/blog/untwisting-rpi5-camera-connectivity) for additional detail on this topic.

The VHDPlus CRUVI carries termination resistors, as shown below: 
<br /><img src="https://github.com/chili-chips-ba/openeye-CamSI/assets/113214949/31957cba-ea2c-4b42-942e-e01f8f4e62a8" width="300"><br />

Their position creates a major SI problem. That's because termination resistors must be as close to the end of the *Transmission Line* (TL) as possible. Yet, on this Trenz system, we have three connectors in the path from Camera to FPGA pins:
- Camera to CRUVI -> Location of the stock termination
- CRUVI to Carrier Card
- Carrier to FPGA SOM Card
Consequently, we had to remove these discrete parts from VHDPlus CRUVI and implement terminaton in the internal-to-FPGA resistors.

When using FPGA internal termination resistors with LVDS_25 IOSTANDARD, it is important to set the correspoding bank's VCCIO to 2.5V. Only then will their differential resistance be 100 Ohms. That's on Trenz hardware done in the following way:
- switch DIP 2 to ON state will set the IOV to 2.5V
- use Jumpers J14, J16, and J17 to connect VCCIO to IOV.
 
### *RTL Design and Block Diagram*
Once all hardware and board related problems were solved, we turned focus back to RTL. The following diagram illustrates design clocks and block structure:

<br /><img src="https://github.com/chili-chips-ba/openeye-CamSI/blob/main/0.doc/FPGA-Block-Diagram.png"><br />

Given our goal to minimize overhead and eliminate the need for LP pins (see XAPP894), RTL had to provide a clever substitute for the missing standard I/O. It did so by detecting blanking intervals between frames and using "lock" FSM with timeouts to determine whether the camera clock signal was active and stable.

For proper color rendering, the stream must be processed through a *Debayer* function. For more on it see [Debayer issue](https://github.com/chili-chips-ba/openeye-CamSI/issues/4)

### *CDC and Synchronization*
To get fluid and uneventful video, we need to pass Pixel data with Line and Frame synchronization pulses from Camera to HDMI clock and time base. To save on resources, this *Clock Domain Crossing* (CDC) and time base handoffs are accomplished using Line Buffering instead of Frame Buffering. More on this topic in [Line buffering issue](https://github.com/chili-chips-ba/openeye-CamSI/issues/2). 

It took us a bit of trial-and-error to get it right, to some extent due to CDC bug our design exposed in the fullness count of opensource AsyncFIFO. 

In the end, when everything was tuned and AsyncFIFO CDC problem factored out of the solution, the final result came to be as nice and polished as follows:

[![image (1)](https://github.com/chili-chips-ba/openeye-CamSI/assets/113214949/e333f585-1f67-4c4a-9ce0-ecf5bda4edde)](https://www.youtube.com/watch?v=BGku8TeV_AA)

## *Play 2*
- [ ] Repeat the same with 4-lane IMX283
- [ ] Step-by-step introduce essential ISP elements:
> [ ] Manual Exposure Control
> [ ] Dead Pixel Management
> [x] Debayer
- [ ] Implement another (lower) resolution of our choice

## *Play 3*
- [ ] Add 1Gbps interface as another video sink, rendering it on remote PC via VLC
- [x] Document implementation in block diagram and repo

## *Play 4*
- [ ] Port final design from Vivado to openXC7
- [ ] Simulate it with Verilator and cocoTB, in CI/CD system
- [ ] Document scripts and flows used in this process

## *Play 5*
- [ ] Add Webcam ISP functions and JPEG video compression
      
## *Acknowledgements*
We are grateful to:
 - NLnet Foundation's sponsorship for giving us an opportunity to work on this fresh new take at FPGA video processing
 - [StereoNinja](https://github.com/StereoNinja/StereoNinjaFPGA), whose project has set the stage for this major performance and functionality expansion

> ![logo_nlnet](https://github.com/chili-chips-ba/openeye/assets/67533663/18e7db5c-8c52-406b-a58e-8860caa327c2)
> <img width="115" alt="NGI-Entrust-Logo" src="https://github.com/chili-chips-ba/openeye-CamSI/assets/67533663/013684f5-d530-42ab-807d-b4afd34c1522">

**<h3>  End of Document </h3>** 
