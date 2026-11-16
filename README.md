# Saturno — canal oficial de actualizaciones

Este repositorio publica exclusivamente los artefactos binarios oficiales de
Saturno, su manifiesto estable y sus huellas SHA-256. El código fuente y los
datos contables permanecen en repositorios y equipos privados.

La aplicación valida tamaño y SHA-256 antes de iniciar una actualización. El
archivo `saturno-update.json` es el punto estable consultado por las
instalaciones oficiales.

Responsable de publicación: Patricio Varela C., Programador.

## Actualización asistida de PC a 1.6.0

Para instalaciones antiguas que no logran actualizarse desde la aplicación, descargar el [paquete completo Windows](https://github.com/2674321/saturno-actualizaciones/releases/download/v1.6.0/Saturno-Actualizacion-Asistida-1.2.8-a-1.6.0-Windows.zip). Contiene el instalador oficial, un verificador SHA-256 y un asistente de actualización por doble clic. **No contiene datos del cliente**.

El salto oficial **1.2.8 → 1.6.0** se probó en Windows con registros ficticios: se conservaron la base, la configuración y el respaldo. Cerrar Saturno y tener un respaldo actualizado antes de instalar. La variante denominada «1.2.8a» no cuenta con prueba separada.
