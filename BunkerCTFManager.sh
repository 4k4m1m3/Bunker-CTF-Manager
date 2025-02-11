#!/bin/bash

GREEN="\e[92m"
LIGHT_GREEN="\e[1;32m"
RED="\e[31m"
LIGHT_RED="\e[1;31m"
YELLOW="\e[93m"
BLUE="\e[1;34m"
CYAN="\e[96m"
MAGENTA="\e[1;35m"
RESET="\e[0m"

if [[ $EUID -ne 0 ]]; then
   echo -e "${RED}❌ Este script debe ejecutarse como root o con sudo.${RESET}" 
   exit 1
fi

mostrar_exito() {
    echo -e "${GREEN}✅ $1${RESET}"
}

mostrar_error() {
    echo -e "${RED}❌ $1${RESET}"
}

registrar_log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> BunkerCTFManager.log
}

generar_contrasena() {
    local longitud=12
    local caracteres="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#$%^&*"
    local contrasena=$(head /dev/urandom | tr -dc "$caracteres" | head -c "$longitud")
    echo "$contrasena"
}

comprobar_requisitos() {
    clear
    echo -e "${GREEN}╔══════════════════════════════════════════╗${RESET}"
    echo -e "${GREEN}║          🔍 Comprobando Requisitos 🔍     ║${RESET}"
    echo -e "${GREEN}╚══════════════════════════════════════════╝${RESET}"
    echo
    if ! command -v docker &> /dev/null; then
        mostrar_error "Docker no está instalado."
        echo -e "Por favor, instala Docker y vuelve a intentarlo."
        echo -e "${YELLOW}Puedes descargarlo desde: https://docs.docker.com/get-docker/${RESET}"
    else
        mostrar_exito "Docker está instalado."
        docker --version
    fi
    echo
    read -p "Presione Enter para regresar al menú principal..."
}

