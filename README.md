# Bunker CTF Manager 🐧

Bunker CTF Manager es un script en Bash diseñado para facilitar la creación, administración y exportación de máquinas virtuales (CTFs) utilizando Docker. Este proyecto está especialmente diseñado para la comunidad de **El Búnker del Pingüino**, pero puede ser utilizado por cualquier persona interesada en crear y gestionar retos de seguridad informática.

## Características principales 🚀

- **Creación de máquinas CTF**: Crea nuevas máquinas virtuales con Docker, configurando usuarios y puertos expuestos.
- **Administración de imágenes y contenedores**: Lista, elimina y gestiona imágenes y contenedores Docker de manera sencilla.
- **Exportación de máquinas**: Exporta tus máquinas CTF en formato `.tar` para compartirlas fácilmente.

## Requisitos 👋

- **Docker**: Asegúrate de tener Docker instalado en tu sistema. Puedes descargarlo desde [aquí](https://docs.docker.com/get-docker/).
- **Bash**: El script está diseñado para ejecutarse en entornos Bash.
- **Permisos de root**: El script debe ejecutarse como root o con `sudo`.

## Instalación y uso 🛠️

1. **Clona el repositorio**:
   ```bash
   git clone https://github.com/4k4m1m3/Bunker-CTF-Manager.git
   cd bunker-ctf-manager
   ```
2. **Haz ejecutable el script**:
   ```bash
   chmod +x BunkerCTFManager.sh
   ```
3. **Ejecuta el script**:
   ```bash
   sudo ./BunkerCTFManager.sh
   ```
4. **Sigue las instrucciones en pantalla**:
   - Elige entre crear nuevas máquinas CTF, administrar imágenes y contenedores, o verificar los requisitos del sistema.

## Ejemplo de uso 🖥️

### Crear un nuevo reto CTF
1. Selecciona la opción **Crear un nuevo reto CTF**.
2. Ingresa el nombre del reto, la imagen base (por ejemplo, `ubuntu:20.04`) y los puertos a exponer.
3. El script generará una contraseña aleatoria para el usuario `bunkerpinguino`. **Debes copiar y guardar esta contraseña o, de preferencia, crear una nueva contraseña.**

### Administrar imágenes Docker
1. Selecciona la opción **Administrar imágenes Docker**.
2. Elige entre listar las imágenes existentes o eliminar una imagen específica.

### Exportar una máquina
1. Después de crear una máquina, el script te preguntará si deseas exportarla.
2. Si seleccionas "Sí", la máquina se guardará en un archivo `.tar` en el directorio actual.

## Contribuciones 🤝

¡Las contribuciones son bienvenidas! Si deseas mejorar este proyecto, sigue estos pasos:

1. Haz un fork del repositorio.
2. Crea una rama para tu contribución:
   ```bash
   git checkout -b mi-contribucion
   ```
3. Realiza tus cambios y haz commit:
   ```bash
   git commit -m "Añadí una nueva función para..."
   ```
4. Envía un pull request a la rama `main`.

## Créditos 🙏

- **Desarrollador**: 4k4m1m3
- **Comunidad**: El Búnker del Pingüino

¡Gracias por usar Bunker CTF Manager! 🐧💻
