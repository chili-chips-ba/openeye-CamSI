# OpenEye-CamSI 
## * WORK IN PROGRESS * UNDER CONSTRUCTION *
> WHILE THIS NOTICE IS PRESENT, DON'T EXPECT DESIGN, SIM, OR ANY OTHER FILE IN HERE 2BE DOIN' WHAT IT'S SAYIN'

Our OpenEye-CamSI is about delivering a truly open-source (hence accessible and trustworthy) image and video pipeline for the hi-res Sony sensors. Our goal is to do it with a mature and affordable Artix7 FPGA, without resorting to the Multi-Gigabit Transceivers (MGT, aka "full/analog SerDes"). Instead, we intend to implement it with a much simpler <b>IOSERDES</b> primitive, which is available in all IOBs, and already supported by open-source implementation tools for Xilinx devices. 

As a matter of fact, we intend to utilize openXC7 (https://github.com/openXC7) toolkit, including its web-based CI/CD flow that's currently in development. That's both for the security of images taken, and to help openXC7 attain the level of robustness found in the commercial / proprietary CAE tools. In that sense, OpenEye-CamSI is the continuation of our TetriSaraj (https://github.com/chili-chips-ba/openXC7-TetriSaraj), which was the first openXC7 test case for a design more complex than a mere blinky. 

OpenEye-CamSI is also the continuation of <i>StereoNinjaFPGA</i> development track, but now aiming for higher performance, and targeting Xilinx instead of Lattice. The latter is the most popular open-source FPGA family, ubiquitous to the point of monopoly. Yet, the monopoly is against the spirit of openness. Moreover, being so well documented and supported in the open-source circles, Lattice does not entice the same fun nor challenge to work with. We therefore intend to bring some balance to the Lattice-dominated open-source FPGA world 😂.

Our stated deliverable is to:
 - <b>showcase real-time video streaming through FPGA, from Camera to VLC, via UDP Ethernet packets</b>.

The VLC (https://www.videolan.org) is to be hosted on a PC with standard LCD monitor. We intend to demo it at Maker Faire Wien + Sarajevo 2024, and elsewhere.                

   ![OpenEye](https://github.com/chili-chips-ba/openeye/assets/67533663/07cb0f47-c9c7-483e-a028-0066342f5023)

Essentially, the plan and objective for the first phase is to <b>resolve the fundamental challenges of working with IOSERDES and openXC7 at higher frequencies</b>. 

It is important to emphasize that, in its current state, our tool is still rather immature, without even the basic timing awareness, yet alone timing-driven optimizations -- <b>As-is openXC7 is simply not adequate for proper timing closure</b>. While another project is underway aiming to bridge this major STA gap, this enhancement won't be ready in time for our Phase1. 

We therefore have Phase2 and, as needed, Phase3 in the plans, looking to be the first to try this new timing prowess in open-source tools for Xilinx FPGAs, using it to squeeze most Fmax from our target device and camera chips. We may at that time introduce some image processing, such as video compression, to allow passing higher-rez content through the same old 1Gbps Ethernet link. 

To create the starter design for our target boards will also require a fair amount of work. The boards we've selected for the project are hardly used in the open-source community, and don't come with support collateral that developers are accustomed to. Still, since they are an EU product, this extra effort is for a good cause, to increase their visibility and introduce them to the open makers.
      ![our-board](https://github.com/chili-chips-ba/openeye/assets/67533663/12fe4ac5-299f-4040-aa67-dc022124908a)


**<h3> Acknowledgements </h3>**
We are grateful to:
 - NLnet Foundation's sponsorship (https://nlnet.nl), which opened the gates for working on this novel gateware for video security and openXC7 enhancements

    ![logo_nlnet](https://github.com/chili-chips-ba/openeye/assets/67533663/18e7db5c-8c52-406b-a58e-8860caa327c2)

    ![NGI0Entrust_tag](https://github.com/chili-chips-ba/openeye/assets/67533663/19e919e3-6888-43e8-88b3-0a2ff447a80b)

   
 - StereoNinjaFPGA (https://github.com/StereoNinja/StereoNinjaFPGA), whose pioneering work has set the stage for this major expansion

 
**<h3> Theory of Operation with Block Diagram </h3>**
WIP, stay tuned... 


**<h3>  End of Document </h3>** 
