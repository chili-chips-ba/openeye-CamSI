# --------------------------------------------------------------------
# --   *****************************
# --   *   Trenz Electronic GmbH   *
# --   *   Beendorfer Str. 23      *
# --   *   32609 Hüllhorst         *
# --   *   Germany                 *
# --   *****************************
# --------------------------------------------------------------------
# -- $Author: Hartfiel, John $
# -- $Email: j.hartfiel@trenz-electronic.de $
# --------------------------------------------------------------------
# -- Change History:
# ------------------------------------------
# -- $Date: 2016/02/03 | $Author: Hartfiel, John
# -- - initial release
# ------------------------------------------
# -- $Date: 2017/02/02  | $Author: Hartfiel, John
# -- - miscellaneous
# ------------------------------------------
# -- $Date:  2017/09/04  | $Author: Hartfiel, John
# -- - add new document history style
# ------------------------------------------
# -- $Date:  2018/09/17  | $Author: Hartfiel, John
# -- - add internal betaversion of xilinx boardstore
# ------------------------------------------
# -- $Date:  2020/03/30  | $Author: Hartfiel, John
# -- - optional xilinx boardstore
# ------------------------------------------
# -- $Date:  2020/04/07  | $Author: Hartfiel, John
# -- - add serial path
# ------------------------------------------
# -- $Date:  2020/05/05  | $Author: Hartfiel, John
# -- - add putty path and ignore list
# ------------------------------------------
# -- $Date:  2020/08/12  | $Author: Hartfiel, John
# -- - add notes for board store
# ------------------------------------------
# -- $Date:  2021/03/09  | $Author: Hartfiel, John
# -- - prevent board store to install all files and select only give one to install
# ------------------------------------------
# -- $Date:  2021/12/16  | $Author: Hartfiel, John
# -- - add scan EDITOR and WSL variable
# ------------------------------------------
# -- $Date: 0000/00/00  | $Author:
# -- - 
# --------------------------------------------------------------------
# --------------------------------------------------------------------
namespace eval ::TE {
  namespace eval ENV {
    # -----------------------------------------------------------------------------------------------------------------------------------------
    # initial
    # -----------------------------------------------------------------------------------------------------------------------------------------
    #--------------------------------
    #--set_path_boarddef:  
    proc set_path_boarddef {} {

      if {[catch {set ::TE::ENV::USE_XILINX_BOARD_STORE $::env(USE_XILINX_BOARD_STORE)}]} { set ::TE::ENV::USE_XILINX_BOARD_STORE 0 }
      
      
      if {$::TE::ENV::USE_XILINX_BOARD_STORE == 2 } {
        TE::UTILS::te_msg TE_INIT-188 INFO "Use local variant of Xilinx Board Store (internal usage only)"
        
        set_param board.repoPaths [get_property LOCAL_ROOT_DIR [xhub::get_xstores xilinx_board_store]]
        
      } elseif {$::TE::ENV::USE_XILINX_BOARD_STORE == 1 } {
        TE::UTILS::te_msg TE_INIT-187 INFO "Use Xilinx Board Store, please wait this takes some time..."
        # todo for later maybe uninstall: xhub::uninstall  [xhub::get_xitems *trenz.biz:xilinx_board_store:*]
        
        set_param board.repoPaths [get_property LOCAL_ROOT_DIR [xhub::get_xstores xilinx_board_store]]
        
        xhub::refresh_catalog [xhub::get_xstores xilinx_board_store]
        set tmpboard "[lindex [split ${TE::BOARDPART} ":"] 1]:[lindex [split ${TE::BOARDPART} ":"] 3]"        
				if {[string length $tmpboard ] > 5} {
					xhub::install [xhub::get_xitems *${tmpboard}*]
					xhub::update [xhub::get_xitems *${tmpboard}*]
					
				} else {
					TE::UTILS::te_msg TE_INIT-206 ERROR "Problem to resolve Board store name from ${TE::BOARDPART}, get $tmpboard"
					return -code error
				}
        
        set_param board.repoPaths [get_property LOCAL_ROOT_DIR [xhub::get_xstores xilinx_board_store]]

      } else {
        TE::UTILS::te_msg TE_INIT-69 INFO "Set Board Definition path: $TE::BOARDDEF_PATH"
        set_param board.repoPaths $TE::BOARDDEF_PATH
      }
    }
    #--------------------------------
    #--set_path_boarddef: 
    proc set_path_ip {} {
      TE::UTILS::te_msg TE_INIT-70 INFO "Set IP path : $TE::IP_PATH"
      set_property IP_REPO_PATHS $TE::IP_PATH [current_fileset]
      ::update_ip_catalog
    }
    #--------------------------------
    #--set_add_env: additional environment
    proc set_add_env {} {
      # WSL
      if {[catch {set TE::TE_WSL_USAGE  ${::env(TE_WSL_USAGE)}}]} {
        set TE::TE_WSL_USAGE 0
      }
      # Text Editor
      if {[catch {set TE::TE_EDITOR  ${::env(TE_EDITOR)}}]} {
        set TE::TE_EDITOR "DEFAULT"
      }
    
      # serial
      if {[catch {set TE::SERIAL_PATH  ${::env(TE_SERIAL_PS)}}]} {
        set TE::SERIAL_PATH "../../../../../../articlebyserial"
      }
      set tmpdir [pwd]
      cd $TE::LOG_PATH 
      if {[file exists $TE::SERIAL_PATH]} {
        TE::UTILS::te_msg TE_INIT-158 INFO "Serial PS Scripts is available on $TE::SERIAL_PATH"
      }
      # petalinux
      if {[catch {set TE::PLX_SSTATE_CACHE_DOWNLOAD  ${::env(TE_PLX_SSTATE_CACHE_DOWNLOAD)}}]} {
        set vivado_version  ${::env(VIVADO_VERSION)}
        set TE::PLX_SSTATE_CACHE_DOWNLOAD "~/design/sstate-cache/downloads_${vivado_version}/downloads"
      }
      if {[catch {set TE::PLX_SSTATE_CACHE_AARCH64  ${::env(TE_PLX_SSTATE_CACHE_AARCH64)}}]} {
        set vivado_version  ${::env(VIVADO_VERSION)}
        set TE::PLX_SSTATE_CACHE_AARCH64 "~/design/sstate-cache/sstate_aarch64_${vivado_version}/aarch64"
      }
      if {[catch {set TE::PLX_SSTATE_CACHE_ARM  ${::env(TE_PLX_SSTATE_CACHE_ARM)}}]} {
        set vivado_version  ${::env(VIVADO_VERSION)}
        set TE::PLX_SSTATE_CACHE_ARM "~/design/sstate-cache/sstate_arm_${vivado_version}/arm"
      }
      if {[catch {set TE::PLX_SSTATE_CACHE_MB_FULL  ${::env(TE_PLX_SSTATE_CACHE_MB_FULL)}}]} {
        set vivado_version  ${::env(VIVADO_VERSION)}
        set TE::PLX_SSTATE_CACHE_MB_FULL "~/design/sstate-cache/sstate_mb-full_${vivado_version}/mb-full"
      }
      if {[catch {set TE::PLX_SSTATE_CACHE_MB_LITE  ${::env(TE_PLX_SSTATE_CACHE_MB_LITE)}}]} {
        set vivado_version  ${::env(VIVADO_VERSION)}
        set TE::PLX_SSTATE_CACHE_MB_LITE "~/design/sstate-cache/sstate_mb-full_${vivado_version}/mb-lite"
      }
      
      # putty
      if {[catch {set TE::COM_PATH  ${::env(TE_COM)}}]} {
        # set TE::COM_PATH "GLOBAL"
        set TE::COM_PATH "../../../../../../putty"
      }
      set TE::COM_IGNORE_LIST [list] 
      append TE::COM_IGNORE_LIST "COM1"
      if { [file exists ${TE::COM_PATH}/com_ignore_list.csv] } {
        set fp [open "${TE::COM_PATH}/com_ignore_list.csv" r]
        set file_data [read $fp]
        close $fp
        set data [split $file_data "\n"]
        foreach line $data { 
          lappend TE::COM_IGNORE_LIST $line
        }

      }
      cd $tmpdir 
    }
    
