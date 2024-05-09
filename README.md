# openCologne
## * WORK IN PROGRESS * UNDER CONSTRUCTION *
> WHILE THIS NOTICE IS PRESENT, DON'T EXPECT DESIGN, SIM, OR ANY OTHER FILE IN HERE 2BE DOIN' WHAT IT'S SAYIN'

Our OpenEye-CamSI is about delivering a truly open-source (hence accessible and trustworthy) image and video pipeline for the hi-res Sony sensors. Our goal is to do it with a mature and affordable Artix7 FPGA, without resorting to the Multi-Gigabit Transceivers (MGT, aka "full/analog SerDes"). Instead, we intend to implement it with a much simpler <b>IOSERDES</b> primitive, which is available in all IOBs, and already supported by open-source implementation tools for Xilinx devices. 

As a matter of fact, we intend to utilize openXC7 (https://github.com/openXC7) toolkit, including its web-based CI/CD flow that's currently in development. That's both for the security of images taken, and to help openXC7 attain the level of robustness found in the commercial / proprietary CAE tools. In that sense, OpenEye-CamSI is the continuation of our TetriSaraj (https://github.com/chili-chips-ba/openXC7-TetriSaraj), which was the first openXC7 test case for a design more complex than a mere blinky. 

Our stated deliverable is to:
 - <b>showcase real-time video streaming through FPGA, from Camera to VLC, via UDP Ethernet packets</b>.             

<img src="https://github.com/chili-chips-ba/openeye/assets/67533663/07cb0f47-c9c7-483e-a028-0066342f5023" width="250">
<br />Essentially, the plan and objective for the first phase is to <b>resolve the fundamental challenges of working with IOSERDES and openXC7 at higher frequencies</b>. 

It is important to emphasize that, in its current state, our tool is still rather immature, without even the basic timing awareness, yet alone timing-driven optimizations -- <b>As-is openXC7 is simply not adequate for proper timing closure</b>. While another project is underway, aiming to bridge this major STA gap, it won't be ready in time for our Phase1. 

We therefore have Phase2 and, as needed, Phase3 in the plans, looking to be the first to try this new timing prowess in open-source tools for Xilinx FPGAs, using it to squeeze most Fmax from our target device and camera chips. We may at that time introduce some image processing, such as video compression, to allow passing higher-rez content through the same old 1Gbps Ethernet link. 

To create the starter design for our target boards will also require a fair amount of work. The boards we've selected for the project are hardly used in the open-source community, and don't come with support collateral that developers are accustomed to. Still, since they are an EU product, this extra effort is for a good cause, to increase their visibility and introduce them to the open makers.

## *First work package*
In this first work package, we are using the system shown in the image:

![system_no_background](https://github.com/chili-chips-ba/openeye-CamSI/assets/113214949/105a7569-75c5-4f2c-8f15-a408bb72cdc6)

In the image, there is a Trenz carrier board, a Trenz 4x5 SoM with Artix-7 FPGA and WHDPlus HDMI + CSI Camera adapter, and lastly, there is a Raspberry Pi camera V2 module.

The main goal is to acquire an image/video from the camera sensor on the Raspberry Pi camera (Sony IMX219) and display the captured image through HDMI output on the monitor.

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
Sony [IMX219](0.doc/Sensor.2-lane.RPi2.1/IMX219PQ.Datasheet.pdf) camera sensor is used for Image acquisition. Camera sensor is connected with FPGA with a flex cable through [VHDPlus](https://vhdplus.com/docs/components/camera/) CRUVI module. 

On the VHDPlus CRUVI module, there are termination resistors shown in the image: 
<br /><img src="https://github.com/chili-chips-ba/openeye-CamSI/assets/113214949/31957cba-ea2c-4b42-942e-e01f8f4e62a8" width="300"> <br /> 

Termination resistors circled in the image pose a major problem to the signal integration. This is because termination resistors are supposed to be as close to the end of the line as possible, but in our case, there are two connections between termination resistors and IO pins of FPGA (the first one is the connection between VHDPlus CRUVI Module and CRUVI connector on the carrier board, and again between CRVU connection with carrier board and FPGA SOM.). That is why we desoldered termination resistors on the VHDPlus CRUVI module and instead used internal termination resistors in the FPGA.

When using an FPGA internal termination resistor on LVDS_25 IOSTANDARD, it is important to set the voltage of the VCCIO bank to 2.5V to ensure that the resistance of termination resistors is 100 Ohm. We do that by switching DIP 2 to ON state to set IOV = 2.5V and using Jumpers J14, J16, and J17 to connect VCCIO to IOV.
 
<br /> After all, hardware-related problems are solved, RTL design is followed. For that, there is a block diagram of the MIPI CSI2 protocol implemented in this work:

<br /><img src="https://github.com/chili-chips-ba/openeye-CamSI/blob/main/0.doc/FPGA-Block-Diagram.png"><br />

There are a few difficulties/twists in the RTL design process because the VHDPlus CRUVI module has only differential input pins, not a single LP input pin. This means that the detection of blanking parts between frames has to be done by checking whether the clock signal from the camera is active and stable. More about this issue on **add issue**

Before displaying an image on the monitor/display, it has to go through a debayer block to display colors as they are. See more in the [debayer issue](https://github.com/chili-chips-ba/openeye-CamSI/issues/4)

To see the image on the monitor, everything previously mentioned has to work together perfectly. On top of that processed data from the FPGA has to be in the the sync with HDMI module written in the beginning. For that, we use line buffering instead of frame buffering. This posed some difficulties, which you can read more about in the [Line buffering issue](https://github.com/chili-chips-ba/openeye-CamSI/issues/2). Nevertheless, after everything is polished up the final result is visible in the video:

[![image (1)](https://github.com/chili-chips-ba/openeye-CamSI/assets/113214949/e333f585-1f67-4c4a-9ce0-ecf5bda4edde)](https://www.youtube.com/watch?v=BGku8TeV_AA)


**<h3> Acknowledgements </h3>**
We are grateful to:
 - NLnet Foundation's sponsorship (https://nlnet.nl), which opened the gates for working on this novel gateware for video security and openXC7 enhancements

    ![logo_nlnet](https://github.com/chili-chips-ba/openeye/assets/67533663/18e7db5c-8c52-406b-a58e-8860caa327c2)

    ![NGI0Entrust_tag](https://github.com/chili-chips-ba/openeye/assets/67533663/19e919e3-6888-43e8-88b3-0a2ff447a80b)

   
 - StereoNinjaFPGA (https://github.com/StereoNinja/StereoNinjaFPGA), whose pioneering work has set the stage for this major expansion

 
**<h3> Theory of Operation with Block Diagram </h3>**
WIP, stay tuned... 


**<h3>  End of Document </h3>** 
