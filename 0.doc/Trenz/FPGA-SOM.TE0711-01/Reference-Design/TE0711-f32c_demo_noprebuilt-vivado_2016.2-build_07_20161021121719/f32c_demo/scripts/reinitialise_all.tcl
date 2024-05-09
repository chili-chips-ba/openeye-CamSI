# --------------------------------------------------------------------
# --   *****************************
# --   *   Trenz Electronic GmbH   *
# --   *   Holzweg 19A             *
# --   *   32257 Bünde             *
# --   *   Germany                 *
# --   *****************************
# --------------------------------------------------------------------
# --$Autor: Hartfiel, John $
# --$Email: j.hartfiel@trenz-electronic.de $
# --$Create Date:2016/02/08 $
# --$Modify Autor: Hartfiel, John $
# --$Modify Date: 2016/04/19 $
# --------------------------------------------------------------------
# --------------------------------------------------------------------

proc reinitialise {} {
  puts "Info:(TE) Current directory: [pwd]"
  set cur [pwd]
  cd ..
  # -----------------------------------------------------------------------------------------------------------------------------------------
  # load scripts
  # -----------------------------------------------------------------------------------------------------------------------------------------
  source ./scripts/script_settings.tcl
  source ./scripts/script_environment.tcl
  source ./scripts/script_vivado.tcl
  source ./scripts/script_te_utils.tcl
  source ./scripts/script_designs.tcl
  source ./scripts/script_external.tcl
  source ./scripts/script_usrcommands.tcl
  source ./scripts/script_sdsoc.tcl
  #sources from other programs:
  # source ./scripts/main.tcl
  # source ./scripts/hsi.tcl
  #currently SDSOC Runs only with batch start
  # -----------------------------------------------------------------------------------------------------------------------------------------
  # finished initial functions
  # -----------------------------------------------------------------------------------------------------------------------------------------
  # -----------------------------------------------------------------------------------------------------------------------------------------
  # initial variables
  # -----------------------------------------------------------------------------------------------------------------------------------------
  if {[catch {TE::INIT::basic_inits} result]} {abort_status "Error Initialisation..."; create_allboardfiles_status; puts "Error:(TE) Script (TE::INIT::basic_inits) failed: $result."; return -code error}
  #------
  puts "Info:(TE) Following Attributes currently not refreshed:TE::VIVADO_AVAILABLE,TE::LABTOOL_AVAILABLE,TE::SDK_AVAILABLE, TE::SDSOC_AVAILABLE+Xilinx SDSOC Scripts"
  set projectname "NA"
  set BOARD ""
  if {[file exists ${TE::BASEFOLDER}/design_basic_settings.cmd]} {
    set fp [open "${TE::BASEFOLDER}/design_basic_settings.cmd" r]
    set file_data [read $fp]
    close $fp
    set tmp [split $file_data "\n"]
    foreach t $tmp {
      if {[string match "@set PARTNUMBER=*" $t] } {
        set splittstring [split $t "="]
        set BOARD [lindex $splittstring [expr [llength $splittstring]-1]]
      }
      if {[string match "@set ZIP_PATH=*" $t] } {
        set splittstring [split $t "="]
        set TE::ZIP_PATH [lindex $splittstring [expr [llength $splittstring]-1]]
        puts "Info:(TE) Restore ZIP path from design_basic_settings.cmd."
        puts "Info:(TE) TE::ZIP_PATH: ${TE::ZIP_PATH}."
      }
      if {[string match "@set XILINXGIT_DEVICETREE=*" $t] } {
        set splittstring [split $t "="]
        set TE::XILINXGIT_DEVICETREE [lindex $splittstring [expr [llength $splittstring]-1]]
        puts "Info:(TE) Restore XILINXGIT_DEVICETREE path from design_basic_settings.cmd."
        puts "Info:(TE) TE::XILINXGIT_DEVICETREE: ${TE::XILINXGIT_DEVICETREE}."
      }
      if {[string match "@set XILINXGIT_UBOOT=*" $t] } {
        set splittstring [split $t "="]
        set TE::XILINXGIT_UBOOT [lindex $splittstring [expr [llength $splittstring]-1]]
        puts "Info:(TE) Restore XILINXGIT_UBOOT path from design_basic_settings.cmd."
        puts "Info:(TE) TE::XILINXGIT_UBOOT: ${TE::XILINXGIT_UBOOT}."
      }
      if {[string match "@set XILINXGIT_LINUX=*" $t] } {
        set splittstring [split $t "="]
        set TE::XILINXGIT_LINUX [lindex $splittstring [expr [llength $splittstring]-1]]
        puts "Info:(TE) Restore XILINXGIT_LINUX path from design_basic_settings.cmd."
        puts "Info:(TE) TE::XILINXGIT_LINUX: ${TE::XILINXGIT_LINUX}."
      }
    }
  }
  if {[catch {set projectname [get_projects]} result]} {
    puts "Info:(TE) Reinitial Vivado Labtools."
    puts "Info:(TE) Restore Board variable from design_basic_settings.cmd."
    if {[catch {TE::INIT::init_board [TE::BDEF::find_id $BOARD] 0} result]} {set cur [pwd];puts "Error:(TE) Script (TE::INIT::init_board /[TE::BDEF::find_id/]) failed: $result."; return -code error}
    cd $TE::VLABPROJ_PATH
  } else {
    puts "Info:(TE) Reinitial Vivado."
    set pfolder [file tail [pwd]]
    cd  $cur
    if {$pfolder != $projectname} {set cur [pwd]; puts "Error:(TE) Inconsistent project name, get project [get_projects], expected $pfolder from project folder"; return -code error}
    cd ..
    #initial vivado variables 
    if {[catch {TE::VIV::restore_scriptprops} result]} {set cur [pwd]; puts "Error:(TE) Script (TE::VIV::restore_scriptprops) failed: $result."; return -code error}
    cd $TE::VPROJ_PATH
  }
  # -----------------------------------------------------------------------------------------------------------------------------------------
  # finished initial variables
  # -----------------------------------------------------------------------------------------------------------------------------------------




  # -----------------------------------------------------------------------------------------------------------------------------------------
}
# -----------------------------------------------------------------------------------------------------------------------------------------
#  run reinitialisation
# -----------------------------------------------------------------------------------------------------------------------------------------
reinitialise
# -----------------------------------------------------------------------------------------------------------------------------------------
# finished run reinitialisation
# -----------------------------------------------------------------------------------------------------------------------------------------