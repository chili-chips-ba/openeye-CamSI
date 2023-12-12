# openXC7-TetriSaraj
This is the very first, independent and unbiased attempt to use <i>openXC7</i> tool flow for a real-life FPGA design. All its earlier uses and example projects were created by the insiders, who knew ahead of time about what pitfalls to avoid. And yes, we have uncovered issues along the way, duly reported them, and kept marching along, at times even resorting to hacks to make it work. 

Most importantly, we did not even know that we were the Alpha testers, and learned it only when everything was already done &#128514;. 

The compute platform used for this work was <i>Windows Subsystem for Linux (WSL)</i> as opposed to native Linux/Ubuntu. The decision to go with WSL came from our intent to maximize project accessibility, not leaving out even the middle school youngsters, who typically don't have native Linux machines.

<img width="762" alt="TetriSaraj" src="https://github.com/chili-chips-ba/openXC7-TetriSaraj/assets/67533663/1eacb310-5b40-4684-9328-2e06580bd204">
 
**<h3> NAND-2-Tetris Acknowledgement </h3>**
While we did not use any of https://www.nand2tetris.org materials, our project can be viewed as a bootstrapped, super-compressed variant of it. We therefore warmly recommend this superb step-by-step guide /*put together by Shimon Schocken and Noam Nisan*/ on how to build functioning Tetris starting from the mere NAND gates.

If you're starting without prior knowledge of electronics, digital logic circuits, computers or programming, then JMP to the link above, else CONT.

**<h3> Tetris Recap </h3>**

Even though most of us know what Tetris is and how to play it, we'll first briefly explain its logic and rules.

Tetris is a combinatorial game where a player maneuvers differently-shaped pieces (aka <i>'tetrominoes'</i>) as they descend onto the playing field. The objective is to complete the lines by filling them with <i>tetrominoes</i>. When a line is fully filled, it gets automatically cleared, and the player earns points. The player can then utilize the cleared space to continue the game. It's <i>Game Over</i> when the lines with gaps (thus not cleared) reach the top of the playing field. The longer a player can delay this outcome, the higher his/her score. In the multiplayer games, the players compete to outlast their opponent(s). 

