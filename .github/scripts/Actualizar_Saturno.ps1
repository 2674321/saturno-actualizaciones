#requires -Version 5.1
<#
Actualizacion directa de Saturno PC a 1.6.0.
No borra, lee, exporta ni incluye datos contables.
No necesita el actualizador integrado en versiones anteriores.
#>
[CmdletBinding()]
param([switch]$Silencioso)

$ErrorActionPreference = "Stop"
$VersionDestino = "1.6.0"
$NombreInstalador = "Saturno-1.6.0-windows-x86_64.exe"
$TamanoEsperado = 21452444
$Sha256Esperado = "4eed97056a528a009f68000f64340ef3d6a18e4382b469c9f4c784871308e993"
$Instalador = Join-Path $PSScriptRoot $NombreInstalador
$ProgramaHabitual = Join-Path $env:LOCALAPPDATA "Programs\Saturno\Saturno.exe"
$CarpetaDatos = Join-Path $env:LOCALAPPDATA "Saturno"

function Detener-ConError([string]$Mensaje, [int]$Codigo = 1) {
    Write-Host ""
    Write-Host "ERROR: $Mensaje" -ForegroundColor Red
    exit $Codigo
}

Write-Host ""
Write-Host "SATURNO - ACTUALIZACION DIRECTA A 1.6.0" -ForegroundColor Cyan
Write-Host "Instalador oficial | Windows x64 | Sin datos incluidos"
Write-Host ""
if (-not [Environment]::Is64BitOperatingSystem) {
    Detener-ConError "Este instalador requiere Windows de 64 bits."
}
if (-not (Test-Path -LiteralPath $Instalador -PathType Leaf)) {
    Detener-ConError "No se encuentra $NombreInstalador junto a este archivo."
}

$Archivo = Get-Item -LiteralPath $Instalador
if ($Archivo.Length -ne $TamanoEsperado) {
    Detener-ConError "El instalador tiene un tamano inesperado. No se ejecutara."
}
$HashObtenido = (Get-FileHash -LiteralPath $Instalador -Algorithm SHA256).Hash.ToLowerInvariant()
if ($HashObtenido -ne $Sha256Esperado) {
    Detener-ConError "SHA-256 incorrecto. El archivo puede estar incompleto o alterado."
}
Write-Host "Integridad del instalador: VERIFICADA" -ForegroundColor Green

$Instalaciones = @()
$UninstallRoots = @(
    "HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall",
    "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall",
    "HKLM:\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall"
)
foreach ($Root in $UninstallRoots) {
    if (-not (Test-Path $Root)) { continue }
    foreach ($Entrada in (Get-ChildItem -LiteralPath $Root -ErrorAction SilentlyContinue)) {
        $Propiedades = Get-ItemProperty -LiteralPath $Entrada.PSPath -ErrorAction SilentlyContinue
        if ($Propiedades -and $Propiedades.DisplayName -match '^Saturno(?:\s|$)') {
            $Instalaciones += $Propiedades
        }
    }
}
$Instalaciones = @($Instalaciones | Sort-Object -Property DisplayName, InstallLocation -Unique)
$Candidatos = @($ProgramaHabitual)
foreach ($Entrada in $Instalaciones) {
    if ($Entrada.InstallLocation) {
        $Candidatos += Join-Path $Entrada.InstallLocation "Saturno.exe"
    }
}
$Candidatos = @($Candidatos | Select-Object -Unique)
$Anterior = @($Candidatos | Where-Object { Test-Path -LiteralPath $_ -PathType Leaf })

if ($Anterior.Count -eq 0) {
    Write-Warning "No se detecta una instalacion estandar. Una version portable puede estar en otra carpeta."
    if (-not $Silencioso) {
        $Respuesta = Read-Host "Continuar con el instalador oficial igualmente? [S/N]"
        if ($Respuesta -notmatch '^[Ss]$') { Detener-ConError "Instalacion cancelada sin modificar archivos." 3 }
    } else {
        Detener-ConError "Prueba automatizada: no se encontro instalacion anterior." 3
    }
} else {
    Write-Host "Instalacion anterior detectada:"
    foreach ($Ruta in $Anterior) {
        Write-Host " - $Ruta"
        try {
            $Version = & $Ruta --version 2>$null
            if ($Version) { Write-Host "   $Version" }
        } catch { Write-Host "   Version no legible; se usara el instalador completo." }
    }
}

if (Get-Process -Name "Saturno" -ErrorAction SilentlyContinue) {
    Detener-ConError "Saturno esta abierto. Cierre el programa de forma normal e intente nuevamente." 4
}

Write-Host ""
Write-Host "El paquete no contiene ni elimina bases, movimientos ni respaldos."
Write-Host "Datos habituales: $CarpetaDatos"
if ($env:SATURNO_DATOS) {
    Write-Host "Se detecto SATURNO_DATOS personalizado. El instalador no cambiara esa variable."
}
Write-Host "Al abrir la nueva version, Saturno puede migrar el esquema de su base existente."
Write-Host "Conviene contar con un respaldo reciente antes de continuar."
Write-Host ""
if (-not $Silencioso) {
    $Respuesta = Read-Host "Abrir el instalador verificado de Saturno 1.6.0? [S/N]"
    if ($Respuesta -notmatch '^[Ss]$') { Detener-ConError "Cancelado por el usuario." 3 }
}

$Argumentos = @("/NORESTART")
if ($Silencioso) { $Argumentos += @("/VERYSILENT", "/SUPPRESSMSGBOXES") }
try {
    $Proceso = Start-Process -FilePath $Instalador -ArgumentList $Argumentos -Wait -PassThru
} catch {
    Detener-ConError "No se pudo ejecutar el instalador: $($_.Exception.Message)" 5
}
if ($Proceso.ExitCode -ne 0) {
    Detener-ConError "El instalador termino con codigo $($Proceso.ExitCode). No elimine la instalacion anterior." 6
}

$Candidatos = @($ProgramaHabitual) + @($Candidatos)
$Actual = @($Candidatos | Select-Object -Unique | Where-Object { Test-Path -LiteralPath $_ -PathType Leaf })
$Confirmado = $false
foreach ($Ruta in $Actual) {
    try {
        $Version = (& $Ruta --version 2>$null | Out-String).Trim()
        if ($Version -match 'Saturno\s+1\.6\.0(?:\s|$)') {
            Write-Host ""
            Write-Host "ACTUALIZACION CORRECTA: $Version" -ForegroundColor Green
            Write-Host "Programa: $Ruta"
            $Confirmado = $true
            break
        }
    } catch { }
}
if (-not $Confirmado) {
    Detener-ConError "El instalador termino, pero no se pudo confirmar Saturno 1.6.0. Revise el acceso directo y la version instalada." 7
}
Write-Host "La base, la configuracion y los respaldos permanecen fuera de la carpeta del programa."
Write-Host "Puede abrir Saturno desde el menu Inicio."
exit 0