menu_principal() {
    while true; do
        clear
echo -e "${BLUE}"
cat << "EOF"
  ___                  _                          _         _       ___
(  _`\               ( )                        ( )       (_ )    (  _`\  _                       _
| (_) ) _   _   ___  | |/')    __   _ __       _| |   __   | |    | |_) )(_)  ___     __   _   _ (_)  ___     _
|  _ <'( ) ( )/' _ `\| , <   /'__`\( '__)    /'_` | /'__`\ | |    | ,__/'| |/' _ `\ /'_ `\( ) ( )| |/' _ `\ /'_`\
| (_) )| (_) || ( ) || |\`\ (  ___/| |      ( (_| |(  ___/ | |    | |    | || ( ) |( (_) || (_) || || ( ) |( (_) )
(____/'`\___/'(_) (_)(_) (_)`\____)(_)      `\__,_)`\____)(___)   (_)    (_)(_) (_)`\__  |`\___/'(_)(_) (_)`\___/'
                                                                                   ( )_) |
                                                                                    \___/'
EOF
echo -e "${RESET}"

        echo -e "${GREEN}╔══════════════════════════════════════════╗${RESET}"
        echo -e "${GREEN}║          🐧 Bunker CTF Manager 🐧        ║${RESET}"
        echo -e "${GREEN}╚══════════════════════════════════════════╝${RESET}"
        echo
        echo -e "${CYAN}¿Qué acción deseas realizar?${RESET}"
        echo
        echo -e "${GREEN}1)${RESET} Crear un nuevo reto CTF"
        echo -e "${GREEN}2)${RESET} Verificar requisitos del sistema"
        echo -e "${GREEN}3)${RESET} Ver créditos"
        echo -e "${GREEN}4)${RESET} Salir"
        echo
        read -p "Selecciona una opción: " opcion
        case $opcion in
            1) iniciar_perfil_creador ;;
            2) comprobar_requisitos ;;
            3) mostrar_creditos ;;
            4) salir_script ;;
            *)
                mostrar_error "Opción inválida. Por favor, elige un número entre 1 y 4."
                sleep 2
                ;;
        esac
    done
}

iniciar_perfil_creador() {
    clear
    echo -e "${LIGHT_GREEN}🛠️ Cargando el Perfil Creador...${RESET}"
    menu_creador
}

menu_creador() {
    while true; do
        clear
        echo -e "${GREEN}╔══════════════════════════════════════════╗${RESET}"
        echo -e "${GREEN}║          🔧 Menú del Creador 🔧           ║${RESET}"
        echo -e "${GREEN}╚══════════════════════════════════════════╝${RESET}"
        echo
        echo -e "${CYAN}¿Qué acción deseas realizar?${RESET}"
        echo
        echo -e "${GREEN}1)${RESET} Crear un nuevo reto CTF"
        echo -e "${GREEN}2)${RESET} Administrar imágenes Docker"
        echo -e "${GREEN}3)${RESET} Administrar contenedores Docker"
        echo -e "${GREEN}4)${RESET} Regresar al menú principal"
        echo -e "${GREEN}5)${RESET} Salir"
        echo
        read -p "Selecciona una opción: " opcion
        case $opcion in
            1) crear_maquina ;;
            2) administrar_imagenes ;;
            3) administrar_contenedores ;;
            4) break ;;
            5) salir_script ;;
            *)
                mostrar_error "Opción inválida. Por favor, elige un número entre 1 y 5."
                sleep 2
                ;;
        esac
    done
}

crear_maquina() {
    local HIDDEN_MARKER="8J+QpyDCoUJpZW52ZW5pZG8gYWwgQsO6bmtlciBkZWwgUGluZ8O8aW5vISDwn5CnCgpFc3RhIG3DoXF1aW5hIGZ1ZSBjcmVhZGEgY29uIEJ1bmtlclNjcmlwdExhYnMgcGFyYSByZXRvcyBDVEYuCsKhR3JhY2lhcyBwb3Igc2VyIHBhcnRlIGRlIG51ZXN0cmEgY29tdW5pZGFkIQoK8J+TjCBFeHBsb3JhLCBhcHJlbmRlIHkgY29tcGFydGUgdHVzIGxvZ3Jvcy4K8J+UlyBWaXPDrXRhbm9zOiBodHRwczovL3d3dy5za29vbC5jb20vYnVua2VycGluZ3Vpbm8KCsKhQnVlbmEgc3VlcnRlLCBwaW5nw7xpbm8gaGFja2VyISDwn5Cn8J+Suw=="

    clear
    echo -e "${GREEN}╔══════════════════════════════════════════╗${RESET}"
    echo -e "${GREEN}║          🛠️ Crear un nuevo reto CTF 🛠️    ║${RESET}"
    echo -e "${GREEN}╚══════════════════════════════════════════╝${RESET}"
    echo
    read -e -p "Ingresa el nombre del reto (en minúscula, sin espacios): " nombre_maquina
    read -e -p "Ingresa la imagen base (Ej: ubuntu:20.04): " imagen_base
    read -e -p "Ingresa los puertos a exponer (Ej: 22,80): " puertos

    contrasena=$(generar_contrasena)
    echo -e "${YELLOW}Se ha generado una contraseña aleatoria: ${contrasena}${RESET}"
    read -p "¿Deseas usar esta contraseña? (s/n): " usar_contrasena
    if [[ "$usar_contrasena" =~ ^[nN]$ ]]; then
        read -s -p "Ingresa una nueva contraseña: " contrasena
        echo
    fi

    if [[ -z "$nombre_maquina" || -z "$imagen_base" || -z "$puertos" || -z "$contrasena" ]]; then
        mostrar_error "Todos los campos son obligatorios."
        read -p "Presione Enter para continuar..."
        return
    fi

    echo "Creando Dockerfile..."
    cat <<EOF > Dockerfile
FROM $imagen_base

RUN groupadd bunkerpinguino && \
    useradd -m -g bunkerpinguino bunkerpinguino

RUN echo "bunkerpinguino:$contrasena" | chpasswd && \
    echo "root:$contrasena" | chpasswd

RUN mkdir -p /home/bunkerpinguino/.bunkerpinguino_info && \
    echo "$HIDDEN_MARKER" | base64 --decode > /home/bunkerpinguino/.bunkerpinguino_info/.bunkerpinguino_info.txt && \
    chown bunkerpinguino:bunkerpinguino /home/bunkerpinguino/.bunkerpinguino_info/.bunkerpinguino_info.txt && \
    chmod 600 /home/bunkerpinguino/.bunkerpinguino_info/.bunkerpinguino_info.txt

RUN echo "\$(echo "$HIDDEN_MARKER" | base64 --decode)" >> /etc/motd

RUN apt-get update && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

USER bunkerpinguino
WORKDIR /home/bunkerpinguino

# Exponer los puertos individualmente
EOF

    IFS=',' read -ra PUERTOS_ARRAY <<< "$puertos"
    for puerto in "${PUERTOS_ARRAY[@]}"; do
        echo "EXPOSE $puerto" >> Dockerfile
    done

    cat <<EOF >> Dockerfile

CMD ["bash"]
EOF

    echo "Construyendo la imagen Docker..."
    docker build -t "$nombre_maquina" .
    if [ $? -ne 0 ]; then
        mostrar_error "Error al construir la imagen Docker."
        rm -f Dockerfile
        read -p "Presione Enter para regresar al menú..."
        return
    fi
    rm -f Dockerfile
    mostrar_exito "Reto CTF '$nombre_maquina' creado exitosamente."
    echo -e "${YELLOW}🔑 Contraseña del usuario 'bunkerpinguino': $contrasena${RESET}"
    registrar_log "Nuevo reto CTF creado: $nombre_maquina"
    echo
    read -p "¿Deseas iniciar el contenedor para conectarte y configurarlo? (s/n): " iniciar
    if [[ "$iniciar" =~ ^[sS]$ ]]; then
        echo -e "Para finalizar la configuración y regresar al menú principal, escribe 'exit' y presiona Enter."
        echo -e "\nIniciando contenedor...\n"
        docker run -it --name "${nombre_maquina}_container" "$nombre_maquina" bash
    fi
    read -p "¿Deseas exportar este reto a un archivo .tar? (s/n): " exportar
    if [[ "$exportar" =~ ^[sS]$ ]]; then
        docker save -o "${nombre_maquina}.tar" "$nombre_maquina"
        if [ $? -eq 0 ]; then
            mostrar_exito "El reto ha sido exportado a '${nombre_maquina}.tar'."
        else
            mostrar_error "Ocurrió un error al exportar el reto."
        fi
    fi
    echo -e "\n¿Qué deseas hacer ahora?"
    echo -e "${GREEN}1)${RESET} Regresar al menú principal"
    echo -e "${GREEN}2)${RESET} Salir"
    read -p "Selecciona una opción: " opcion_final
    case $opcion_final in
        1) return ;;
        2) salir_script ;;
        *) mostrar_error "Opción inválida. Regresando al menú principal..."; read -p "Presione Enter para continuar..." dummy ;;
    esac
}

administrar_imagenes() {
    while true; do
        clear
        echo "=========================================="
        echo -e "    📋 Administrar Imágenes Docker 📋"
        echo "=========================================="
        echo -e "${CYAN}1) Listar imágenes Docker${RESET}"
        echo -e "${CYAN}2) Eliminar imagen Docker${RESET}"
        echo -e "${CYAN}3) Conectar a un contenedor para modificarlo${RESET}"
        echo -e "${CYAN}4) Regresar al menú del perfil Creador${RESET}"
        read -p "Seleccione una opción: " opcion_imagen
        case $opcion_imagen in
            1) listar_imagenes ;;
            2) eliminar_imagen ;;
            3) conectar_contenedor ;;
            4) break ;;
            *) echo "❌ Opción inválida."; read -p "Presione Enter para continuar..." dummy ;;
        esac
    done
}

listar_imagenes() {
    clear
    echo "=========================================="
    echo -e "    📋 Listar Imágenes Docker 📋"
    echo "=========================================="
    docker images
    read -p "Presione Enter para regresar al menú..."
}

eliminar_imagen() {
    clear
    echo "=========================================="
    echo -e "    🗑️ Eliminar Imagen Docker 🗑️"
    echo "=========================================="
    docker images
    read -p "Ingrese el nombre de la imagen que desea eliminar (nombre:tag, ej: debian:latest): " nombre_imagen
    if [ -z "$nombre_imagen" ]; then
        echo "❌ No ha ingresado un nombre de imagen. Regresando al menú..."
        read -p "Presione Enter para continuar..." dummy
        return
    fi
    contenedores_que_usan_imagen=$(docker ps -a -q -f "ancestor=$nombre_imagen")
    if [ -n "$contenedores_que_usan_imagen" ]; then
        echo "⚠️ Hay contenedores usando la imagen '$nombre_imagen'. Deteniéndolos y eliminándolos..."
        docker stop $contenedores_que_usan_imagen
        docker rm $contenedores_que_usan_imagen
        if [ $? -ne 0 ]; then
            echo "❌ Ocurrió un error al detener o eliminar los contenedores."
            read -p "Presione Enter para regresar al menú..."
            return
        fi
    fi
    docker rmi "$nombre_imagen"
    if [ $? -eq 0 ]; then
        echo "🎉 La imagen '$nombre_imagen' ha sido eliminada correctamente."
    else
        echo "❌ Ocurrió un error al eliminar la imagen."
    fi
    read -p "Presione Enter para regresar al menú..."
}

conectar_contenedor() {
    clear
    echo "=========================================="
    echo -e "    🔧 Conectar a un Contenedor Docker 🔧"
    echo "=========================================="
    docker ps -a --format "table {{.ID}}\t{{.Image}}\t{{.Status}}\t{{.Names}}"
    read -p "Ingrese el CONTAINER ID del contenedor que desea modificar: " container_id
    if [ -z "$container_id" ]; then
        echo "❌ No ha ingresado un CONTAINER ID. Regresando al menú..."
        read -p "Presione Enter para continuar..." dummy
        return
    fi
    container_exists=$(docker ps -a -q -f "id=$container_id")
    if [ -z "$container_exists" ]; then
        echo "❌ El contenedor con ID '$container_id' no existe. Regresando al menú..."
        read -p "Presione Enter para continuar..." dummy
        return
    fi
    container_status=$(docker inspect --format '{{.State.Status}}' "$container_id")
    if [ "$container_status" != "running" ]; then
        echo "❌ El contenedor con ID '$container_id' no está en ejecución."
        read -p "¿Desea iniciar el contenedor? (s/n): " iniciar_cont
        if [[ "$iniciar_cont" =~ ^[sS]$ ]]; then
            docker start "$container_id"
            if [ $? -ne 0 ]; then
                echo "❌ Ocurrió un error al iniciar el contenedor."
                read -p "Presione Enter para regresar al menú..."
                return
            fi
            echo "🚀 Contenedor '$container_id' iniciado correctamente."
        else
            echo "❌ No se inició el contenedor. Regresando al menú..."
            read -p "Presione Enter para continuar..." dummy
            return
        fi
    fi
    echo "Conectando al contenedor '$container_id'..."
    docker exec -it "$container_id" bash
    read -p "¿Desea guardar los cambios realizados en una nueva imagen? (s/n): " guardar_cambios
    if [[ "$guardar_cambios" =~ ^[sS]$ ]]; then
        read -p "Ingrese el nombre para la nueva imagen (ej: cyber:latest): " nueva_imagen
        if [ -n "$nueva_imagen" ]; then
            docker commit "$container_id" "$nueva_imagen"
            if [ $? -eq 0 ]; then
                echo "🎉 Los cambios se han guardado en la nueva imagen '$nueva_imagen'."
            else
                echo "❌ Ocurrió un error al guardar la nueva imagen."
            fi
        else
            echo "❌ No se proporcionó un nombre para la nueva imagen. No se guardaron los cambios."
        fi
    fi
    read -p "Presione Enter para regresar al menú..."
}

administrar_contenedores() {
    while true; do
        clear
        echo "=========================================="
        echo -e "    ⚙️ Administrar Contenedores Docker ⚙️"
        echo "=========================================="
        echo -e "${CYAN}1) Listar contenedores Docker${RESET}"
        echo -e "${CYAN}2) Eliminar contenedor Docker${RESET}"
        echo -e "${CYAN}3) Regresar al menú del perfil Creador${RESET}"
        read -p "Seleccione una opción: " opcion_contenedor
        case $opcion_contenedor in
            1) listar_contenedores ;;
            2) eliminar_contenedor ;;
            3) break ;;
            *) echo "❌ Opción inválida."; read -p "Presione Enter para continuar..." dummy ;;
        esac
    done
}

listar_contenedores() {
    clear
    echo "=========================================="
    echo -e "    📋 Listar Contenedores Docker 📋"
    echo "=========================================="
    docker ps -a --format "table {{.ID}}\t{{.Image}}\t{{.Status}}\t{{.Names}}"
    read -p "Presione Enter para regresar al menú..."
}

eliminar_contenedor() {
    clear
    echo "=========================================="
    echo -e "    🗑️ Eliminar Contenedor Docker 🗑️"
    echo "=========================================="
    docker ps -a --format "table {{.ID}}\t{{.Image}}\t{{.Status}}\t{{.Names}}"
    read -p "Ingrese el CONTAINER ID del contenedor que desea eliminar: " contenedor_id
    if [ -z "$contenedor_id" ]; then
        echo "❌ No ha ingresado un CONTAINER ID. Regresando al menú..."
        read -p "Presione Enter para continuar..." dummy
        return
    fi
    container_exists=$(docker ps -a -q -f "id=$contenedor_id")
    if [ -z "$container_exists" ]; then
        echo "❌ El contenedor con ID '$contenedor_id' no existe. Regresando al menú..."
        read -p "Presione Enter para continuar..." dummy
        return
    fi
    docker rm -f "$contenedor_id"
    if [ $? -eq 0 ]; then
        echo "🎉 El contenedor '$contenedor_id' ha sido eliminado correctamente."
    else
        echo "❌ Ocurrió un error al eliminar el contenedor."
    fi
    read -p "Presione Enter para regresar al menú..."
}

salir_script() {
    echo
    echo -e "${LIGHT_RED}👋 Saliendo del script...${RESET}"
    exit 0
}

mostrar_creditos() {
    clear
    echo -e "${GREEN}╔══════════════════════════════════════════╗${RESET}"
    echo -e "${GREEN}║                Créditos                  ║${RESET}"
    echo -e "${GREEN}╚══════════════════════════════════════════╝${RESET}"
    echo
    echo -e "${CYAN}✨ Desarrollador:${RESET}"
    echo -e "${YELLOW}Versión: 1.0${RESET}"
    echo -e "${YELLOW}Autor: 4k4m1m3${RESET}"
    echo -e "${YELLOW}Web: 4k4m1m3.com${RESET}"
    echo
    echo -e "${CYAN}LinkedIn:${RESET}" 
    echo -e "${CYAN}www.linkedin.com/in/4k4m1m3/${RESET}"
    echo
    read -p "Presione Enter para regresar al menú principal..."
}

menu_principal