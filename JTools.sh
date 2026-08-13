#!/bin/bash

####################
### Variables    ###
####################
VM_DIR="$HOME/JTools/.qemu-vm" 
CONFIG_DIR="$VM_DIR/config-vm"
DISK_DIR="$VM_DIR/disks"

#################
### Funciones ###
#################
CREATE_STRUCTURE(){
	mkdir /home/$USER/JTools/.qemu-vm
	mkdir /home/$USER/JTools/.qemu-vm/disks
	mkdir /home/$USER/JTools/.qemu-vm/config-vm
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
    [1] Create.
    [2] Start.
    [3] Delete.
    [4] Stored VMs.
    [0] Exit.
═════════════════════════════════════════════════════════
EOF
    read -p "    Enter your order: " optionMAIN_QEMU
    case $optionMAIN_QEMU in 

    	1)
        read -p "    VM name: " nameVM
        read -e -p "    Disk name: " name
        read -p "    Disk size (GB): " size
            disk="$VM_DIR/disks/${name}.qcow2"
                qemu-img create -f qcow2 "$disk" "${size}G"

        read -p "    RAM (MB): " ram
        read -p "    CPUs: " cpu
        read -e -p "    ISO location: " iso
            qemu-system-x86_64 -m "$ram" -smp "$cpu" --enable-kvm -boot d -cdrom "$iso" -drive file="$disk",format=qcow2 -nic user,model=e1000 &

cat > "$CONFIG_DIR/${nameVM}.cfg" << EOF
    
 NAME=$nameVM   
 RAM=$ram       
 CPU=$cpu       
 ISO=$iso       
 DISK=$disk         
