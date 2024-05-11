# openEye-CamSI (Phase1)
## *Objective 1 - Performance and Functional upgrade*
The goals of this development activity are to deliver a truly opensource, therefore accessible and trustworthy, video pipeline for three popular hi-rez imaging sensors:
 - `2-lane RPiV2.1`, based on Sony IMX219, in `1280x720P@60Hz` RGB888 mode (aka `HD`)
 - `4-lane OneInchEye`, based on Sony IMX283, in `1920x1080P@30Hz` RGB888 mode (aka `FHD`)
 - `2-lane OV2740`, in a TBD "Webcam" setup for Lukas Henkel's [openLaptop](https://resources.altium.com/p/open-source-laptop-part-one) project

The intent is to do it with mature and affordable <b>Artix7 FPGA</b>, by using its <b>IBUFDS, IDELAY, ISERDES</b> primitives for the camera front-end. These primitives are available in all IOBs, hence ubiquitous and relatively easy to work with, and already supported by opensource PNR tool for Xilinx Series7. This also leaves the path open for future reduction of total solution cost by migrating to [Spartan7](https://www.xilinx.com/video/fpga/spartan-7-technical-overview.html?_ga=2.252819658.271111311.1715447274-1421952438.1715447272), which does not have the GTP transceivers (aka "true SerDes").

>To be clear -- We don't plan on using any of the 3rd party D-PHY front-end silicon devices specified in [XAPP894](https://github.com/chili-chips-ba/openeye-CamSI/blob/main/0.doc/Xilinx/MIPI/xapp894-d-phy-solutions.pdf). Moreover, we won't even use the passive signal conditioning networks that Xilinx has recommended. Instead, our objective is to achieve robust Signal Integrity (SI) and smooth video flow for both HD and FHD quality levels by pulling in **only on-chip resources**.

That brings about multiple challenges. Compared to StereoNinja's original work, which was done with LatticeSemi ECP5 FPGA, our target device does not have the built-in support for D-PHY receiver *(no wonder why Artix7 costs less* :innocent:*)*.

We are also doing it without expending much storage, staying within meager internal-to-FPGA BRAM budget. In other words, no PSRAM, no SDRAM, no DDR or similar external chips are called to rescue to support our smooth HD/FHD video flow. That's a major upgrade to StereoNinja's design, where end-to-end, Camera-to-Monitor video flow was established only for the 640x480 VGA quality, and only in Grayscale, far below our vibrant RG888 color palette. This goes hand-in-hand with NLnet plan for this project to take StereoNinja's pioneering work to an order of magnitude higher performance and functionality level.

>All this makes our solution simpler and more affordable, hence uniquely appealing to the makers *on the budget*, while also paving the path for openLaptop video subsystem.

<img src="https://github.com/chili-chips-ba/openeye/assets/67533663/07cb0f47-c9c7-483e-a028-0066342f5023" width="250">

On the sink side of Camera video feed, we intend to showcase real-time video streaming to:
 - **HDMI** monitor
 - **1Gbps Ethernet**, using UDP packets, rendered on a PC with [VLC Player](https://www.videolan.org)

The follow on "Webcam" (aka Phase2) project is to add **UVC** (USB2.0 Video Class) to this list. In prep for this future work, we are to develop the following critical building blocks:
 - `Image Signal Processing (ISP)` - White Balance, Color Correction, Gamma Correction
 - `Video Compression` - JPEG. Possibly also H.264 *(not needed for 1Gbps Ethernet. Compression is mandatory for transmitting 1024P@30fps over USB2)*.

Let's note that, while our design is pushing Artix7 to the limit, it is those very silicon limits that don't allow us to use the given imaging sensors to their fullest. Indeed, even StereoNinja's more capable LatticeSemi FPGA cannot generate HDMI at 1920x1080@60Hz. Using Vivado tool chain, we brought this design to the point where the Max Toggle Rate realistically achievable with Artix7 I/O structures and clock distribution network is the only factor preventing us from getting more bits, more resolution, more throughput from it.

## *Objective 2 - Opensource eco-system*

We intend to tap into [openXC7](https://github.com/openXC7">openXC7) toolkit, including its web-based CI/CD flow. That's both for the security of images taken, and to help openXC7 attain the level of robustness found in commercial / proprietary CAE tools, Xilinx Vivado in particular. In that sense, OpenEye-CamSI is the continuation of our [TetriSaraj](https://github.com/chili-chips-ba/openXC7-TetriSaraj), which was the first openXC7 test case for a design more complex than a mere blinky. 

>Our goal is to uncover and resolve issues of using openXC7 for IOSERDES at high frequencies and cutting-edge designs. 

It is important to note that, in its current state, openXC7 is rather immature, without even the basic timing awareness, yet alone timing-driven optimizations. It has never been used for designs that push the underlying silicon to the edge. The as-is openXC7 is simply not adequate for proper timing closure.

While another project is underway, aiming to bridge this major STA gap with opensource tools, it won't be ready in time for our Phase1. We therefore plan for Phase2 and Phase3, looking to be the first to try this new timing prowess in the open PNR for Xilinx FPGAs, aiming to stress-test it, congest it, overwhelm it, all for the sake of making it more amenable to squeezing the most possible Fmax and Utilization figures from the silicon at hand. 

The choice of our development platform is made with eco-system in mind. The boards we've selected are based on opensource [CRUVI](https://github.com/micro-FPGA/CRUVI/blob/master/docs/CRUVI_Specification.pdf) connectivity system. But, they are hardly used in the dev community, and don't come with support collateral we are accustomed to with more popular hardware platforms. 

Indeed, we have uncovered quite a few board problems and idiosyncrasies, spending a fair amount of time chasing issues that simply should not have been there. Still, since those were both opensource and EU products, this extra effort was for a good cause. We are certain that our feedback and this project with help increase their visibility, boosting their acceptance and rate of use amongst open makers. 

## *Play 1*
Done:
- [x] Familiarize with Trenz hardware platform: Connectivity, Clocking, Power, etc. 
- [x] Bring up Blinky on Trenz
- [x] Standalone HDMI Video generation: 1280x720P@60Hz RGB888 (HD)
- [x] Standalone HDMI Video generation: 1920x1080P@30Hz RGB888 (FHD)
- [x] Standalone HDMI Video generation: 1920x1080@60Hz RGB888 - **Established that's not physically possible with given silicon**
- [x] Experiments with IMX219 configuration and resolution options
- [x] Experiments with Termination Schemes - `How to do better than XAPP894`, sharing insights with Lukas
- [x] Test opensource 4-lane CRUVI adapter, sharing feedback with Edmund
- [x] Redesign the 4-lane CRUVI, fixing bugs and expanding functionality, now allowing both 2 and 4-lane
- [x] Uncover Crosstalk issues in VHDPlus CRUVI adapter, sharing findings with community
- [x] Uncover Trenz signal inversions and inconsistencies, sharing insights with Antti
- [x] Acquire HD video from camera sensor and display it via HDMI - Jerky and with Frame Loss
- [x] Battle issues with opensource asynchronous FIFO, sharing insights with IP owners
      
- [x] **`Implement elegant and smooth end-to-end HD video streaming w/o external storage`**

For this first play, the hardware is used in the following config:
- Trenz Carrier Card (TEB0707-02)
- Trenz 4x5 SoM with Artix-7 FPGA (TE0711-01)
- VHDPlus HDMI + 2-lane CSI Camera adapter
- Raspberry Pi camera V2.1 module (Sony IMX219)
<br />![system_no_background](https://github.com/chili-chips-ba/openeye-CamSI/assets/113214949/105a7569-75c5-4f2c-8f15-a408bb72cdc6)


### *HDMI output*
HDMI [source code](https://github.com/chili-chips-ba/openeye-CamSI/tree/main/1.hw/lib/ip/hdmi) supports:
- 720P@60Hz
- 1080P@30Hz
<br /> More about HDMI options and limitations in the [HDMI issue](https://github.com/chili-chips-ba/openeye-CamSI/issues/1#issue-2278453405).

Test pattern image 720P@60Hz:
<br /><img src="https://github.com/chili-chips-ba/openeye-CamSI/assets/113214949/c405a0d6-2086-452a-aa2a-435240055c48" width="500"><br />

### *Camera Configuration*
There are plenty of configurable registers in the IMX219 imaging sensor. Having fully familiarize with them, both by sniffing RPi I2C transactions and running own experiments, we've settled on 720P@60Hz. In order to load camera registers, I2C comunication protocol was written. More on it in [I2C issue](https://github.com/chili-chips-ba/openeye-CamSI/issues/3). Next image shows some data beenig written on the camera sensor.
<img src="https://github.com/chili-chips-ba/openeye-CamSI/assets/113214949/2b54bf12-1366-4819-8080-df7d5cf8fa20" width="700"><br />

### *Image acquisition*
Sony [IMX219](0.doc/Sensor.2-lane.RPi2.1/IMX219PQ.Datasheet.pdf) camera sensor is used for Image acquisition. Camera sensor is connected with FPGA with a flex cable through [VHDPlus](https://vhdplus.com/docs/components/camera) CRUVI module. 

On the VHDPlus CRUVI module, there are termination resistors shown in the image: 
<br /><img src="https://github.com/chili-chips-ba/openeye-CamSI/assets/113214949/31957cba-ea2c-4b42-942e-e01f8f4e62a8" width="300"> <br /> 

Termination resistors circled in the image pose a major problem to the signal integration. This is because termination resistors are supposed to be as close to the end of the line as possible, but in our case, there are two connections between termination resistors and IO pins of FPGA (the first one is the connection between VHDPlus CRUVI Module and CRUVI connector on the carrier board, and again between CRVU connection with carrier board and FPGA SOM.). That is why we desoldered termination resistors on the VHDPlus CRUVI module and instead used internal termination resistors in the FPGA.

When using an FPGA internal termination resistor on LVDS_25 IOSTANDARD, it is important to set the voltage of the VCCIO bank to 2.5V to ensure that the resistance of termination resistors is 100 Ohm. We do that by switching DIP 2 to ON state to set IOV = 2.5V and using Jumpers J14, J16, and J17 to connect VCCIO to IOV.
 
### *RTL Design and Block Diagram*
After all, hardware-related problems are solved, RTL design is followed. For that, there is a block diagram of the MIPI CSI2 protocol implemented in this work:

<br /><img src="https://github.com/chili-chips-ba/openeye-CamSI/blob/main/0.doc/FPGA-Block-Diagram.png"><br />

There are a few difficulties/twists in the RTL design process because the VHDPlus CRUVI module has only differential input pins, not a single LP input pin. This means that the detection of blanking parts between frames has to be done by checking whether the clock signal from the camera is active and stable. More about this issue on **add issue**

Before displaying an image on the monitor/display, it has to go through a debayer block to display colors as they are. See more in the [debayer issue](https://github.com/chili-chips-ba/openeye-CamSI/issues/4)

### *CDC and Synchronization*
To see the image on the monitor, everything previously mentioned has to work together perfectly. On top of that processed data from the FPGA has to be in the the sync with HDMI module written in the beginning. For that, we use line buffering instead of frame buffering. This posed some difficulties, which you can read more about in the [Line buffering issue](https://github.com/chili-chips-ba/openeye-CamSI/issues/2). Nevertheless, after everything is polished up the final result is visible in the video:

[![image (1)](https://github.com/chili-chips-ba/openeye-CamSI/assets/113214949/e333f585-1f67-4c4a-9ce0-ecf5bda4edde)](https://www.youtube.com/watch?v=BGku8TeV_AA)

**<h3> Acknowledgements </h3>**
We are grateful to:
 - NLnet Foundation's sponsorship for giving us an opportunity to work on this novel, video-centric designware in SystemVerilog RTL
 - [StereoNinja](https://github.com/StereoNinja/StereoNinjaFPGA), whose project has set the stage for this major performance and functionality expansion

   
> ![logo_nlnet](https://github.com/chili-chips-ba/openeye/assets/67533663/18e7db5c-8c52-406b-a58e-8860caa327c2)
> ![NGI0Entrust_tag](https://github.com/chili-chips-ba/openeye/assets/67533663/19e919e3-6888-43e8-88b3-0a2ff447a80b)
 
**<h3>  End of Document </h3>** 
