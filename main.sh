#!/bin/bash

#Linux SMB Administration Script 
#Author:        VuongNguyen
#Version:       1.0     
#DateRelease:   Dec 2022

_working_dir="/root/linux-smb"

#source common functions
source "$_working_dir/common.sh"
source "$_working_dir/vars.sh"

#source functions
source "$_working_dir/clt-stt.sh"
source "$_working_dir/pers-admin.sh"
source "$_working_dir/svr-stt.sh"
source "$_working_dir/user-admin.sh"

#global parameter 
_ver="1.0"
_date=$(date)
_id=$(whoami)

##########################FUNCTION LISTS##########################
#user administration
function UserAdministration(){
    while true
    do
        MenuHeader
        echo "1. Create new user"
        echo "2. Reset user's password"
        echo "3. Disable user"
        echo "4. Remove user"
        echo "5. List all User"
        echo ""
        echo "9. Back"
        echo "0. Exit"
        echo "--------------------------------------------"
        printf "Choose your option: "
        read _opt
        if ! [[ "$_opt" =~ ^[0-9]+$ ]]; then
            WrongInput
        elif [[ "$_opt" -eq "1" ]]; then
            CreateNewUser
        elif [[ "$_opt" -eq "2" ]]; then
            ResetUserPassword
        elif [[ "$_opt" -eq "3" ]]; then
            DisableUser
        elif [[ "$_opt" -eq "4" ]]; then
            RemoveUser
        elif [[ "$_opt" -eq "5" ]]; then
            ListAllUsers
        elif [[ "$_opt" -eq "9" ]]; then
            return
        elif [[ "$_opt" -eq "0" ]]; then
            exit 0
        else
            WrongInput
        fi
    done
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
        echo "2. Group Administration"
        echo "3. Permission Administration"
        echo "4. Server Statuses"
        echo "5. Client Statuses"
        echo ""
        echo "0. Exit"
        echo "--------------------------------------------"
        printf "Choose your option: "
        read _opt
        if ! [[ "$_opt" =~ ^[0-9]+$ ]]; then
            WrongInput
        elif [[ "$_opt" -eq "1" ]]; then
            UserAdministration
        elif [[ "$_opt" -eq "2" ]]; then
            GroupAdministration
        elif [[ "$_opt" -eq "3" ]]; then
            PermissionAdministration
        elif [[ "$_opt" -eq "4" ]]; then
            ServerStatuses
        elif [[ "$_opt" -eq "5" ]]; then
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
