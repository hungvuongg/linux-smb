#create new group
function CreateNewGroup(){
    printf "Please type the new group name: "
    read -r _groupname
    CheckGroupExist
    if [[ $_groupexist -eq 1 ]]; then
        echo "Group '$_groupname' exist. Plese try again"
    else
        groupadd $_groupname
        echo "Group '$_groupname' has been added."
    fi
    PressEnterKey
}

#add user to group
function AddUserToGroup(){
    printf "You want to add user to the group: "
    read -r _group
    CheckGroupExist
    if [[ $_groupexist -eq 0 ]]; then
        echo "Group '$_group' dosen't exist. Plese try again"
    else
        printf "User you want to add to group '$_group': "
        read -r _user
        CheckUserExist
        if [[ $_smbexist -eq 0 ]];then
            echo "User '$_user' doesn't exist. Please try again."
        else
            usermod -aG $_group $_user
            echo "User '$_user' has been added to the group '$_group'"
        fi
    fi
    PressEnterKey
}

#remove user from group 
function RemoveUserFromGroup(){
    printf "You want to remove user from the group: "
    read -r _group
    CheckGroupExist
    if [[ $_groupexist -eq 0 ]]; then
        echo "Group '$_group' dosen't exist. Plese try again"
    else
        printf "User you want to remove from the group '$_group': "
        read -r _user
        CheckUserExist
        if [[ $_smbexist -eq 0 ]];then
            echo "User '$_user' doesn't exist. Please try again."
        else
            gpasswd -d $_user $_group > /dev/null 2>&1
            echo "User '$_user' has been removed to the group '$_group'"
        fi
    fi
    PressEnterKey
}

#list group members
function ListGroupMembers(){
    _group_mems="/tmp/_group_mems.txt"
    rm -rf $_group_mems > /dev/null 2>&1
    printf "You want to show group's members of: "
    read -r _group
    CheckGroupExist
    if [[ $_groupexist -eq 0 ]]; then
        echo "Group '$_group' dosen't exist. Plese try again"
    else
        grep -w $_group /etc/group|awk -F ":" '{print $1":"$3":"$4}' >> $_group_mems
        #insert table header
        sed -i "1i Name:ID:Members" $_group_mems
        echo "The current group info: "
        printTable ":"  "$(cat $_group_mems)"
    fi
    PressEnterKey
}

#list all group
function ListAllGroup(){
    _group_id_tmp="/tmp/_group_id_tmp.txt"
    _user_id_tmp="/tmp/_user_id_tmp.txt"
    _group_id="/tmp/_group_id.txt"
    _user_id="/tmp/_user_id.txt"
    _group_id_final="/tmp/_group_id_final.txt"
    _group_list="/tmp/_group_name.txt"
    #remove temp files
    rm -rf $_group_id > /dev/null 2>&1
    rm -rf $_user_id > /dev/null 2>&1
    rm -rf $_group_name > /dev/null 2>&1
    rm -rf $_group_id_final > /dev/null 2>&1
    rm -rf $_group_list > /dev/null 2>&1
    #get group list from linux
    cat /etc/group|awk -F ":" '{print $3}'|sort -n|sed 's/65534//g' > $_group_id_tmp
    cat /etc/passwd|awk -F ":" '{print $3}'|sort -n|sed 's/65534//g' > $_user_id_tmp
    #get gid
    for gid in $(cat $_group_id_tmp)
    do
        if [[ $gid -gt 999 ]];then
            #only get the regular gid
            echo  $gid|sort -n >> $_group_id
        fi
    done
    #get uid
    for uid in $(cat $_user_id_tmp)
    do
        if [[ $uid -gt 999 ]];then
            #only get the regular gid
            echo  $uid|sort -n >> $_user_id
        fi
    done
    #get gid that we need to print out
    diff $_group_id $_user_id|sed '1d'|awk -F "<" '{print $2}'|sed 's/ //g' >> $_group_id_final
    #get group name
    for group in $(cat /etc/group)
    do
        for gid in $(cat $_group_id_final)
        do
            echo $group|grep $gid|awk -F ":" '{print $1":"$3":"$4}' >> $_group_list
        done
    done
    #insert table header
    sed -i "1i Name:ID:Members" $_group_list
    echo "The current groups: "
    printTable ":"  "$(cat $_group_list)"
    PressEnterKey
}