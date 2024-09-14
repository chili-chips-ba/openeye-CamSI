#! /bin/sh

# --------------------------------------------------------------------
# --   *****************************
# --   *   Trenz Electronic GmbH   *
# --   *   Beendorfer Str. 23      *
# --   *   32609 Hüllhorst         *
# --   *   Germany                 *
# --   *****************************
# --------------------------------------------------------------------
# --$Autor: Hartfiel, John $
# --$Email: j.hartfiel@trenz-electronic.de $
# --$Create Date: 2021/07/27 $
# --$Modify Date: 2021/07/30 $
# --$Version: 1.0 $
# --------------------------------------------------------------------
# --------------------------------------------------------------------
# init
# get paths
bashfile_name=${0##*/}
# bashfile_path=${0%/*}
bashfile_path=`pwd`
echo -- Excecute: ${bashfile_name}
echo -- Use Path: ${bashfile_path}


# todo load from evirment if exists
# PATH_XILINX_LINUX_ORIGIN="https://github.com/<user>/linux-xlnx"
PATH_XILINX_LINUX_UPSTREAM="https://github.com/Xilinx/linux-xlnx"
PATH_XILINX_LINUX_LOCAL="./linux-xlnx"
  
# PATH_XILINX_UBOOT_ORIGIN="https://github.com/<user>/u-boot-xlnx"
PATH_XILINX_UBOOT_UPSTREAM="https://github.com/Xilinx/u-boot-xlnx"
PATH_XILINX_UBOOT_LOCAL="./u-boot-xlnx"
  
# PATH_XILINX_EMBEDDED_ORIGIN="https://github.com/<user>/embeddedsw"
PATH_XILINX_EMBEDDED_UPSTREAM="https://github.com/Xilinx/embeddedsw"
PATH_XILINX_EMBEDDED_LOCAL="./embeddedsw"

PATH_XILINX_WORK_ORIGIN="TBD"
PATH_XILINX_WORK_UPSTREAM="TBD"
PATH_XILINX_WORK_LOCAL="TBD"

GIT_TYP="TBD"
BRANCH_SOURCE="TBD"
BRANCHNAME="TBD"
PATCHNAME="TBD"


function pause(){
   read -p "$*"
}

function git_sel(){
  echo "-----------------"
  echo " Embedded (e),linux-xlnx (l), uboot-xlnx(u)"   
  echo " Select GIT (e,u,l):"   
  read newgit
  if [ "$newgit" = "e" ]; then
    GIT_TYP="embedded"
    if [ -z "$TE_GIT_PATH_XILINX_EMBEDDED_ORIGIN" ]; then
      echo "Insered your fork(origin) URL(Ex. https://github.com/<username>/embeddedsw)"   
      read newurl
      PATH_XILINX_WORK_ORIGIN=$newurl
    else
      echo " Use Enviroment paramether:$TE_GIT_PATH_XILINX_EMBEDDED_ORIGIN"  
      PATH_XILINX_WORK_ORIGIN=$TE_GIT_PATH_XILINX_EMBEDDED_ORIGIN
    fi
    PATH_XILINX_WORK_UPSTREAM=$PATH_XILINX_EMBEDDED_UPSTREAM     
    PATH_XILINX_WORK_LOCAL=$PATH_XILINX_EMBEDDED_LOCAL        
  elif [ "$newgit" = "l" ]; then
    GIT_TYP="linux-xlnx"
    if [ -z "$TE_GIT_PATH_XILINX_LINUX_ORIGIN" ]; then
      echo "Insered your fork(origin) URL(Ex. https://github.com/<username>/linux-xlnx)"   
      read newurl
      PATH_XILINX_WORK_ORIGIN=$newurl
    else
      echo " Use Enviroment paramether:$TE_GIT_PATH_XILINX_LINUX_ORIGIN"  
      PATH_XILINX_WORK_ORIGIN=$TE_GIT_PATH_XILINX_LINUX_ORIGIN
    fi
    PATH_XILINX_WORK_UPSTREAM=$PATH_XILINX_LINUX_UPSTREAM   
    PATH_XILINX_WORK_LOCAL=$PATH_XILINX_LINUX_LOCAL      
  elif [ "$newgit" = "u" ]; then
    GIT_TYP="u-boot-xlnx"
    if [ -z "$TE_GIT_PATH_XILINX_UBOOT_ORIGIN" ]; then
      echo "Insered your fork(origin) URL(Ex. https://github.com/<username>/u-boot-xlnx)"   
      read newurl
      PATH_XILINX_WORK_ORIGIN=$newurl
    else
      echo " Use Enviroment paramether:$TE_GIT_PATH_XILINX_UBOOT_ORIGIN"  
      PATH_XILINX_WORK_ORIGIN=$TE_GIT_PATH_XILINX_UBOOT_ORIGIN
    fi
    PATH_XILINX_WORK_UPSTREAM=$PATH_XILINX_UBOOT_UPSTREAM
    PATH_XILINX_WORK_LOCAL=$PATH_XILINX_UBOOT_LOCAL   
  else
    GIT_TYP="unkown"

    echo "Insered your fork(origin) URL(Ex. https://github.com/<username>/<origin name>)"   
    read newurl
    PATH_XILINX_WORK_ORIGIN=$newurl
    echo "Insered upstream URL(Ex. https://github.com/<username>/<upstream name>)"   
    read newurl
    PATH_XILINX_WORK_UPSTREAM=$newurl
    echo "Insered local work directory(Ex. ./<name>)"   
    read newurl
    PATH_XILINX_WORK_LOCAL=$newurl
  fi

  if [ "$PATH_XILINX_WORK_LOCAL" = "TBD" ]; then
    return -1
  fi

  if [ -d "$PATH_XILINX_WORK_LOCAL" ]; then
    echo " Remove: $PATH_XILINX_WORK_LOCAL"  
    sudo rm -r  $PATH_XILINX_WORK_LOCAL
  fi
  
}

function git_clone(){
  echo "-----------------"
  echo "--Clone...this takes a while..."
  git clone $PATH_XILINX_WORK_ORIGIN
  cd $PATH_XILINX_WORK_LOCAL

  git remote add upstream $PATH_XILINX_WORK_UPSTREAM
  git remote -v


  git fetch upstream
  git fetch origin
}
function git_show(){
  #show branch
  echo "-----------------"
  echo "--GIT Brunches:"
  git branch -a 
  #show all tags
  echo "-----------------"
  echo "--GIT Tags:"
  git tag
}
function git_checkout(){
   echo "-----------------"
   echo " origin (o),upstream (u), tag (t)"   
   echo " Select GIT (o,u,t):"  
   read newgit
    if [ "$newgit" = "u" ]; then
      BRANCH_SOURCE="upstream"
      echo " Select upstream name:"  
      read name
      BRANCHNAME=$name
      ##checkout upstream
      git checkout -t upstream/$BRANCHNAME
    fi
    if [ "$newgit" = "o" ]; then
      BRANCH_SOURCE="origin"
      echo " Select origin name:"  
      read name
      BRANCHNAME=$name
      ##checkout origin
      git checkout -t origin/$BRANCHNAME
    fi
    if [ "$newgit" = "t" ]; then
      BRANCH_SOURCE="tag"
      echo " Select tag name:"  
      read name
      BRANCHNAME=${name}_tag
      ##checkout tag to branch (create new branch from tag)
      git checkout tags/$name -b ${name}_tag
    fi

  ##checkout branch
  git checkout $BRANCHNAME
  ##merge upstream
  #git merge upstream/<name>
}

function git_modify(){
  #show branch
  echo "-----------------"
  echo "--Please modify sources and press enter after modification are finished"
  pause

}
function git_commit(){
  #show branch
  echo "-----------------"
  echo "--add changes..."
  git add .
  git status
  echo "-----------------"
  echo "--add changes..."
  #commit  
  git commit -m "Patch commit"
}

function git_patch(){
  #show branch
  echo "-----------------"
  echo "--Enter patch name (example: 0001-18p2_IS25LP512M-support_uboot.patch):"
  read name
  #commit  
  git format-patch HEAD~1..HEAD --stdout > ../$name
  
  export TE_GIT_PATCH="${bashfile_path}/${name}"
  export TE_GIT_PARAMETER="${GIT_TYP}|${PATH_XILINX_WORK_ORIGIN}|${BRANCH_SOURCE}|${BRANCHNAME}|${name}"
}

git_sel
git_clone
git_show
git_checkout
git_modify
git_commit
git_patch
echo "-----------------"
echo "--Process Finished, press Enter"
pause

