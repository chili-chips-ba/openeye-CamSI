#! /bin/sh

# --------------------------------------------------------------------
# --   *****************************
# --   *   Trenz Electronic GmbH   *
# --   *   Beendorfer Str. 23      *
# --   *   32609 Hüllhorst   		   *
# --   *   Germany                 *
# --   *****************************
# --------------------------------------------------------------------
# --$Autor: Hartfiel, John $
# --$Email: j.hartfiel@trenz-electronic.de $
# --$Create Date:2017/01/13 $
# --$Modify Date: 2021/02/10 $
# --$Version: 1.6 $
# --   add note
# --$Version: 1.5 $
# --   add petalinux check
# --   remove sdsoc
# --   docu update
# --$Version: 1.4 $
#    -- add new bash files
# --$Version: 1.3 $
#    -- update docu section
#    -- select vivado version todo
#    -- use board store todo
# --$Version: 1.2 $
# -- 1.2 Changes
# --    update 2019.2
# --$Version: 1.1 $
# --------------------------------------------------------------------
# --------------------------------------------------------------------
# init
function pause(){
   read -p "$*"
}

function te_base(){
echo "--------------------------------------------------------------------" 
echo "----------------------_create_linux_setup.cmd-----------------------"
echo "------------------------TE Reference Design-------------------------"
echo "--------------------------------------------------------------------"
# echo "-- (c)  Go to CMD-File Generation (Manual setup)                    "
echo "-- (d)  Go to Documentation (Web Documentation)                     "
echo "-- (x)  Exit Batch (nothing is done!)                               "
echo "-- (0)  Module selection guide, project creation...                 "
echo "-- (1)  Create minimum setup of CMD-Files and exit Batch            "
echo "-- (2)  Create maximum setup of CMD-Files and exit Batch            "
echo "-- (3)  (internal only) Dev                                         "
echo "-- (g)  Install Board Files from Xilinx Board Store (beta)          "
echo "-- (a)  Start  design with unsupported Vivado Version (beta)        "
echo "----                                                                "
echo " Select (ex.:'0' for module selection guide):"                                      
read new_base
if [ "${new_base}" == "d" ]; then te_doc ; fi
# if [ "${new_base}" == "c" ]; then te_cmd ; fi
if [ "${new_base}" == "x" ]; then exit 1 ; fi
if [ "${new_base}" == "" ];  then 
  te_sel 0 0  
  local res=$?
  if [ "${res}" == "22" ]; then 
    return ${res}
  else
    te_last
  fi
fi
if [ "${new_base}" == "0" ]; then 
  te_sel 0 0  
  local res=$?
  if [ "${res}" == "22" ]; then 
    return ${res}
  else
    te_last
  fi
fi
if [ "${new_base}" == "1" ]; then te_min ; te_last; fi
if [ "${new_base}" == "2" ]; then te_max ; te_last; fi
if [ "${new_base}" == "3" ]; then te_dev ; te_last; fi
if [ "${new_base}" == "g" ]; then 
  te_sel 1 0 
  local res=$?
  if [ "${res}" == "22" ]; then 
    return ${res}
  else
    te_last
  fi
fi
if [ "${new_base}" == "a" ]; then te_sel 0 1
  local res=$?
  if [ "${res}" == "22" ]; then 
    return ${res}
  else
    te_last
  fi
fi

te_base
}

