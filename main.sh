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
source "$_working_dir/group-admin.sh"

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

#user administration
function GroupAdministration(){
    while true
    do
        MenuHeader
        echo "1. Create new group"
        echo "2. Add user to group"
        echo "3. Remove user from group"
        echo "4. List group members"
        echo "5. List all groups"
        echo ""
        echo "9. Back"
        echo "0. Exit"
        echo "--------------------------------------------"
        printf "Choose your option: "
        read _opt
        if ! [[ "$_opt" =~ ^[0-9]+$ ]]; then
            WrongInput
        elif [[ "$_opt" -eq "1" ]]; then
            CreateNewGroup
        elif [[ "$_opt" -eq "2" ]]; then
            AddUserToGroup
        elif [[ "$_opt" -eq "3" ]]; then
            RemoveUserFromGroup
        elif [[ "$_opt" -eq "4" ]]; then
            ListGroupMembers
        elif [[ "$_opt" -eq "5" ]]; then
            ListAllGroup
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
    while true
    do
        MenuHeader
        echo "1. View logged-in users"
        echo "2. View all locked files"
        echo "3. View specific user details"
        echo ""
        echo "9. Back"
        echo "0. Exit"
        echo "--------------------------------------------"
        printf "Choose your option: "
        read _opt
        if ! [[ "$_opt" =~ ^[0-9]+$ ]]; then
            WrongInput
        elif [[ "$_opt" -eq "1" ]]; then
            ViewLoggedInUser
        elif [[ "$_opt" -eq "2" ]]; then
            ViewLockedFiles
        elif [[ "$_opt" -eq "3" ]]; then
            ViewUserDetails
        elif [[ "$_opt" -eq "9" ]]; then
            return
        elif [[ "$_opt" -eq "0" ]]; then
            exit 0
        else
            WrongInput
        fi
    done
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
        elif [[ "$_opt" -eq "0" ]]; then
            exit 0
        else
            WrongInput
        fi
    done
}

#start the menu
Menu
