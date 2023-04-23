
#create new user
function CreateNewUser(){
    printf "Please type a new username: "
    read _user
    if [[ -z $_user ]]; then
        echo "The username is empty. Try again..."
    elif ! [[ UserValidation ]]; then
        WrongInput
    else
        CheckUserExist 
        #add linux user
        if [[ $_linuxexist -eq 0 ]]; then 
            useradd $_user > /dev/null 2>&1
            usermod -aG $_df_group $_user > /dev/null 2>&1
        fi
        #add smbuser
        if [[ $_smbexist -eq 1 ]];then
            echo "User '$_user' exist. Please try to reset password for this user"
            echo "Or you can try again with difference username"
        else 
            (echo $_smbpass ; echo $_smbpass)|smbpasswd -a $_user > /dev/null 2>&1  
            echo "User '$_user' has been created"
            #create .bat file
            CreatBatFile
        fi
    fi
    PressEnterKey
}

#remove user
function RemoveUser(){
    printf "Type the user that you want to remove: "
    read -r _user
    CheckUserExist
    if [[ $_smbexist -eq 0 ]];then
        echo "User '$_user' doesn't exist. Please try again."
    else
        smbpasswd -x $_user > /dev/null 2>&1
        echo "User '$_user' has been removed. The Linux backend user still remaining exists"
    fi
    PressEnterKey
}

#disable user
function DisableUser(){
    printf "Type the user that you want to disable: "
    read -r _user
    CheckUserExist
    if [[ $_smbexist -eq 0 ]];then
        echo "User '$_user' doesn't exist. Please try again."
    else
        smbpasswd -d $_user > /dev/null 2>&1 
        echo "User '$_user' has been disabled. The Linux backend user still remaining enabled"
    fi
    PressEnterKey
}

#reset user pass
function ResetUserPassword(){
    printf "Type the user that you want to reset the password: "
    read -r _user
    CheckUserExist
    if [[ $_smbexist -eq 0 ]];then
        echo "User '$_user' doesn't exist. Please try again."
    else
        (echo $_smbpass ; echo $_smbpass)|smbpasswd $_user 
        echo "The password for user '$_user' has been reset."
        #re-create the new bat file with the new password
        CreatBatFile
    fi
    PressEnterKey
}

#list all users
function ListAllUsers(){
    _user_list="/tmp/_user_list.txt" 
    #get user list from samba
    pdbedit -L > $_user_list
    #get the disabled users
    _line=1
    for user in $(cat $_user_list|awk -F ":" '{print $1}')
    do
         if pdbedit -v -u $user|grep "Account Flags:"|grep -oP '(?<=\[).*(?=\])'|grep -oi "D" > /dev/null 2>&1; then
            #insert ":Yes" to line that contain the disabled user
            sed -i "$_line s/$/:Yes&/" $_user_list
        else   
            #insert empty slot
            sed -i "$_line s/$/:-&/" $_user_list
        fi
        _line=$((_line+1))
    done
    #insert table header
    sed -i "1i Name:ID:Group:Disabled" $_user_list
    #insert the '-' to the empty slot
    sed -i "s/::/:-:/g" $_user_list
    #print the results
    echo "The current users: "
    printTable ":"  "$(cat $_user_list)"
    PressEnterKey
}