function te_sel(){
                                        
  if ! [ -e "${bashfile_path}/design_basic_settings.sh" ]; then cp ${sh_folder}/design_basic_settings.sh ${bashfile_path}; fi
  if [ -e "${sh_folder}/vivado_create_project_guimode.sh" ]; then cp ${sh_folder}/vivado_create_project_guimode.sh ${bashfile_path}; fi
  if [ -e "${sh_folder}/vivado_open_existing_project_guimode.sh" ]; then cp ${sh_folder}/vivado_open_existing_project_guimode.sh ${bashfile_path}; fi

  # get paths
  bashfile_name=${0##*/}
  # bashfile_path=${0%/*}
  bashfile_path=`pwd`
  echo -- Run Design with: ${bashfile_name}
  echo -- Use Design Path: ${bashfile_path}
  echo ---------------------Load basic design settings---------------------
  source ${sh_folder}/design_basic_settings.sh 

  DEF_VIVADO_VERSION=${VIVADO_VERSION}
  source $bashfile_path/design_basic_settings.sh
  
  A=$2
  if [ "$A" = "1" ]; then
     echo " Select other Vivado Version (for ex. 2020.2):"   
     read newvivado
    export VIVADO_VERSION=${newvivado}
  fi
  
  A=$1
  if [ "$A" = "1" ]; then

      export USE_XILINX_BOARD_STORE=1
  fi


  echo -- ${DEF_VIVADO_VERSION} -- ${VIVADO_VERSION}
  
  if ! [ "${DEF_VIVADO_VERSION}" == "${VIVADO_VERSION}" ]; then  
    echo -----------------------------------------
    echo  - Design was created for Vivado ${DEF_VIVADO_VERSION}, selected is Vivado ${VIVADO_VERSION}
    echo  - Design only tested with Vivado ${DEF_VIVADO_VERSION}, modifications needed for other versions
    echo .
    echo ... Continue with ${VIVADO_VERSION} ...
  fi
  
  
  echo -----------------------------------------
  # check xilinx installation
  while !  [ -e "${XILDIR}" ]
  do
    echo "'${XILDIR}' did not exists."
    echo "  Please specifiy you Xilinx installation folder: "                                      
    read new_base
    export XILDIR=${new_base}
  done
   if  [ -e "${XILDIR}" ]; then
    echo "Use Xilinx installation from '${XILDIR}'"
   fi
  return 22
}  

function vivado_sel {
  echo ----------------------Change to log folder--------------------------
  # vlog folder
  vlog_folder=${bashfile_path}/v_log
  echo ${vlog_folder}
  if ! [ -d "$vlog_folder" ]; then
     mkdir ${vlog_folder}
  fi 
  cd ${vlog_folder}
  # mkdir tmp
  # setenv XILINX_TCLSTORE_USERAREA tmp
  echo --------------------------------------------------------------------
  echo -------------------------Start VIVADO scripts -----------------------
  vivado -source ../scripts/script_main.tcl  -mode batch -notrace -tclargs --run_board_selection
  echo -------------------------scripts finished----------------------------
  echo --------------------------------------------------------------------
  echo --------------------Change to design folder-------------------------
  cd ..
  echo ------------------------Design finished-----------------------------
#   ${XILDIR}/Vivado/${VIVADO_VERSION}/bin/vivado -source ../scripts/script_main.tcl  -mode batch -notrace -tclargs --run 1 --gui 1 --clean 2 --boardpart ${PARTNUMBER}
  exit
 }

function te_doc(){
echo "--------------------------------------------------------------------"
echo "-------------------------TE Documentation---------------------------"
echo "--------------------------------------------------------------------"
echo "-- (b)  Go to Base Menue                                              " 
echo "-- (x)  Exit Batch(nothing is done!)                                  "
echo "-- (0)  Trenz Electronic Wiki                                         "
echo "-- (1)  Trenz Electronic Wiki: Tutorial                               "
echo "-- (2) Trenz Electronic Wiki: Vivado/SDK/Petalinux Part Flow        "
echo "-- (3)  Trenz Electronic Wiki: Project Delivery Xilinx Designs        "
echo "-- (4)  Trenz Electronic Wiki: Article Number Information             "
echo "-- (5)  Trenz Electronic Wiki: Reference Design overview (all boards) "
echo "-- (6)  Trenz Electronic Downloads                                    "
echo "----                                                                  "


echo " Select Document (ex.:'0' for Wiki ,'b' go to Base Menue):"                                      
read new_doc
if [ "${new_doc}" == "b" ]; then te_base; fi
if [ "${new_doc}" == "x" ]; then exit 1; fi
if [ "${new_doc}" == "0" ]; then xdg-open https://wiki.trenz-electronic.de/display/PD/Trenz+Electronic+Documentation ; fi
if [ "${new_doc}" == "1" ]; then xdg-open https://wiki.trenz-electronic.de/display/PD/Tutorials ; fi
if [ "${new_doc}" == "2" ]; then xdg-open https://wiki.trenz-electronic.de/display/PD/Xilinx+Development+Toolss ; fi
if [ "${new_doc}" == "3" ]; then xdg-open https://wiki.trenz-electronic.de/display/PD/Project+Delivery+-+Xilinx+devices ; fi
if [ "${new_doc}" == "4" ]; then xdg-open https://wiki.trenz-electronic.de/display/PD/Article+Number+Information ; fi
if [ "${new_doc}" == "5" ]; then xdg-open https://wiki.trenz-electronic.de/display/PD/TE+Reference+Designs+Overview ; fi
if [ "${new_doc}" == "6" ]; then xdg-open https://shop.trenz-electronic.de/en/Download/?path=Trenz_Electronic ; fi

te_doc
}     

function te_min(){
  if [ -e "${sh_folder}/vivado_create_project_guimode.sh" ]; then cp ${sh_folder}/vivado_create_project_guimode.sh ${bashfile_path}; fi
  if [ -e "${sh_folder}/vivado_open_existing_project_guimode.sh" ]; then cp ${sh_folder}/vivado_open_existing_project_guimode.sh ${bashfile_path}; fi
  if ! [ -e "${bashfile_path}/design_basic_settings.sh" ]; then cp ${sh_folder}/design_basic_settings.sh ${bashfile_path}; fi

}                                                                   
   
function te_max(){
  if [ -e "${sh_folder}/vivado_create_project_guimode.sh" ]; then cp ${sh_folder}/vivado_create_project_guimode.sh ${bashfile_path}; fi
  if [ -e "${sh_folder}/vivado_open_existing_project_guimode.sh" ]; then cp ${sh_folder}/vivado_open_existing_project_guimode.sh ${bashfile_path}; fi
  if [ -e "${sh_folder}/design_run_project_batchmode.sh" ]; then cp ${sh_folder}/design_run_project_batchmode.sh ${bashfile_path}; fi
  if [ -e "${sh_folder}/development_design_run_prebuilt_all_batchmode.sh" ]; then cp ${sh_folder}/development_design_run_prebuilt_all_batchmode.sh ${bashfile_path}; fi
  if [ -e "${sh_folder}/development_utilities_backup.sh" ]; then cp ${sh_folder}/development_utilities_backup.sh ${bashfile_path}; fi
  if ! [ -e "${bashfile_path}/design_basic_settings.sh" ]; then cp ${sh_folder}/design_basic_settings.sh ${bashfile_path}; fi
}
                                                                   
function te_dev(){
  if [ -e "${sh_folder}/vivado_create_project_guimode.sh" ]; then cp ${sh_folder}/vivado_create_project_guimode.sh ${bashfile_path}; fi
  if [ -e "${sh_folder}/vivado_open_existing_project_guimode.sh" ]; then cp ${sh_folder}/vivado_open_existing_project_guimode.sh ${bashfile_path}; fi
  if [ -e "${sh_folder}/development_design_run_prebuilt_all_batchmode.sh" ]; then cp ${sh_folder}/development_design_run_prebuilt_all_batchmode.sh ${bashfile_path}; fi
  if [ -e "${sh_folder}/development_utilities_backup.sh" ]; then cp ${sh_folder}/development_utilities_backup.sh ${bashfile_path}; fi
  if ! [ -e "${bashfile_path}/design_basic_settings.sh" ]; then cp ${sh_folder}/design_basic_settings.sh ${bashfile_path}; fi
}                                                                   
                                                                  
   
function te_last(){
  if ! [ -e "${bashfile_path}/design_basic_settings.sh" ]; then cp ${sh_folder}/design_basic_settings.sh ${bashfile_path}; fi
  echo ---------------------------Minimal Setup----------------------------
  echo --- 1. Open "design_basic_settings.sh" with text editor
  echo --- -- Note: "Module selection guide" modifies this file automatically
  echo --- 1.1 Set Xilinx Installation path, default:  XILDIR=/opt/Xilinx/
  echo --- 1.2 Set the Board Part you bought, example: PARTNUMBER=te0726-3m 
  echo --- --- For available names see: ./board_files/TExxxx_board_files.csv
  echo --- 1.3 Save "design_basic_settings.sh"
  echo --- Create and open Vivado Project with batch files:
  echo --- 2. To create vivado project, execute: ./vivado_create_project_guimode.sh
  echo --- Open existing Vivado Project with batch files:
  echo --- 3. To open existing vivado project, execute: ./vivado_open_existing_project_guimode.sh
  echo --- Use Trenz Electronic Wiki for more information:
  echo ---   https://wiki.trenz-electronic.de/display/PD/Project+Delivery+-+Xilinx+devices
  echo ---   https://wiki.trenz-electronic.de/display/PD/Xilinx+Development+Tools
  echo -------------------------------------------------------------------- 
  pause 'Press [Enter] key to continue...'
  exit 1
}
   
echo ------------------------Set design paths----------------------------
# get paths
bashfile_name=${0##*/}
bashfile_path=`pwd`

echo -- Run Design with: $bashfile_name
echo -- Use Design Path: $bashfile_path
sh_folder=${bashfile_path}/console/base_sh 
# run base menue
te_base
startvivado=$?
if [ "${startvivado}" == "22" ]; then 
  echo --------------------------------------------------------------------
  echo ------------------Set Xilinx environment variables------------------
  VIVADO_XSETTINGS=${XILDIR}/Vivado/${VIVADO_VERSION}/.settings64-Vivado.sh
  VITIS_XSETTINGS=${XILDIR}/Vitis/${VIVADO_VERSION}/.settings64-Vitis.sh
  LABTOOL_XSETTINGS=${XILDIR}/Vivado_Lab/${VIVADO_VERSION}/.settings64.sh
  PETALINUX_XSETTINGS=${XILDIR}/PetaLinux/${VIVADO_VERSION}/tool/settings.sh
  # --------------------
  if [ "${VIVADO_AVAILABLE}" == "" ]; then export VIVADO_AVAILABLE=0; fi
  if [ "${SDK_AVAILABLE}" == "" ]; then export SDK_AVAILABLE=0; fi
  if [ "${LABTOOL_AVAILABLE}" == "" ]; then export LABTOOL_AVAILABLE=0; fi
  if [ "${PETALINUX_AVAILABLE}" == "" ]; then export PETALINUX_AVAILABLE=0; fi

  # # --------------------
  echo -- Use Xilinx Version: ${VIVADO_VERSION} --

  if [ "${VIVADO_XSETTINGS_ISDONE}" == "" ]; then  echo --Info: Configure Xilinx Vivado Settings --
    if !  [ -e "${VIVADO_XSETTINGS}" ]; then  
      echo --     Critical Warning: ${VIVADO_XSETTINGS} not found --
    else
      source ${VIVADO_XSETTINGS}
      export VIVADO_AVAILABLE=1
    fi
    VIVADO_XSETTINGS_ISDONE=1
  fi

  if [ "${VITIS_XSETTINGS_ISDONE}" == "" ]; then  echo --Info: Configure Xilinx Vitis Settings --
    if !  [ -e "${VITIS_XSETTINGS}" ]; then  
      echo --     Critical Warning: ${VITIS_XSETTINGS} not found --
    else
      source ${VITIS_XSETTINGS}
      export SDK_AVAILABLE=1
    fi
    VITIS_XSETTINGS_ISDONE=1
  fi
  
  if !  [ -e "${VIVADO_XSETTINGS}" ]; then  
    if [ "${LABTOOL_XSETTINGS_ISDONE}" == "" ]; then  echo --Info: Configure Xilinx LabTools Settings --
      if !  [ -e "${LABTOOL_XSETTINGS}" ]; then  
        echo --     Note : ${LABTOOL_XSETTINGS} not found --
      else
        source ${LABTOOL_XSETTINGS}
        export LABTOOL_AVAILABLE=1
      fi
      LABTOOL_XSETTINGS_ISDONE=1
    fi
  fi


 if [ "${PETALINUX_XSETTINGS_ISDONE}" == "" ]; then  echo --Info: Configure Xilinx Petalinux Settings --
   if !  [ -e "${PETALINUX_XSETTINGS}" ]; then  
     echo -- Info: ${PETALINUX_XSETTINGS} not found  try alterative path  ${ALTERNATIVE_PETALINUX_XSETTINGS}--
     PETALINUX_XSETTINGS=${ALTERNATIVE_PETALINUX_XSETTINGS}
     if !  [ -e "${PETALINUX_XSETTINGS}" ]; then  
       echo -- Info: ${PETALINUX_XSETTINGS} not found --
     else
       source ${PETALINUX_XSETTINGS}
       export PETALINUX_AVAILABLE=1
     fi
   else
     source ${PETALINUX_XSETTINGS}
     export PETALINUX_AVAILABLE=1
   fi
   PETALINUX_XSETTINGS_ISDONE=1
 fi
  
  echo --------------------------------------------------------------------
  # check important settings
  if [ ${VIVADO_AVAILABLE} == 1 ]; then
    echo ----------------------check old project exists--------------------------
     vivado_p_folder=${bashfile_path}/vivado
    if [ -d "$vivado_p_folder" ]; then
      echo "Found old vivado project: Create project will delete old project!"
      echo "Are you sure to continue? (y/N):"
      read creatProject
      if [ ${creatProject} == y ] || [ ${creatProject} == Y ]; then
       vivado_sel
      else
        echo Create Vivado project is canceled.
      fi
    else
     vivado_sel
    fi
    echo ---------------------------Regenerate or open Design again----------------------------
    echo --- To create vivado project egain, execute: ./vivado_create_project_guimode.sh
    echo --- To open existing vivado project, execute: ./vivado_open_existing_project_guimode.sh
    echo --- Use Trenz Electronic Wiki for more information:
    echo ---   https://wiki.trenz-electronic.de/display/PD/Project+Delivery+-+Xilinx+devices
    echo ---   https://wiki.trenz-electronic.de/display/PD/Xilinx+Development+Tools
    echo -------------------------------------------------------------------- 
    pause 'Press [Enter] key to continue...'
    exit 1
  else
    echo -- Error: Need Vivado to run. --
    if !  [ -e "${XILDIR}" ]; then  
      echo "-- Error: ${XILDIR} not found. Check path of XILDIR variable on design_basic_settings.sh (upper and lower case is important)"
    fi
    echo ---------------------------Error occurs-----------------------------
    echo --------------------------------------------------------------------
    return exit
  fi
fi