EOF
    	;;

    	2)
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
    	;;

    	3)
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
    	;;

    	4)
        clear
        echo ""
            echo -e " \e[1m   Stored Virtual Machines: \e[0m"
                cat "$CONFIG_DIR"/*.cfg
        echo ""    
            read -n1 -s -r -p "    Press any key to continue..."    
         
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

####################################
### Estructura de funcionamiento ###
####################################
STRUCTURE(){
while true; do
	clear

cat << "EOF"

 █████                     █████              ████  ████ 
▒▒███                     ▒▒███              ▒▒███ ▒▒███ 
 ▒███  ████████    █████  ███████    ██████   ▒███  ▒███ 
 ▒███ ▒▒███▒▒███  ███▒▒  ▒▒▒███▒    ▒▒▒▒▒███  ▒███  ▒███ 
 ▒███  ▒███ ▒███ ▒▒█████   ▒███      ███████  ▒███  ▒███ 
 ▒███  ▒███ ▒███  ▒▒▒▒███  ▒███ ███ ███▒▒███  ▒███  ▒███ 
 █████ ████ █████ ██████   ▒▒█████ ▒▒████████ █████ █████
▒▒▒▒▒ ▒▒▒▒ ▒▒▒▒▒ ▒▒▒▒▒▒     ▒▒▒▒▒   ▒▒▒▒▒▒▒▒ ▒▒▒▒▒ ▒▒▒▒▒ 
═════════════════════════════════════════════════════════
    [1] Install in Debian GNU/Linux.
    [2] Install in ArchLinux.
    [3] Install in Fedora.
    [4] Only create structure.
    [0] Exit.
═════════════════════════════════════════════════════════
EOF
	read -p "    Enter your order: " optionMAIN_STRUCTURE
	case $optionMAIN_STRUCTURE in

		1) 
		sudo apt install -y qemu-system-x86 ufw docker.io 
		CREATE_STRUCTURE
		;;

		2) 
		sudo pacman -S --needed --noconfirm qemu-desktop ufw docker 
		CREATE_STRUCTURE
		;;

		3) 
		sudo dnf install -y qemu-system-x86 ufw docker 
		CREATE_STRUCTURE
		;;

		4)
		CREATE_STRUCTURE
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

################
### UFW Menu ###
################
UFW_MENU(){
while true; do
	clear

cat << "EOF"

 █████  █████ ███████████ █████   ███   █████
▒▒███  ▒▒███ ▒▒███▒▒▒▒▒▒█▒▒███   ▒███  ▒▒███
 ▒███   ▒███  ▒███   █ ▒  ▒███   ▒███   ▒███
 ▒███   ▒███  ▒███████    ▒███   ▒███   ▒███
 ▒███   ▒███  ▒███▒▒▒█    ▒▒███  █████  ███
 ▒███   ▒███  ▒███  ▒      ▒▒▒█████▒█████▒
 ▒▒████████   █████          ▒▒███ ▒▒███
  ▒▒▒▒▒▒▒▒   ▒▒▒▒▒            ▒▒▒   ▒▒▒
═════════════════════════════════════════════════════════
  --- Status firewall ---
    [1] Enable UFW.
    [2] Disable UFW.
    [3] Reset UFW.

  --- Ports ---
    [4] Allow port.
    [5] Deny port.

  --- Rules ---
    [6] List rules.
    [7] Delete rules.

    [0] Exit.
═════════════════════════════════════════════════════════
EOF
	read -p "    Enter your order: " optionMAIN_UFW
	case $optionMAIN_UFW in

		1)
		sudo ufw enable
		;;

		2)
		sudo ufw disable
		;;

		3)
		sudo ufw reset	
		;;

		4)
		echo ""
		read -p "    Port: " idPORT_allow
		read -p "    Protocol (TCP/UDP): " protocolPORT_allow
		sudo ufw allow "$idPORT_allow"/"$protocolPORT_allow"	
		;;

		5)
		echo ""
		read -p "    Port: " idPORT_deny
		read -p "    Protocol (TCP/UDP): " protocolPORT_deny
		sudo ufw deny "$idPORT_deny"/"$protocolPORT_deny"
		;;

		6)
		echo ""
		clear
		sudo ufw status numbered
		echo ""
		read -n1 -s -r -p "    Press any key to continue..."
		;;

		7)
		echo ""
		read -p "    Rule number: " idRULE
		sudo ufw delete "$idRULE"
		;;

		0)
		clear
		return
		;;

		*)
		echo "Order your found."
		sleep 2	
		;;
esac
done
}

###################
### Docker Menu ###
###################
DOCKER_MENU(){
while true; do
	clear

cat << "EOF"

 ██████████                     █████
▒▒███▒▒▒▒███                   ▒▒███
 ▒███   ▒▒███  ██████   ██████  ▒███ █████  ██████  ████████
 ▒███    ▒███ ███▒▒███ ███▒▒███ ▒███▒▒███  ███▒▒███▒▒███▒▒███
 ▒███    ▒███▒███ ▒███▒███ ▒▒▒  ▒██████▒  ▒███████  ▒███ ▒▒▒
 ▒███    ███ ▒███ ▒███▒███  ███ ▒███▒▒███ ▒███▒▒▒   ▒███
 ██████████  ▒▒██████ ▒▒██████  ████ █████▒▒██████  █████
▒▒▒▒▒▒▒▒▒▒    ▒▒▒▒▒▒   ▒▒▒▒▒▒  ▒▒▒▒ ▒▒▒▒▒  ▒▒▒▒▒▒  ▒▒▒▒▒
═════════════════════════════════════════════════════════════
  --- Containers ---
    [1] Create container.
    [2] Start container.
    [3] Stop container.
    [4] Restart container.
    [5] Delete container.
    [6] List containers.

  --- Images ---
    [7] List images.
    [8] Pull image.
    [9] Delete image.

  --- Docker Compose ---
    [10] Start Compose.
    [11] Stop Compose.

    [0] Exit.
═════════════════════════════════════════════════════════════
EOF
	read -p "    Enter your order: " optionMAIN_DOCKER
	case $optionMAIN_DOCKER in

		1)
			
		;; 
	
		2)
			
		;; 
	
		3)
			
		;; 
	
		4)
			
		;; 
	
		5)
			
		;; 
	
		6)
			
		;; 
	
		7)
			
		;; 
	
		8)
			
		;; 
	
		9)
			
		;; 
	
		10)
			
		;; 
	
		11)
			
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

################
### SSH Menu ###
################
SSH_MENU(){
while true; do
	clear

cat << "EOF"

  █████████   █████████  █████   █████
 ███▒▒▒▒▒███ ███▒▒▒▒▒███▒▒███   ▒▒███
▒███    ▒▒▒ ▒███    ▒▒▒  ▒███    ▒███
▒▒█████████ ▒▒█████████  ▒███████████
 ▒▒▒▒▒▒▒▒███ ▒▒▒▒▒▒▒▒███ ▒███▒▒▒▒▒███
 ███    ▒███ ███    ▒███ ▒███    ▒███
▒▒█████████ ▒▒█████████  █████   █████
 ▒▒▒▒▒▒▒▒▒   ▒▒▒▒▒▒▒▒▒  ▒▒▒▒▒   ▒▒▒▒▒
═════════════════════════════════════════════════════════
    [1] Start
    [1] Connect by SSH.                                  
    [2] Connect by SSH. (localhost via port 2222)        
    [3] Send by SSH.                                     
    [4] Send by SSH. (localhost via port 2222)          
    [5] Send directory by SSH.                           
    [6] Send directory by SSH. (localhost via port 2222) 
    [0] Exit.
═════════════════════════════════════════════════════════
EOF
	read -p "    Enter your order: " optionMAIN_SSH
	case $optionMAIN_SSH in

		1) 
		read -p "Enter IP address: " optionIP
	  	read -p "Enter user name: " optionNAME
		ssh "$optionNAME@$optionIP"	  
		;;

		2)
		read -p "Enter user name: " optionNAME_SSH_LOCALHOST
		ssh -p 2222 "$optionNAME_SSH_LOCALHOST"@localhost
		;;

		3)
		read -p "Enter location of the file: " optionFILE_SCP_FILE
		read -p "Enter user name: " optionNAME_SCP_FILE
		read -p "Enter IP address: " optionIP_SCP_FILE
		read -p "Enter the destination: " optionDESTINATION_SCP_FILE
		scp "$optionFILE_SCP_FILE" "$optionNAME_SCP_FILE@$optionIP_SCP_FILE:$optionDESTINATION_SCP_FILE"
		;;

		4)
		read -p "Enter location of the file: " optionFILE_SCP_FILE_LOCALHOST
		read -p "Enter user name: " optionNAME_SCP_FILE_LOCALHOST
		read -p "Enter the destination: " optionDESTINATION_SCP_FILE_LOCALHOST
		scp -P 2222 "$optionFILE_SCP_FILE_LOCALHOST" "$optionNAME_SCP_FILE_LOCALHOST"@localhost:"$optionDESTINATION_SCP_FILE_LOCALHOST"
		;;

		5)
		read -p "Enter location of the directory: " optionDIRECTORY_SCP_DIRECTORY
		read -p "Enter user name: " optionNAME_SCP_DIRECTORY
		read -p "Enter IP address: " optionIP_SCP_DIRECTORY
		read -p "Enter the destination: " optionDESTINATION_SCP_DIRECTORY
		scp -r "$optionDIRECTORY_SCP_DIRECTORY" "$optionNAME_SCP_DIRECTORY@$optionIP_SCP_DIRECTORY:$optionDESTINATION_SCP_DIRECTORY"
		;;

		6)
		read -p "Enter location of the directory: " optionDIRECTORY_SCP_DIRECTORY_LOCALHOST
		read -p "Enter user name: " optionNAME_SCP_DIRECTORY_LOCALHOST
		read -p "Enter the destination: " optionDESTINATION_SCP_DIRECTORY_LOCALHOST
		scp -P 2222 -r "$optionDIRECTORY_SCP_DIRECTORY_LOCALHOST" "$optionNAME_SCP_DIRECTORY_LOCALHOST"@localhost:"$optionDESTINATION_SCP_DIRECTORY_LOCALHOST"
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
    [1] Install operating structure.
    [2] KVM/QEMU manager.
    [3] Firewall UFW.
    [4] SSH protocol.
    [0] Exit.
═════════════════════════════════════════════════════════
EOF
    read -p "    Enter your order: " optionMAIN
    case $optionMAIN in
        
        1)
	STRUCTURE	
        ;;

	2)
	QEMU_MENU
        ;;

        3)
    	UFW_MENU
        ;;

	4)
	SSH_MENU	
	;;

        5)
	DOCKER_MENU
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
