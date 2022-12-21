
#create new user
function CreateNewUser(){
    #create new random password
    _act="create"
    _smbpass=`pwgen 20 1`

    printf "Please type a new username: "
    read _user
    if [[ -z $_user ]]; then
        echo "The username is empty. Try again..."
        PressEnterKey
    elif ! [[ UserValidation ]]; then
        WrongInput
    else
        CheckUserExist 

        #add linux user
        useradd $_user > /dev/null
        usermod -aG $_df_group $_user > /dev/null
        #add smbuser
        if [[ $_smbexist -eq 1 ]];then
            (echo $_smbpass ; echo $_smbpass)|smbpasswd $_user 
        else 
            (echo $_smbpass ; echo $_smbpass)|smbpasswd -a $_user 
        fi
        #create .bat file
        CreateMountsDir
        echo "net use $_df_smb_svr /del /y" > $_smb_mount_dir/$_user-smb.bat   
        echo "net use s: $_df_smb_svr /user:$_user $_smbpass" >> $_smb_mount_dir/$_user-smb.bat 
        echo "User '$_user' has been created"
        echo "The user mount file is located at: $_smb_mount_dir/$_user-smb.bat"
        PressEnterKey
    fi
}