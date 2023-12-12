# OpenEye
![OpenEye](https://github.com/chili-chips-ba/openeye/assets/67533663/2cb7c969-9ff4-4888-83ed-491865930164)

Our OpenEye is about making a truly open-source (hence accessible and trustworthy), <b>C</b>amera <b>S</b>erial <b>I</b>nterface (CSI) for a hi-res image sensor from Sony. Our goal is to do it with a mature and affordable Series7 (Artix7) FPGA, without resorting to the Multi-Gigabit Transceivers (MGT, aka "full/analog SerDes"). Instead, we intend to implement it with a much simpler <b>IOSERDES</b> primitive, which is available in all IOBs, and already supported by open-source implementation tools for Xilinx devices. 

As a matter of fact, we intend to utilize openXC7 (https://github.com/openXC7) toolkit, including its web-based CI/CD flow that's currently in development. That's not only for the ultimate security of images taken by our CSI interface, but also to help openXC7 attain the level of robustness found in the commercial / proprietary CAE. In that sense, OpenEye is a continuation of <i>TetriSaraj</i> (https://github.com/chili-chips-ba/openXC7-TetriSaraj), which was the first openXC7 test case for a design more complex than a mere blinky. 

OpenEye is also the continuation of <i>StereoNinjaFPGA</i> development track, now aiming for higher performance, and also targeting Xilinx instead of Lattice. The latter is the most popular open-source FPGA family, ubiquitous to the point of monopoly. Yet, the monopoly is against the spirit of openness. Moreover, being so well documented and supported in open-source circles, Lattice does not entice the same fun nor challenge to work with. We therefore intend to bring some balance to the Lattice-dominated open-source FPGA world :-)

 - <b>Our first-phase objective is to showcase real-time video streaming through FPGA, from Camera to VLC</b> (https://www.videolan.org)<b>, via UDP Ethernet packets</b>.

The VLC is to be hosted on a PC with standard LCD monitor. Our goal is to demo it at Maker Faire Wien + Sarajevo 2024, and elsewhere.

On the technical side, the plan for the first phase of the project is to resolve the fundamental challenges of working with IOSERDES and openXC7 at higher frequencies. It is important to emphasize that, in its current state, our tool is still rather immature, without even the basic timing awareness, yet alone timing-driven optimizations. Besides, just to create the starter design framework on our target boards will require a good amount of learning effort. The boards we've selected for the project are rather unpopular, hardly used in the open-source community, and don't come with support collateral that developers are accustomed to. Still, since they are an EU product, this extra work is for a good cause, to increase their visibility and introduce them to the open makers.

Back to the point of openXC7 inadequacy for proper timing closure. Let's note that another project is underway with goal to tackle this major STA gap. However, it won't be nearly ready in the planned completion timeframe of our phase 1. We therefore intend to pursue phase 2 and, as needed, phase 3, looking to be the first to try this new timing prowess in open-source Xilinx tools, squeezing the ultimate performance from our image sensor with it. We may also introduce some image processing complexities at that time, such as video compression, to allow passing higher-res content through the same old 1Gbps Ethernet link. 

**<h3> Acknowledgement </h3>**
We are grateful to:
 - NLnet Foundation's sponsorship (https://nlnet.nl), which opened the gates for working on this novel gateware for video security and openXC7 enhancements
 - StereoNinjaFPGA (https://github.com/StereoNinja/StereoNinjaFPGA), whose pioneering work has set the stage for this major expansion
![logo_nlnet](https://github.com/chili-chips-ba/openeye/assets/67533663/59b53783-dd21-4575-bd4c-479c340b500d)
 
**<h3> Theory of Operation with Block Diagram </h3>**
WIP, stay tuned... 

**<h3>  End of Document </h3>** 