    #--------------------------------
    #--set_path_boarddef: 
    proc setup_extended_config {} {
      set config_sw_extpll [TE::BDEF::get_config_sw_extpll $TE::PRODID  ${TE::BDEF::PRODID}] 
      # puts "Test---------------------------------" 
      # puts "Test $config_sw_extpll" 

      if {![string match -nocase "NA" $config_sw_extpll ] } {
          set source_file "$TE::BASEFOLDER/$config_sw_extpll"
          if { [file exists $source_file] } { 
            set destination_files []
            set filename [file tail $source_file]
            if { [catch {set destination_files [TE::UTILS::findFiles $TE::LIB_PATH $filename]}] } {
              set destination_files []
              TE::UTILS::te_msg TE_INIT-233 {CRITICAL WARNING} "Extendion destination not available, please check : $filename in $TE::LIB_PATH"
            }
            foreach des_file $destination_files { 
              file copy -force ${source_file} ${des_file}
              TE::UTILS::te_msg TE_INIT-234 INFO "Replace  $des_file with $source_file"
            }
          } else {
            TE::UTILS::te_msg TE_INIT-235 {CRITICAL WARNING} "Extendion source not available, please check : $TE::source_file"
          }
      }
    
    }
    
    
    # -----------------------------------------------------------------------------------------------------------------------------------------
    # finished 
    # -----------------------------------------------------------------------------------------------------------------------------------------
  
  
  
  # -----------------------------------------------------------------------------------------------------------------------------------------
	}
  
  puts "INFO:(TE) Load environment script finished"
}


