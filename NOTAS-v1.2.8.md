# Saturno PC 1.2.8 (2026-11-02)

- **Versión definitiva para instalar con datos incluidos:** la entrega trae un
  `INSTALAR-DEFINITIVO.cmd` que, con un solo doble clic, instala el programa
  1.2.8 en silencio, coloca la base corregida de la organización como base de
  trabajo y guarda respaldo preventivo de cualquier base previa (nunca borra).
  Sin verificación de versiones anteriores, sin códigos, sin configuración
  adicional: queda 100 % operativa al terminar la instalación.
- **Reparación privada más amable:** si la base no contiene los movimientos que
  la corrección necesita (por ejemplo una base recién creada), ahora dice con
  claridad «nada que corregir aquí» y no modifica nada, en lugar del enigmático
  «esperaba un movimiento único y encontró cero». El refusal sigue siendo
  estricto y no graba bitácora. Con más de una coincidencia sigue el error de
  ambigüedad, y con la base entregada (corrección ya aplicada) el código es
  idempotente e inocuo.
- Android permanece en 0.8.1; el APK 0.8.2 quedó empacado en el código pero sin
  firma release (pendiente de credenciales de firma en el entorno).

Huellas (SHA-256) verificadas por descarga en la release v1.2.8 de este canal;
ver `SHA256SUMS.txt`. Commit del código: `531d15807001a04b039fa92e608d77c0a1cfd508`.
