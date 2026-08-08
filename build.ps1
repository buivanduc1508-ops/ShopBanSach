#requires -Version 5.1
# Auto-detect Maven (cua IntelliJ hoac Eclipse)
$script:foundMaven = $false

# Tim Maven trong cac vi tri thuong gap
$candidates = @(
    "mvn.cmd",
    "$env:USERPROFILE\.m2\wrapper\dists\*\apache-maven-*\bin\mvn.cmd",
    "$env:USERPROFILE\Desktop\apache-maven-*\bin\mvn.cmd",
    "D:\apache-maven-*\bin\mvn.cmd",
    "D:\Maven\apache-maven-*\bin\mvn.cmd",
    "C:\Program Files\apache-maven-*\bin\mvn.cmd",
    "C:\Program Files (x86)\apache-maven-*\bin\mvn.cmd",
    "C:\Tools\apache-maven-*\bin\mvn.cmd",
    "D:\Tools\apache-maven-*\bin\mvn.cmd",
    "D:\Server\apache-maven-*\bin\mvn.cmd",
    "D:\apache-tomcat-*\..\apache-maven-*\bin\mvn.cmd"
)

# Tim trong IDE
$idePaths = @(
    "D:\IntelliJ*",
    "C:\Program Files\JetBrains\*\plugins\maven\lib\maven*\bin\mvn.cmd"
)
foreach ($pat in $candidates + $idePaths) {
    $found = Get-Command $pat -ErrorAction SilentlyContinue
    if ($found) { $env:Path += ";$(Split-Path $found.Source)"; $script:foundMaven = $true; break }
    $f = Get-Item $pat -ErrorAction SilentlyContinue
    if ($f) { $env:Path += ";$($f.DirectoryName)"; $script:foundMaven = $true; break }
}

# Lay thu muc Tomcat tu system property neu co
$tomcatHome = "D:\apache-tomcat-9.0.91"
$tomcatService = "D:\apache-tomcat-9.0.91\bin"

# ====== Chon che do ======
$mode = $args[0]
if (-not $mode) {
    Write-Host ""
    Write-Host "========== BUILD SCRIPT ==========" -ForegroundColor Cyan
    Write-Host "Lua chon:" -ForegroundColor Yellow
    Write-Host "  1. build-only        (chi Maven compile)"
    Write-Host "  2. build + restart   (compile + restart Tomcat)"
    Write-Host "  3. restart-tomcat    (chi restart Tomcat)"
    Write-Host "  4. war-to-tomcat     (build WAR + copy vao Tomcat/webapps)"
    Write-Host ""
    $mode = Read-Host "Nhap 1/2/3/4"
    switch ($mode) {
        "1" { $mode = "build-only" }
        "2" { $mode = "full" }
        "3" { $mode = "restart-tomcat" }
        "4" { $mode = "war-to-tomcat" }
        default { $mode = "full" }
    }
}

# ====== BAT DAU ======
Write-Host ""
Write-Host "=============================================" -ForegroundColor Cyan
Write-Host " BOOKSTORE BUILD & DEPLOY" -ForegroundColor Cyan
Write-Host "=============================================" -ForegroundColor Cyan
Write-Host "Thu muc project: $PSScriptROOT\.." -ForegroundColor Gray
Write-Host "Mode: $mode" -ForegroundColor Gray
Write-Host ""

$projectDir = Split-Path -Parent $PSCommandPath
Set-Location $projectDir

# ====== Check Maven ======
Write-Host "[1/5] Kiem tra Maven..." -ForegroundColor Yellow
$mvn = Get-Command mvn.cmd -ErrorAction SilentlyContinue
if (-not $mvn) {
    Write-Host "  KHONG tim thay mvn!" -ForegroundColor Red
    Write-Host "  Hay mo IntelliJ, build project (Ctrl+F9) de code duoc compile vao target/classes." -ForegroundColor Yellow
    Write-Host ""
    Write-Host "  Sau do chay lai:  .\build.ps1 3   (de restart Tomcat)" -ForegroundColor Yellow
    pause; exit 1
}
Write-Host "  OK: $($mvn.Source)" -ForegroundColor Green

