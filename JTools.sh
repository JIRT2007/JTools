#!/bin/bash

####################
### Notas        ###
####################
    # BOLD TEXT ANSI: \e[1m . . . \e[0m
        ## Dentro del EOF se precisa previamente declarar la expansion de variables
            ### BOLD="\e[1m"
            ### RESET="\e[0m"

    # ESTRUCTURAS UNICODE: ╔ ╗ ╚ ╝ ║ ═ ╠ ╣

####################
### Variables    ###
####################
VM_DIR="$HOME/JTools/qemu-vm"
CONFIG_DIR="$VM_DIR/config"
DISK_DIR="$VM_DIR/disks"


####################
### Ver VMs      ###
####################
viewVM(){
    clear
    echo ""
    echo -e " \e[1m   Stored Virtual Machines: \e[0m"
            cat "$CONFIG_DIR"/*.cfg
    echo ""    
    read -n1 -s -r -p "    Press any key to continue..."    
        return   
}

####################
### Eliminar VMs ###
####################
deleteVM(){
    echo "    Existing VMs configurations:"
	echo ""
    ls "$CONFIG_DIR"/*.cfg | xargs -n1 basename
    	echo ""  
    read -e -p "    Enter the name of the VM configuration: " vmDEL

        if [ -f "$CONFIG_DIR/$vmDEL" ]; then # -f significa "¿Existe el archivo guardado en la variable $vm?"
            source "$CONFIG_DIR/$vmDEL"
                rm "$CONFIG_DIR/$vmDEL"
                rm "$DISK"
        else 
            echo " Virtual machine does not exist."
        fi
}

####################
### Iniciar VMs  ###
####################
startVM(){
    echo "    Existing VMs configurations:"
    echo ""
        ls "$CONFIG_DIR"/*.cfg | xargs -n1 basename  
    echo ""  
    read -e -p "    Enter the name of the VM configuration: " vm   
    
        if [ -f "$CONFIG_DIR/$vm" ]; then # -f significa "¿Existe el archivo guardado en la variable $vm?"
            source "$CONFIG_DIR/$vm" #source es un comando de Bash que lee y ejecuta el contenido de un archivo en la shell actual.
                qemu-system-x86_64 -m $RAM -smp $CPU --enable-kvm -drive file=$DISK,format=qcow2 -nic user,model=e1000,hostfwd=tcp::2222-:22 &
        else 
            echo " Virtual machine does not exist."
        fi
}

####################
### Crear VMs    ###
####################
createVM(){
    read -p "    VM name: " nameVM
    read -e -p "    Disk name: " name
    read -p "    Disk size (GB): " size
        disk="$VM_DIR/disks/${name}.qcow2"
            qemu-img create -f qcow2 "$disk" "${size}G"

    read -p "    RAM (MB): " ram
    read -p "    CPUs: " cpu
    read -e -p "    ISO location: " iso
        qemu-system-x86_64 -m "$ram" -smp "$cpu" --enable-kvm -boot d -cdrom "$iso" -drive file="$disk",format=qcow2 -nic user,model=e1000 &

cat > "$VM_DIR/config/${nameVM}.cfg" << EOF
    
 NAME=$nameVM   
 RAM=$ram       
 CPU=$cpu       
 ISO=$iso       
 DISK=$disk         
EOF
    
}

#################
### Menu QEMU ###
#################
QEMU_MENU(){
while true; do
    clear

cat << "EOF"

    ██████    ██████████ ██████   ██████ █████  █████
  ███▒▒▒▒███ ▒▒███▒▒▒▒▒█▒▒██████ ██████ ▒▒███  ▒▒███ 
 ███    ▒▒███ ▒███  █ ▒  ▒███▒█████▒███  ▒███   ▒███ 
▒███     ▒███ ▒██████    ▒███▒▒███ ▒███  ▒███   ▒███ 
▒███   ██▒███ ▒███▒▒█    ▒███ ▒▒▒  ▒███  ▒███   ▒███ 
▒▒███ ▒▒████  ▒███ ▒   █ ▒███      ▒███  ▒███   ▒███ 
 ▒▒▒██████▒██ ██████████ █████     █████ ▒▒████████  
   ▒▒▒▒▒▒ ▒▒ ▒▒▒▒▒▒▒▒▒▒ ▒▒▒▒▒     ▒▒▒▒▒   ▒▒▒▒▒▒▒▒   
═════════════════════════════════════════════════════════
    [1] Create virtual machine.
    [2] Start virtual machine.
    [3] Delete virtual machine.
    [4] Stored virtual machines.
    [0] Exit.
═════════════════════════════════════════════════════════
EOF

    read -p "    Enter your order: " optionMAIN_QEMU
    case $optionMAIN_QEMU in 

        1)
            createVM
        ;;

        2)
            startVM
        ;;

        3)
            deleteVM
        ;;

        4)
            viewVM
        ;;

        0)
            clear
            return
        ;;

        *)
            echo "Order not found."
            sleep 2
        ;;

esac
done
}

####################
### Menu inicial ###
####################
while true; do
    clear 

cat << "EOF"

       █████ ███████████                   ████         
      ▒▒███ ▒█▒▒▒███▒▒▒█                  ▒▒███         
       ▒███ ▒   ▒███  ▒   ██████   ██████  ▒███   █████ 
       ▒███     ▒███     ███▒▒███ ███▒▒███ ▒███  ███▒▒  
       ▒███     ▒███    ▒███ ▒███▒███ ▒███ ▒███ ▒▒█████ 
 ███   ▒███     ▒███    ▒███ ▒███▒███ ▒███ ▒███  ▒▒▒▒███
▒▒████████      █████   ▒▒██████ ▒▒██████  █████ ██████ 
 ▒▒▒▒▒▒▒▒      ▒▒▒▒▒     ▒▒▒▒▒▒   ▒▒▒▒▒▒  ▒▒▒▒▒ ▒▒▒▒▒▒  
═════════════════════════════════════════════════════════
    [1] Install programs.
    [2] KVM/QEMU manager.
    [3] Firewall UFW.
    [4] Docker compose.
    [0] Exit.
═════════════════════════════════════════════════════════
EOF
    read -p "    Enter your order: " optionMAIN
    case $optionMAIN in
        
        1)
        
        ;;

        2)
            QEMU_MENU
        ;;

        3)

        ;;

        4)

        ;;

        0)
            clear
            exit 0
        ;;

        *)
            echo "Order not found."
            sleep 2
        ;;

esac
done
