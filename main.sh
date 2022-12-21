#!/bin/bash

#Linux SMB Administration Script 
#Author:        VuongNguyen
#Version:       1.0     
#DateRelease:   Dec 2022

_working_dir="/root/linux-smb"

#source common functions
source "$_working_dir/common.sh"

#source functions
source "$_working_dir/add-user.sh"
source "$_working_dir/delete-user.sh"
source "$_working_dir/disable-user.sh"
source "$_working_dir/disable-user.sh"

#global parameter 
_ver="1.0"
_date=$(date)
_id=$(whoami)

##########################FUNCTION LISTS##########################
#user administration
function UserAdministration(){
    clear
}

#permission administration
function PermissionAdministration(){
    clear
}

#server statuses
function ServerStatuses(){
    clear
}

#client statuses
function ClientStatuses(){
    clear
}

#menu
function Menu(){
    while true
    do
        MenuHeader
        echo "1. User Administration"
        echo "2. Permission Administration"
        echo "3. Server Statuses"
        echo "4. Client Statuses"
        echo ""
        echo "0. Exit"
        echo "------------------------------------------------"
        printf "Choose your option: "
        read _opt
        if ! [[ "$_opt" =~ ^[0-9]+$ ]]; then
            WrongInput
        elif [[ "$_opt" -eq "1" ]]; then
            UserAdministration
        elif [[ "$_opt" -eq "2" ]]; then
            PermissionAdministration
        elif [[ "$_opt" -eq "3" ]]; then
            ServerStatuses
        elif [[ "$_opt" -eq "4" ]]; then
            ClientStatuses
        elif [[ "$_opt" -eq "0" ]]; then
            exit 0
        else
            WrongInput
        fi
    done
}

#start the menu
Menu
