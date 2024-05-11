# openEye-CamSI - Phase1
## *Project Objectives - Functional content*
This development is about delivering a truly open-source, therefore accessible and trustworthy, image and video pipeline for three representative hi-rez imaging sensors:
 - <b>2-lane RPiV2.1</b>, based on Sony IMX219, in <b>1280x720P@60Hz</b> RGB888 mode
 - <b>4-lane OneInchEye</b>, based on Sony IMX283, in <b>1920x1080P@30Hz</b> RGB888 mode
 - <b>2-lane OV2740</b>, in a TBD "Webcam" setup

The goal is to do it with mature and affordable <b>Artix7 FPGAs</b>, using their <b>IBUFDS, IDELAY, ISERDES</b> primitives for the camera front-end. These primitives are available in all IOBs, hence ubiquitous and easy to work with, while at the same time already supported by open-source implementation tools for Xilinx Series7. It is worth stressing here that we don't intend to use any of the 3rd party DPHY front-end silicon devices specified in <a href="https://github.com/chili-chips-ba/openeye-CamSI/blob/main/0.doc/Xilinx/MIPI/xapp894-d-phy-solutions.pdf">XAPP894</a>. Moreover, we shall not use even the passive signal conditioning networks that the XAPP894 is recommending. Instead, our objective is to achieve robust <i>Signal Integrity</i> (SI) and reliable hi-rez camera operation by pulling in only resources available in this entry-level family.

>><b>This makes our solution simpler and more affordable, hence uniquely appealing to the makers <i>"on the budget"</i>!</b>. 
<img src="https://github.com/chili-chips-ba/openeye/assets/67533663/07cb0f47-c9c7-483e-a028-0066342f5023" width="250">

Our objectives are to showcase real-time video streaming through FPGA, from Camera to:
 - <b>HDMI monitor</b>
 - <b>VLC, via 1Gbps Ethernet link, using UDP packets</b>

In prep for the follow on "Webcam" project, which will add to this list the <b>UVC</b> (USB2.0 Video Class) destination, we also intend to work out Webcam critical building blocks:
 - <b>Image Signal Processing (ISP)</b>: White Balance, Color Correction, Gamma Correction
 - <b>Video Compression</b>: JPEG. Possibly also H.264. While not needed for the 1Gbps Ethernet, the compression is mandatory for transmitting 1024P@30fps over USB2

## *Project Objectives - Opensource eco-system*
We intend to tap into <a href="https://github.com/openXC7">openXC7</a> toolkit, including its web-based CI/CD flow. That's both for the security of images taken, and to help openXC7 attain the level of robustness found in the commercial / proprietary CAE tools. In that sense, <i>OpenEye-CamSI</i> is the continuation of our <a href="https://github.com/chili-chips-ba/openXC7-TetriSaraj">TetriSaraj</a>, which was the first openXC7 test case for a design more complex than a mere blinky. 

>>Our goal is to resolve the fundamental challenges of working with IOSERDES and openXC7 at high frequencies. 

It is important to emphasize that, in its current state, openXC7 is still rather immature, without even the basic timing awareness, yet alone timing-driven optimizations
>>The as-is openXC7 is simply not adequate for proper timing closure

While another project is underway, aiming to bridge this major STA gap, it won't be ready in time for our Phase1. 

We therefore have Phase2 and, as needed, Phase3 in the plans, looking to be the first to try this new timing prowess in open-source PNR tools for Xilinx FPGAs, using it to squeeze most Fmax from our target device and camera chips. 

The choice of our development boards was also made with community and eco-system in mind. While the boards we've selected are based on the opensource <a href="https://github.com/micro-FPGA/CRUVI/blob/master/docs/CRUVI_Specification.pdf">CRUVI</a> connectorization system, they are hardly used in the dev community, and don't come with support collateral we are accustomed to on more popular hardware platform. 

Indeed, we have uncovered quite a few board problems and idiosyncrasies, spending a fair amount of time chasing issues that simply should not have been there. Still, since those were both the EU products and open-source, this extra effort was for a good cause. We are sure our feedback and work with help increase their visibility and introduce them to open makers. 

## *Objective 1*
In this first delivery, we are using the system shown in the image:

![system_no_background](https://github.com/chili-chips-ba/openeye-CamSI/assets/113214949/105a7569-75c5-4f2c-8f15-a408bb72cdc6)

It consists of:
- Trenz Carrier Card (TEB0707-02)
- Trenz 4x5 SoM with Artix-7 FPGA (TE0711-01)
- VHDPlus HDMI + 2-lane CSI Camera adapter
- Raspberry Pi camera V2.1 module (Sony IMX219)

The goal is to acquire an video from the camera sensor and display it through HDMI output on the monitor.

### *HDMI output*
HDMI [source code](https://github.com/chili-chips-ba/openeye-CamSI/tree/main/1.hw/lib/ip/hdmi) supports:
- 720p@60Hz
- 1080p@30Hz
<br /> More about HDMI options and limitations in the [HDMI issue](https://github.com/chili-chips-ba/openeye-CamSI/issues/1#issue-2278453405).

Test pattern image 720p@60Hz:
<br /><img src="https://github.com/chili-chips-ba/openeye-CamSI/assets/113214949/c405a0d6-2086-452a-aa2a-435240055c48" width="500"><br />

### *Camera Configuration*
There are plenty of configurabile registers on the IMX219 camera sensor. Camera is configured to output 720p@60Hz. In order to configure registers of the camera sensor, I2C comunication protcol was written. Xou can reed more about I2C protocol on [I2C issue](https://github.com/chili-chips-ba/openeye-CamSI/issues/3). Next image shows some data beenig written on the camera sensor.
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
 - NLnet Foundation's sponsorship for giving us an opportunity to work on this novel, video-centric designware
 - [StereoNinja](https://github.com/StereoNinja/StereoNinjaFPGA), whose pioneering work has set the stage for this major performance and functionality expansion

   
> ![logo_nlnet](https://github.com/chili-chips-ba/openeye/assets/67533663/18e7db5c-8c52-406b-a58e-8860caa327c2)
> ![NGI0Entrust_tag](https://github.com/chili-chips-ba/openeye/assets/67533663/19e919e3-6888-43e8-88b3-0a2ff447a80b)
 
**<h3>  End of Document </h3>** 
