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
    echo "Linux SMB Administration"
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
    #1=exist, 0=doesn't exist
    _linuxexist=$(grep -c "^$_user\:" /etc/passwd)
    _smbexist=$(pdbedit $_user 2> /dev/null| grep -c "^$_user")
}

#create default share group
function CheckGroupExist(){
    #1=exist, 0=doesn't exist
    _groupexist=$(grep -w -c "^$_group" /etc/group)
}

#create share dir 
function CreateMountsDir(){
    if ! [[ -d $_smb_mount_dir ]]; then
        mkdir -p $_smb_mount_dir
    fi
}

#create mount .bat file
function CreatBatFile(){
    CreateMountsDir
    echo "net use $_df_smb_svr /del /y" > $_smb_mount_dir/$_user-smb.bat   
    echo "net use s: $_df_smb_svr /user:$_user $_smbpass" >> $_smb_mount_dir/$_user-smb.bat 
    echo "The user mount file is located at: $_smb_mount_dir/$_user-smb.bat"
}

########################TABLE PRINTING########################
function printTable()
{
    local -r delimiter="${1}"
    local -r data="$(removeEmptyLines "${2}")"

    if [[ "${delimiter}" != '' && "$(isEmptyString "${data}")" = 'false' ]]
    then
        local -r numberOfLines="$(wc -l <<< "${data}")"

        if [[ "${numberOfLines}" -gt '0' ]]
        then
            local table=''
            local i=1

            for ((i = 1; i <= "${numberOfLines}"; i = i + 1))
            do
                local line=''
                line="$(sed "${i}q;d" <<< "${data}")"

                local numberOfColumns='0'
                numberOfColumns="$(awk -F "${delimiter}" '{print NF}' <<< "${line}")"

                # Add Line Delimiter

                if [[ "${i}" -eq '1' ]]
                then
                    table="${table}$(printf '%s#+' "$(repeatString '#+' "${numberOfColumns}")")"
                fi

                # Add Header Or Body

                table="${table}\n"

                local j=1

                for ((j = 1; j <= "${numberOfColumns}"; j = j + 1))
                do
                    table="${table}$(printf '#| %s' "$(cut -d "${delimiter}" -f "${j}" <<< "${line}")")"
                done

                table="${table}#|\n"

                # Add Line Delimiter

                if [[ "${i}" -eq '1' ]] || [[ "${numberOfLines}" -gt '1' && "${i}" -eq "${numberOfLines}" ]]
                then
                    table="${table}$(printf '%s#+' "$(repeatString '#+' "${numberOfColumns}")")"
                fi
            done

            if [[ "$(isEmptyString "${table}")" = 'false' ]]
            then
                #user one of those
                #echo -e "${table}" | column -s '#' -t | awk '/^\+/{gsub(" ", "-", $0)}1'
                echo -e "${table}" | column -s '#' -t | awk '/\+/{gsub(" ", "-", $0)}1' | cut -c 3-
            fi
        fi
    fi
}

function removeEmptyLines()
{
    local -r content="${1}"

    echo -e "${content}" | sed '/^\s*$/d'
}

function repeatString()
{
    local -r string="${1}"
    local -r numberToRepeat="${2}"

    if [[ "${string}" != '' && "${numberToRepeat}" =~ ^[1-9][0-9]*$ ]]
    then
        local -r result="$(printf "%${numberToRepeat}s")"
        echo -e "${result// /${string}}"
    fi
}

function isEmptyString()
{
    local -r string="${1}"

    if [[ "$(trimString "${string}")" = '' ]]
    then
        echo 'true' && return 0
    fi

    echo 'false' && return 1
}

function trimString()
{
    local -r string="${1}"

    sed 's,^[[:blank:]]*,,' <<< "${string}" | sed 's,[[:blank:]]*$,,'
}

#printTable ":"  "$(cat $_user_final)"		\\how to use