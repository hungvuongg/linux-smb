#view loggedin users
function ViewLoggedInUser(){
    #get the stt from smbstatus command
    smbstatus -p|sed '1d'
    PressEnterKey
}

#view locked files
function ViewLockedFiles(){
    #get the stt from smbstatus command
    smbstatus -L|sed '1d'
    PressEnterKey
}

#view user details
function ViewUserDetails(){
    printf "Please select the user: "
    read -r _user
    #get the stt from smbstatus command
    smbstatus -u $_user|sed '1d'
    PressEnterKey
}