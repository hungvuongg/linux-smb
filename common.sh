#press enter key 
function PressEnterKey(){
    echo "Press Enter to continue..."
    read enterKey
    #exec $_scriptfile
}

#input validation 
function WrongInput(){
    echo "Invalid Input. Press Enter to continue..."
    read enterKey
}

#menu header
function MenuHeader(){
    clear
    echo "Current user: $_id @ $_date"
    echo "Script by VuongNguyen               Version: $_ver"
    echo "------------------------------------------------"
}