![Typical_Tetris_Game](https://github.com/chili-chips-ba/openXC7-TetriSaraj/assets/113244867/bbd94950-8c0d-4dce-a1da-66681715f41d)

**<h3> TetriSaraj Intro </h3>**

In our <i>TetriSaraj</i>, the pieces (<i>tetrominoes</i>) are entering the field from the sides, in the random fashion, so leaving less time to think about approach and strategy. While our pieces are <i>"falling"</i> horizontally from both sides, one at the time, the logic is otherwise the same as ordinary Tetris. The objective is to complete vertical lines by filling them with <i>tetrominoes</i>.

  <img width="408" alt="tetrisaraj" src="https://github.com/chili-chips-ba/openXC7-TetriSaraj/assets/113244867/ceb74ee9-2ee2-461a-ab3f-e279f34bf71e">

**<h3> Development Methodology </h3>**

There are two main parts of our solution: HW and SW. To save time, and in the spirit of FPGA parallism, we've worked on both in parallel. 

- The first development track was the construction of Basys3 SOC with soft-core CPU, complemented with our special, simple, yet capable <i>Mega-Character (MC) Video Controller</i> for game visualization. This work was undertaken by the HW (Verilog RTL) group within our team.

- At the same time, the SW group was working out the game algorithm in the comfortable <i>WinOS PC Visual Studio</i> setting, where the hi-res graphic output was emulated on a low-res terminal, as illustrated in the image below:

  ![image](https://github.com/chili-chips-ba/openXC7-TetriSaraj/assets/113244867/146a804c-dc82-46a3-8c0f-a984b1f0f3dc)

When the logic of our game was fully worked out, we've switched to <b>integration</b> activities. 
>Integration in this context is the <b>merge of SW and HW track</b>. 

**<h4> Simulation </h4>**

Other than this terminal emulation of the Game Logic, we opted out of logic simulation. Even the hardware team found it more productive to validate the Video Controller directly on the board, using test patterns much simpler than the final game, which they wrote in 'C', indepedently from the software team. 

The hard-core digital design puritans may declare it as a bad practice, and may even bring Formal into the fray. We would counter them with: <i>Welcome to the world of full field programmability!</i> Joking aside, it was the nature and low complexity of the problem at hand that allowed us to take this shortcut:
- CPU was already proven, through both dynamic and static methods, taken as-is from the libary
- Our brand new Video Controller design was a straight datapath, without large inter-connected FSMs, and without significant exceptions.

**<h4> Code Porting </h4>**

Porting from WinOS and to the <b>bare-metal RISC-V</b> was a sizeable part of our integration and merging effort. 

To expedite the software iterations without having to rebuild the entire FPGA, we've developed a simple, robust and platform-agnostic own method for CPU program uploads <b>via UART</b>. That's a notable departure from the two typical approaches used in most other projects:
  - <b>via JTAG</b>, directly into internal FPGA BRAM: 
     > Not possible due to lack of openXC7 support for BSCANE2 Xilinx component
  - indirectly, into external <b>SPI Flash</b>, which CPU boot code then copies to on-chip BRAM
     > Not possible with Basys3, due to shortsightedness of board designers, coupled with openXC7 lack of support for STARTUPE2 Xilinx component

The beauty of our CPU code download method is that it's fully portable across FPGA vendors and boards -- It's without inherent dependencies on the special, vendor-specific IP.    

**<h3> Game Logic </h3>**

This section is about the algorithm basics, i.e. the logic of the game. It's worth emphasizing that this the heart of our app, and stays the same for both full-fledged PC and bare-metal RISC-V implementation. 

The other SW parts are: <b>Game Controls</b>, <b>Timing</b> and <b>Rendering</b>. They depened on the HW platform, and have to be adapted to it through porting process from PC host to embedded CPU. 

<i>Tetrominoes</i> are the essence of the Game Logic element. They're illustrated in the figure below.
  ![image](https://github.com/chili-chips-ba/openXC7-TetriSaraj/assets/113244867/3f4bd9aa-19b2-46f8-92a8-beec3c671afe)

There are 7 primary <i>tetromino</i> shapes. Including rotations, we get to 28 different shapes. However, to save memory, we store only the original shapes, using a 7x16 matrix of 1s and 0s, where 1s represent blocks, and 0s represent empty space. For example, let's take the 2nd <i>tetromino</i>, the squared one, and write it row-by-row from left to right: <br />
> 0, 0, 0, 0; <br />
> 0, 1, 1, 0; <br />
> 0, 1, 1, 0; <br />
> 0, 0, 0, 0; <br />

This is clearly an array of 16 elements. Seven such arrays make the full primary <i>tetromino</i> set. The entire 40x30 playing field is stored in a similar array, for which we use "<i>field</i>" variable.

So, how can this 7x16 primary <i>tetromino</i> matrix account for all 28x16 rotations? The answer is: <i>By using algorithmic smarts in lieu of the brute force</i>. For that, we have <i>rotate</i> function with 3 input arguments: <b>X</b> coordinate, <b>Y</b> coordinate, and <b>R</b>otation. This function returns the <b>I</b>ndex of the so-rotated block in the original piece. We should note that the X, Y coordinates take values from 0..3; R is {0, 90, 180, 270}; and returned Index is 0..15. Rotation is executed clockwise.

For example, let's have a look at this shape and its rotations:
  ![rotacija_bez](https://github.com/chili-chips-ba/openXC7-TetriSaraj/assets/113244867/88ec5169-c7a7-4ad1-a3b8-18fb19fd305e)

The 1st piece is the original, primary <i>tetromino</i>. The remaining 3 are its rotations. We now want to find the Index in the original piece for the corresponding mutant with coordinates X=2, Y=1, R=90 degrees. The relation between shapes rotated by 90 degrees is: <i>"Index = 12 + Y - (X * 4)"</i>. Which means that this specific block is on Index=5 of the original piece. 

The same applies to other rotations and other figures. Let's now have a look at R=270 degrees. We observe the block on coordinates X=1, Y=2. The relation for this case is <i>"Index = 3 - Y + (X * 4)"</i>. That gives us 5 again, meaning that this specific block is the same as the block on Index 5 of the original piece.

So, what is the Game Logic? 

Upon receiving a game tick, we first look at the commands. If one of the command buttons is pressed, we try to move the piece in the specified direction, or rotate it. For that, we first check whether the moved-or-rotated piece can fit in the position the command wants it to be in. If it cannot fit, we lock the piece in the field /* write a shape-specific values in the <i>field</i> variable */, i.e. don't honor the command. 

If it can fit, we honor the command, check whether any vertical lines were formed, and store the X coordinates of the formed lines so we can delete them. The erasing of the vertical is straightforward -- We just set the current line to empty and move all lines "above" it to one place "below". When all this is done, we generate a new random piece. 

So, how do we check if the piece can fit in a specific position?! That's a 4-step process: <br />
    - find the correct Index in the rotated piece - variable "<i>pi</i>" in the function <br />
    - find the correct Index in the <i>field</i>  - variable "<i>fi</i>" in the function <br />
    - check the boundaries <br />
    - check if the piece can fit <br />
    
This fit test is done by checking if both: <br />
 - piece block on index <i>pi</i> <br />
 - and <i>field</i> block on index <i>fi</i> <br />
 are not empty. Both being not-empty means collision, for which our <i>DoesPieceFit</i> function returns <i>false</i>.

**<h3> Game Timing </h3>**

The timing of the game is controlled by our own ticks. As the game progresses, the game ticks become more frequent, making it more challenging for the player.

On the PC side (implemented in C++), we use "<i>this_thread::sleep_for</i>" method, where the <i>sleep</i> is 50ms, and also a counter which we increment after the <i>sleep</i>. When the counter gets to a certain value (let's call it <i>speed</i>) we move our piece. This is one game tick. As the game progresses, and we've stacked a few blocks, the <i>speed</i> value decrements, which is perceived as a faster play. 

A similar method was used for <i>Basys3</i>. Except that, in the absence of "<i>this_thread::sleep_for</i>" there, we had to come up with our own embedded <i>sleep</i> methods. Other than that, the rest of the logic is the same. 

**<h3> Game Controls </h3>**

On the PC side we used "<i>GetAsyncKeyState</i>" method to detect if a keyboard button was pressed. The controls are: <i>Left, Right, Up, Down arrow</i>, and <i>"Z" key for rotation</i>. Upon detecting that a key was pressed, we first check whether the piece can be moved at all. That's covered by "<i>DoesPieceFit</i>" function. 

The same logic applies to <i>Basys3</i>, where FPGA provides a GPIO register for the pushbuttons, from which we then read the button values. This is accomplished by "<i>GetButtonsState</i>" function.

**<h3> Rendering </h3>**

For video on the PC side we use <i>Windows.h</i> library to create a console screen and draw on it. This drawing is based on our <i>field</i> variable, which keeps the complete info about the playfield, with all the shapes on it, including the current game state. 

The video rendering on the FPGA side is a bit more complicated and involves writting into <i>MC Frame Buffer</i> registers from the same <i>field</i> variable.

**<h3> The Platform </h3>**

This HW/SW setup is more than the mere <i>TetriSaraj</i> game. It's a plaform, the solid foundation for developing other apps and retro games in the <b>40x30</b> <i>Mega-Character (MC) Frame Buffer</i> paradigm, yet with the full resolution graphics of the host board. We support <b>16 unique MCs</b>. The MCs can be viewed as mini-Sprites with course XY positioning. For more on this topic, see: https://www.youtube.com/watch?v=Pfy2vHygRaI .

Given <i>Basys3</i> max resolution of 640x480 RGB444, one MC in this case is a 16x16 block with 4096 colors for each of its 256 dots. That's a rather impressive level of detail, given the meager memory footprint of our <i>MC Frame Buffer</i>. It would otherwise not be possible to accomodate such resolution even in the comparatively resourceful Artix7-35T.

For example, the 4x smaller, 12x less expensive TangNano9K could also easily host our game. On it, and without having to change the game logic, the same 40x30 <i>MC Frame Buffer</i> would be rendered on the considerably larger 1280x720 RGB888 HDMI screen, by using 32x24 MCs with 16,777,216 colors for each of its 768 dots. Other than the static load of the MCs, and slightly modified RTL for the video back-end, the rest remains the same. This makes for low-effort porting.  

The next section brings about additional detail on our HW platform, and its video sub-system in particular.

**<h3> Screen Organization </h3>**
The video interface between hardware and software consists of:
- Screen of 640x480 RGB444 pixels divided into 40x30 (=1200) squares, each square being 16x16 pixels.
- Hardware implements a character set of 16 elements. Each element is a 16x16 pixel image in full RGB444 color palette, requiring 384 bytes of memory for one element.
- Software can program each of these 16 unique characters with arbitrary content.
- Software uses these 16 arbitrary characters through a 40x30 FrameBuffer, where each location is represented by 4 bits, indicating to the hardware which of the 16 characters to display at that location.
  
The image illustrating the screen organization is showed below.

![screen organization](https://github.com/chili-chips-ba/openXC7-TetriSaraj/assets/127020599/998e4dfb-b04a-4d86-b838-fc6c62dfbd28)

**<h3> Memory Map </h3>**
One of the first system design steps steps is to create a Memory Map that governs the interaction between CPU software and hardware responsible for rendering the 40x30 = 1200 elements on the screen. This Memory Map can be viewed as the <i>Instruction Set Architecture (ISA)</i> of our graphic mini-controller, serving as a contract or interface between the software and hardware components.

The Memory Map for the _character frame buffer_ (CFB) stores information about the screen display. As mentioned, there are 1200 elements on the screen filled with user-created characters. The Character Set consists of 16 unique, fully programmable characters. In this context, each element on the screen requires 4 bits of memory. The 4-bit code in the CFB is the ID of the character to show on the corresponding XY location.  

By organizing the memory in this manner and establishing the Memory Map, we enable effective communication between CPU software and hardware, facilitating the rendering of graphics on the screen. This approach allows the CPU to access and manipulate the graphical data in a structured and predictable manner, thereby enabling smooth and controlled display updates.

![Memory map - CFB](https://github.com/chili-chips-ba/openXC7-TetriSaraj/assets/127020599/ab73accd-ec38-471c-be1b-6f2b5f04d2b4)

When creating characters, the goal is to be able to color each individual pixel in any color. In this regard, a memory map for the _character set_ has been created, implemented in a way that utilizes only the lower 12 bits of a 32-bit word.

The main reason for using such memory maps for character set and CFB is the simplification of indexing during memory writing.

The memory map for the _character set_ is shown below.
![Memory map - CS](https://github.com/chili-chips-ba/openXC7-TetriSaraj/assets/127020599/d4965765-c667-4c9e-bd89-e08ada5c9ad8)

**<h3> From HDL to Bitstream: Unraveling the FPGA Design Journey </h3>**

In the realm of FPGA design, the journey begins with code in a <i>Hardware Description Language</i> (HDL), such as Verilog or VHDL. This code serves as the blueprint for the intended functionality to be implemented on the Field-Programmable Gate Array (FPGA) chip. However, transforming this HDL code into an operational FPGA design is a rather complex process known as the "FPGA Build Flow."

The FPGA Build Flow entails several critical stages that pave the way for the successful realization of the desired hardware functionality. Its main steps are:

- <b>Synthesis</b>: At the outset, the HDL code undergoes synthesis, where it is translated into a logical netlist comprising gates and flip-flops. This netlist serves as an intermediary representation of the design before it is mapped to the FPGA's specific resources.

- <b>Implementation</b>: In this step logical netlist is efficiently mapped onto the available resources of the target FPGA. This process involves strategically placing logic elements on the FPGA's programmable fabric and establishing optimized interconnections.

- <b>JSON and Frames Generation</b>: After a successful implementation, the design is captured in two essential files: the JSON file, representing a hierarchical description of the FPGA design in JSON format, and the Frames file, containing information about the placement and configuration of "frames" within the FPGA network.

- <b>.FASM File Generation (Optional)</b>: If needed, an additional .fasm file is generated, revealing the specific arrangement of logical elements on the FPGA chip.

- <b>Bitstream Generation</b>: This binary file holds the key to configuring the FPGA chip to operate as intended, encompassing critical information about logic elements, interconnections, and configurations.

- <b>FPGA Chip Programming</b>: With Bitstream file now at hand, the FPGA chip can be programmed. The Bitstream serves as the "genetic code" that configures the FPGA's hardware, endowing it with the functionalities specified in the original HDL code.

With this process complete, the FPGA design is ready to use. The abstract HDL code we've started from is now a tangible and can run, releasing the power of reconfigurability and adaptability that these programmable devices offer.

**<h3> FPGA Build Process </h3>**
The openXC7 tool flow we've used for FPGA build process can be downloaded from: https://github.com/openXC7/toolchain-installer

The "openXC7/toolchain-installer" is a GitHub repository that offers a convenient and automated solution for installing the toolchain required for Xilinx 7-series FPGA development. This toolchain installer is designed to streamline the setup process and facilitate FPGA design projects. Repository contains scripts and configuration files that fetch and install the necessary tools, such as synthesis tools, simulation tools, and programming utilities. By automating the installation process, developers can save time and effort, ensuring a smoother toolchain setup.

The installation of tools consists of just **one command**! To use these tools, Linux with the **Ubuntu** distribution is required.

If you are not using a Linux system with the **Ubuntu** distribution on your computer, we recommend using <i>Windows Subsystem for Linux</i> (<b>WSL</b>) as an alternative solution. 

The installation of WSL is very simple, so follow the steps below:
- Open Windows Power Shell.
- Enter command: `wsl --install Ubuntu`. After the installation process, WSL starts automatically.

The remaining procedure is identical whether you have WSL or an Ubuntu distribution of Linux on your computer. In case you are launching WSL, use the command `wsl` through Windows PowerShell. As the WSL starts automatically after installation, you can proceed directly with following steps: <br />
- Install openXC7 tool using: <br />
`wget -qO - https://raw.githubusercontent.com/kintex-chatter/toolchain-installer/main/toolchain-installer.sh | bash`
- Download demo projects along with the chip database using (we recommend downloading it to default destination _/home/<YOUR_USERNAME>_): <br />
`git clone https://github.com/openXC7/demo-projects`
- Download _TetriSaraj_ project from GitHub into demo projects folder (_/demo-projects_) using: <br />
`git clone https://github.com/chili-chips-ba/openXC7-TetriSaraj ~/demo-projects/TetriSaraj`
- To install the "make" tool, use the following command: `sudo apt install make`
- To install GCC package, first use: `sudo apt update`, and then: `sudo apt install gcc-riscv64-unknown-elf`

Now you need to install Python package using the following commands:
- `sudo apt install software-properties-common`
- `sudo add-apt-repository ppa:deadsnakes/ppa`
- `sudo apt update`
- `sudo apt install python3.8`
- `python3 --version`
- `sudo apt install python-is-python3`

To generate _.hex_ file, follow steps below:
- Set the current directory to the project folder: _/openXC7-TetriSaraj-main_
- To delete previously generated files, use the command: `make clean_fw`
- After that, type command: `make firmware`
- Finally, use command: `make hex`

After these steps, _.hex_ file will be generated in the _/openXC7-TetriSaraj-main/2.sw_ folder.

Finally, to initiate the build process, use the command: `make all`

The build process takes quite a while, please be patient.

Afterwards, the _.bit_ file will be generated in the project folder.

To upload _.bit_ file to the board, it is necessary to have the _openFPGALoader_ tool installed (only for Linux users!).
For Windows users, there is an issue with invisible ports on virtual machines, so it's recommended to use Digilent Adept tool: https://digilent.com/shop/software/digilent-adept. 

Follow the instructions below for installing _openFPGALoader_:
- `sudo apt update`
- `sudo apt-get install libftdi1-2 libftdi1-dev libhidapi-hidraw0 libhidapi-dev libudev-dev zlib1g-dev cmake pkg-config make g++`
- `git clone https://github.com/trabucayre/openFPGALoader`
- `cd openFPGALoader`
- `mkdir build`
- `cd build`
- `sudo apt-get install cmake`
- `cmake ../`
- `cmake --build .`
- `sudo make install`

If you want to upload bitstream file to FPGA board with _openFPGALoader_, use: `make program` 

**<h3>  Reprogramming Firmware via UART </h3>**

As previously mentioned in the _Development Methodology_ section, due to the limitations of openXC7 toolchain, we were compelled to find a method that would avoid the need to rebuild the entire FPGA for even the smallest change in the C source code.

For that, we have developed a Python script (_/openXC7-TetriSaraj-main/2.sw/**program.py**_) which facilitates communication between a host computer and our FPGA device, sending a specific data file (main.hex), and receiving a response from the FPGA. The transmitted data is organized in packets with a checksum for reliability.

Switch 15 is used to free the _UART RX/TX_ lines from the microcontroller and transfer them to the new FPGA modules, _uart_rx_ and _uart_tx_. After turning off Switch 15, the microcontroller is reset, and the application starts with new C code.

Here is the procedure to use for quick firmware reprograming:
- After modifying the C program, generate a new _.hex_ file, per instructions in the _FPGA build process_ section.
- In the Python script _program.py_, set the ComPort for the FPGA board.<br />
    On Linux use:   `ComPort = serial.Serial('/dev/ttyUSBx')`<br />
    On Windows use: `ComPort = serial.Serial('COMx')`<br />
- Launch the Command Line Interface and set the current directory to: _/openXC7-TetriSaraj-main/2.sw_
- Type: `python program.py`
- Wait until the reprogramming process is completed, indicated by the "END" output in the terminal. 
- Turn off switch 15.

The new C program will now be loaded into RAM and ready for use.

**<h3>  Demo of the Complete HW+SW App </h3>**  

Here is a teaser video we've created just to tickle your interest https://youtu.be/hwV8Yd4jkjU -- The checked-in game contains more than what is shown in this video! It adds the concept of 3 lives, visually expressed by hearts. The game ends when you loose all 3.

We encourage you to go through the above process, build both HW and SW, then play the expanded game. After that, try to modify the 'C' code on your own, such as by adding the concept of rewards. Here is an idea: Make it earn an extra life (which is a heart) when two lines are filled at once. Put your thinking cap on and keep cranking up new game features!

**<h3>  Closing Thoughts </h3>** 

OpenXC7 is not the only open-source tool chain for Xilinx Series7 family of FPGA devices. We have in the course of this project also tried the <b>VTR</b> (https://github.com/chipsalliance/f4pga), and vendor-proprietary <b>Vivado</b>. We established that the VTR was more robust and user-friendly than openXC7. And, as anticipated, Vivado surpassed them all in terms of both feature set and QOR. 

However, the openXC7 installation was maximally streamlined and super easy -- One simple command, literally copied from their instructions, and everything was ready for play. The VTR installation was much more involved. It did not even work out of the box. It took 3 smart engineers a few days to put everything in place and tune it properly before this flow with US$50M dev budget started generating bit-files :woozy_face:.

There are 4 major issues we've uncovered with openXC7. They are captured in the following tool support entries:
>1) https://github.com/openXC7/nextpnr-xilinx/issues/10
>    Main analytical placer locks up for designs with high Distributed RAM usage
>2) https://github.com/openXC7/nextpnr-xilinx/issues/11
>    Error messaging does not provide enough info for the self-guided debug
>3) https://github.com/openXC7/nextpnr-xilinx/issues/12
>    STA is very rudimentary, down to not even honoring timing constraints, yet alone accounting for clock tree skew
>4) https://github.com/openXC7/nextpnr-xilinx/issues/13
>    Prioritize support of BSCANE2 and STARTUPE2 primitives

There was also a number of minor issues. We resolved them on the go.

Our expert assessment is that openXC7, while not in its early infancy stage, is yet to reach the fully productive age of maturity. We would therefore not recommend it for large or commercial projects. At the moment, we view openXC7 primarily as a niche tool for the nerds and hobbyists. 

**<h3>  Credits and Public Appearances </h3>**

This work was sponsored by https://www.symbioticeda.com and showcased at https://sarajevo.makerfaire.com (June 2023).

> https://www.linkedin.com/posts/nedim-osmic_fpga-education-riscv-activity-7076521872032432129-b1Y5?utm_source=share&utm_medium=member_desktop

**<h3>  Next Steps </h3>**

This is not the end of TetriSaraj. Rather, it's an opener of a whole new play life:
- port to TangNano9K/20K and HDMI
- port from PicoRV32 to our own <b>eduBOS5</b>
- SOC cleanup and restructuring to our <b>eduSOC</b> built around our <b>eduBUS32</b>
- migration from Verilog-1995 to SystemVerilog-2008
- add support for Sprites
- add digital sound through HDMI-A
- integration of all project variants into Docker Containers for the CI system that SymbioticEDA team is working on
- propagation to other interested parties (Faculties of Electrical Engineering in Tuzla, Banja Luka, Pakistan, Tunis, ...), whoever and wherever wishes to leverage from it for their educational or other programs

**<h3>  End of Document </h3>** 
