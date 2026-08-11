# JTools
**JTools** es un simple conjunto de herramientas de terminal desarrollado por **JIRT2007** con el objetivo de ofrecer a desarrolladores y estudiantes la posibilidad de simplificar el manejo de herramientas del ecosistema GNU/Linux mediante la ejecución de un simple script de shell. El mismo código esta desarrollado en Shell Script con la finalidad de priorizar la eficiencia, estabilidad y la auditabilidad, se destina su uso esencialmente a sistemas del ecosistema **Debian GNU/Linux** y derivados (Ubuntu, LinuxMint, ZorinOS, Devuan, etc).

## Características:
- JTools se encuentra programado íntegramente en el lenguaje del paradigma imperativo **Bash Script** y se define enteramente en un único archivo de programación, esto con el objetivo de simplificar su manejo y no mantener varios scripts que puedan dificultar el trabajo tanto de los desarrolladores como de los usuarios. JTools adopta, por filosofía del desarrollador un diseño monolítico (Un único archivo de script que define toda la lógica de programación).
- JTools ofrece diferentes funciones que son primordiales para el trabajo diarios de un desarrollador o estudiante como lo seria la creacion básica de maquinas virtuales, el manejo de contenedores mediante **Docker** o la gestión del firewall **UFW** (incorporado en muchas distribuciones de GNU/Linux y sus repositorios) entre muchas otras funciones que se implementaran.
- JTools es un proyecto de carácter académico y no busca la creación de nuevas tecnologías, simplemente facilitar el manejo de las mismas que implementa.
- Se recomienda su uso para sistemas operativos **Debian GNU/Linux** y derivados con arquitectura **x86_64** y **BASH** como shell del sistema (se puede saber cual es la que ofrece su sistema con el comando `echo $SHELL`. Esto no implica que sea estricto su uso para estos sistemas, puede ser utilizado para sistemas base **RHEL/Fedora** y **ArchLinux** pero se recomienda su uso en sistemas del ecosistema **Debian**.

## Instalación y recomendaciones: 
### Clonado del repositorio y alias:
- Instalar el programa GIT:         `sudo apt install git`
- Configurar usuario:               `git config --global user.name "Nombre de usuario de GIT"`
- Configurar correo electrónico:    `git config --global user.email "Correo de GIT"`
- Clonar repositorio:               `git clone https://github.com/JIRT2007/JTools.git`

Se recomienda para facilitar el uso del script el convertirlo en un alias para poder ejecutarlo como comando en su respectiva terminal de comandos. Esto se puede hacer editando el archivo `.bashrc` y colocar al final del mismo un alias del estilo: 
    `alias jtools='bash ~/JTools/JTools.sh'`
Luego se deberá de recargar la configuración del mismo mediante el comando `source .bashrc`. Esto permitirá que al ejecutar el comando `jtools` en la terminal se inicie el script.
Otra recomendación fundamental es ejecutar la primera opción que ofrece le menú de JTools que permite la instalación de los programas necesarios y la generación de la estructura de directorios.

## Licencias y alojamiento:
El código de **JTools** se encuentra actualmente alojado dentro de un repositorio de la plataforma GitHub y se respalda tras la certificación de **General Public License v2.0** (**GPL v2.0**) cuyas especificaciones podrán encontrarse en la respectiva web del proyecto **GNU**.

**https://www.gnu.org/licenses/old-licenses/gpl-2.0.en.html**

## Autor: 
**JIRT2007** es el desarrollador y mantenedor principal del proyecto **JTools** al igual que de proyectos como **CentrixCL** del cual se podrá encontrar información en su respectiva web alojada en GitHub Pages: **https://jirt2007.github.io/webCENTRIX/**

## Changelog:

###v0.0.2:
- Se habilita dentro del menú de JTools, la opción NECESARIA para el correcto funcionamiento de la herramienta que permite la instalación de los paquetes bases y la generación de la estructura de directorios para sistemas **Debian GNU/Linux**, **ArchLinux** y **Fedora** empleando los respectivos gestores de paquetes de los mismos (apt, pacman y dnf).
- Se implementaron opciones para gestionar de forma básica el firewall UFW el cual ofrece simples operaciones que ofrece el programa. Se pueden presentar errores los cuales serán corregidos en futuras versiones.

###v0.0.1
- Se ofrece la primera versión oficial de JTools, el mismo ofrece unicamente un gestor de VMs mediante KVM/QEMU. Futuras funcionalidades serán implementadas a futuro. Muchas gracias :)