# ====== Maven build ======
if ($mode -in "build-only", "full", "war-to-tomcat") {
    Write-Host ""
    Write-Host "[2/5] Dang build project (mvn clean package -DskipTests)..." -ForegroundColor Yellow
    Write-Host "  Lan dau se mat 2-5 phut (download deps). Lan sau ~30s." -ForegroundColor Gray
    Write-Host ""

    & mvn.cmd clean package -DskipTests 2>&1 | ForEach-Object {
        if ($_ -match "BUILD (SUCCESS|FAILURE)") {
            Write-Host "  $_" -ForegroundColor $(if ($_ -match "SUCCESS") { "Green" } else { "Red" })
        } elseif ($_ -match "ERROR" -or $_ -match "FAILED") {
            Write-Host "  $_" -ForegroundColor Red
        } else {
            Write-Host "  $_" -ForegroundColor DarkGray
        }
    }

    if ($LASTEXITCODE -ne 0) {
        Write-Host ""
        Write-Host "BUILD THAT BAI!" -ForegroundColor Red
        Write-Host "Xem log phia tren de biet loi gi." -ForegroundColor Yellow
        pause; exit 1
    }

    # Verify .class files exist
    $classFile = "target\classes\controller\admin\AutoFillCoversServlet.class"
    if (Test-Path $classFile) {
        Write-Host ""
        Write-Host "  [OK] Da sinh file: $classFile" -ForegroundColor Green
    } else {
        Write-Host ""
        Write-Host "  [CANH BAO] Khong thay $classFile - build co van de!" -ForegroundColor Red
        pause; exit 1
    }

    if (Test-Path "target\ShopBanSach.war") {
        Write-Host "  [OK] Da sinh WAR: target\ShopBanSach.war" -ForegroundColor Green
    }
}

# ====== WAR to Tomcat ======
if ($mode -eq "war-to-tomcat") {
    Write-Host ""
    Write-Host "[3/5] Copy WAR vao Tomcat..." -ForegroundColor Yellow

    # Tim tomcat home tu bien moi truong hoac mac dinh
    $tomcatWebapps = "$env:CATALINA_HOME\webapps"
    if (-not $env:CATALINA_HOME -or -not (Test-Path $tomcatWebapps)) {
        $tomcatWebapps = "D:\apache-tomcat-9.0.91\webapps"
    }
    if (-not (Test-Path $tomcatWebapps)) {
        Write-Host "  Khong tim thay Tomcat webapps. Cai dat CATALINA_HOME hoac sua script." -ForegroundColor Red
        pause; exit 1
    }

    Write-Host "  Copy WAR -> $tomcatWebapps" -ForegroundColor Gray
    Copy-Item -Force "target\ShopBanSach.war" "$tomcatWebapps\"
    Write-Host "  [OK] WAR da duoc copy" -ForegroundColor Green
}

# ====== Restart Tomcat ======
if ($mode -in "full", "restart-tomcat") {
    Write-Host ""
    Write-Host "[3/5] Restart Tomcat..." -ForegroundColor Yellow

    $catalina = "$env:CATALINA_HOME"
    if (-not (Test-Path "$catalina\bin\shutdown.bat") -and -not (Test-Path "$catalina\bin\catalina.bat")) {
        $catalina = "D:\apache-tomcat-9.0.91"
    }

    if (-not (Test-Path "$catalina\bin\shutdown.bat")) {
        Write-Host "  Khong tim thay Tomcat. Cai dat CATINA_HOME hoac sua script." -ForegroundColor Red
        Write-Host "  Hay stop/start Tomcat bang tay trong Services hoac XAMPP/WAMP control panel." -ForegroundColor Yellow
        pause; exit 1
    }

    Write-Host "  Stop Tomcat..." -ForegroundColor Gray
    & "$catalina\bin\shutdown.bat" 2>&1 | Out-Null
    Start-Sleep -Seconds 5

    # Kill neu con
    Get-Process -Name "java" -ErrorAction SilentlyContinue | Where-Object {
        $_.Modules | Where-Object { $_.FileName -like "*tomcat*" }
    } | Stop-Process -Force -ErrorAction SilentlyContinue
    Get-Process -Name "tomcat*" -ErrorAction SilentlyContinue | Stop-Process -Force
    Start-Sleep -Seconds 2

    Write-Host "  Start Tomcat..." -ForegroundColor Gray
    Start-Process -FilePath "$catalina\bin\startup.bat" -WorkingDirectory "$catalina\bin" -WindowStyle Normal
    Start-Sleep -Seconds 8

    Write-Host "  [OK] Tomcat dang khoi dong..." -ForegroundColor Green
}

# ====== Ket qua ======
Write-Host ""
Write-Host "=============================================" -ForegroundColor Green
Write-Host " HOAN TAT!" -ForegroundColor Green
Write-Host "=============================================" -ForegroundColor Green
Write-Host ""
Write-Host "URL admin: http://localhost:8080/ShopBanSach/admin/auto-fill-covers" -ForegroundColor Cyan
Write-Host ""
Write-Host "Neu van 404/500:" -ForegroundColor Yellow
Write-Host "  - Xem log Tomcat: $catalina\logs\catalina.out (hoac stdout log trong IDE)" -ForegroundColor Gray
Write-Host "  - Mo IntelliJ, stop Tomcat, sua code, Rebuild (Ctrl+F9), run lai" -ForegroundColor Gray
Write-Host ""
pause
