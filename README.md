# TemplateBD
Código de utilidad para el proyecto final de base de datos. (CCI-54)

# Instalación
1. Clonar el repositorio:
   ```bash
   git clone https://github.com/Francoo86/TemplateBD
   ```
2. Navegar al directorio del proyecto:
   ```bash
   cd TemplateBD
   ```
3. Guardar el proyecto en la carpeta `htdocs` de XAMPP:
   ```bash
   mv TemplateBD /path/to/xampp/htdocs/
   ```
4. Configurar la base de datos:
   - Abrir el archivo `config/Conexion.php`.
   - Ajustar las variables `$host`, `$database`, `$username` y `$password`
     según la configuración de tu servidor de base de datos.
5. Importar la base de datos:
   - Abrir phpMyAdmin.
   - Importar el archivo SQL que les dará el Powerdesigner (el crebas.sql).
6. Iniciar el servidor Apache y MySQL desde XAMPP.

# Inicialización del proyecto
Para iniciar el proyecto, abra su navegador y acceda a:
```
http://localhost/TemplateBD/
```
En este caso TemplateBD es el nombre del proyecto. Si lo ha guardado con otro nombre, cambie la URL del nombre de la carpeta.
