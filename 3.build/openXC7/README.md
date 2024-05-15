### *openXC7 Primer*

The openXC7 tool flow we've used for FPGA build process can be downloaded from:
> https://github.com/openXC7/toolchain-installer

The "openXC7/toolchain-installer" is a GitHub repository that offers a convenient and automated solution for installing the toolchain required for Xilinx Series7. This toolchain installer is designed to streamline the setup process and facilitate design projects. Repository contains scripts and configuration files that fetch and install the necessary tools, such as synthesis tools, simulation tools, and programming utilities. By automating the installation process, developers can save time and effort, ensuring a smoother toolchain setup.

The installation of tools consists of just **one command**! To use these tools, Linux with the **Ubuntu** distribution is required.

If you are not using a Linux system with the **Ubuntu** distribution on your computer, we recommend using <i>Windows Subsystem for Linux</i> (<b>WSL</b>) as an alternative solution. 

The installation of WSL is very simple, so follow the steps below:
> Open Windows Power Shell.
> Enter command: `wsl --install Ubuntu`

After the installation process, WSL starts automatically.

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


### End of Document
