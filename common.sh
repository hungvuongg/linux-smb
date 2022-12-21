#press enter key 
function PressEnterKey(){
    echo "Press Enter to continue..."
    read enterKey
}

#input validation 
function WrongInput(){
    echo "Invalid Input. Press Enter to continue..."
    read enterKey
}

#menu header
function MenuHeader(){
    clear
    echo "User: $_id @ $_date"
    echo "Script by VuongNguyen           Version: $_ver"
    echo "--------------------------------------------"
}

#user validation
function UserValidation(){
    if [[ "$_user" =~ ^[0-9a-zA-Z]+$ ]]; then
        (exit 0)
    else
        (exit 1)
    fi
}

#check user existence
function CheckUserExist(){
    _linuxexist=$(grep -c "^$_user\:" /etc/passwd)
    _smbexist=$(pdbedit $_user | grep -c "^$_user")
    if [[ "$_act" == "create" ]]; then
        if [[ $_linuxexist -eq 1 && $_smbexist -eq 1 ]]; then
            echo "User '$_user' exists. Make sure that user '$_user' is not disabled"
            PressEnterKey
        fi
    elif [[ "$_act" == "disable" || "$_act" == "delete" ]]; then
        if ! [[ $_linuxexist -eq 1 && $_smbexist -eq 1 ]]; then
            echo "User '$_user' does not exists.Please try again"
            PressEnterKey
        fi
    fi
}

#create share dir 
function CreateMountsDir(){
    if ! [[ -d $_smb_mount_dir ]]; then
        mkdir -p $_smb_mount_dir
    fi
}

#create default share group
function CheckGroupExist(){
    _groupexist=$(grep -w -c "^$_groupname" /etc/group)
    if [ $_groupexist -eq 1 ]; then
        echo "Group '$_groupname' exists! Please try another name..."
    else
        if ! [[ "$_groupname" =~ ^[0-9a-zA-Z]+$ ]]; then
                    echo "Wrong input. Please type again."
                    echo "Press Enter to continue..."
                    read enterKey
        else
            groupadd $_groupname    
            echo "Group '$_groupname' have been created"
                echo "Press Enter to continue..."
                    read enterKey   
        fi
    fi
}