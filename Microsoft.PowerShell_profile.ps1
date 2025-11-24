# --- Git Aliases ---
Function gs {
    if (-not (git rev-parse --is-inside-work-tree 2>$null)) {
        Write-Host "❌ No estás dentro de un repositorio Git" -ForegroundColor Red
        return
    }
    git status
}

Function gas {
    if (-not (git rev-parse --is-inside-work-tree 2>$null)) {
        Write-Host "❌ No estás dentro de un repositorio Git" -ForegroundColor Red
        return
    }
    git add -A; git status
}

Function grh { 
    if (-not (git rev-parse --is-inside-work-tree 2>$null)) {
        Write-Host "❌ No estás dentro de un repositorio Git" -ForegroundColor Red
        return
    }
    git reset HEAD~
}

Function grhh { 
    if (-not (git rev-parse --is-inside-work-tree 2>$null)) {
        Write-Host "❌ No estás dentro de un repositorio Git" -ForegroundColor Red
        return
    }
    git reset HEAD --hard
}

Function gcom {
    if (-not (git rev-parse --is-inside-work-tree 2>$null)) {
        Write-Host "❌ No estás dentro de un repositorio Git" -ForegroundColor Red
        return
    }
    git commit -S -m @args
}

Function gco {
    if (-not (git rev-parse --is-inside-work-tree 2>$null)) {
        Write-Host "❌ No estás dentro de un repositorio Git" -ForegroundColor Red
        return
    }
    git checkout
}

Function gac { 
    if (-not (git rev-parse --is-inside-work-tree 2>$null)) {
        Write-Host "❌ No estás dentro de un repositorio Git" -ForegroundColor Red
        return
    }
    git add -A; git status; git commit -m @args
}

Function gca { 
    if (-not (git rev-parse --is-inside-work-tree 2>$null)) {
        Write-Host "❌ No estás dentro de un repositorio Git" -ForegroundColor Red
        return
    }
    git commit -S --amend --no-edit
}

Function gpo {
    if (-not (git rev-parse --is-inside-work-tree 2>$null)) {
        Write-Host "❌ No estás dentro de un repositorio Git" -ForegroundColor Red
        return
    }
    git push -u origin HEAD
}

Function gl {
    if (-not (git rev-parse --is-inside-work-tree 2>$null)) {
        Write-Host "❌ No estás dentro de un repositorio Git" -ForegroundColor Red
        return
    }
    git log --graph --pretty=format:"`%Cred`%h`%Creset -`%C(yellow)`%d`%Creset `%s `%Cgreen(`%cr`) `%C(bold blue)<`%an>`%Creset" --abbrev-commit
}

Function gsu {
    if (-not (git rev-parse --is-inside-work-tree 2>$null)) {
        Write-Host "❌ No estás dentro de un repositorio Git" -ForegroundColor Red
        return
    }
    git stash -u
}

Function gsp {
    if (-not (git rev-parse --is-inside-work-tree 2>$null)) {
        Write-Host "❌ No estás dentro de un repositorio Git" -ForegroundColor Red
        return
    }
    git stash pop
}

Function gdefault {
    if (-not (git rev-parse --is-inside-work-tree 2>$null)) {
        Write-Host "❌ No estás dentro de un repositorio Git" -ForegroundColor Red
        return
    }
    (git symbolic-ref refs/remotes/origin/HEAD) -split '/' | Select-Object -Last 1
}

Function gpr {
    if (-not (git rev-parse --is-inside-work-tree 2>$null)) {
        Write-Host "❌ No estás dentro de un repositorio Git" -ForegroundColor Red
        return
    }
    git pull --rebase
    git --no-pager log -15 --graph --pretty=format:"`%Cred`%h`%Creset -`%C(yellow)`%d`%Creset `%s `%Cgreen(`%cr`) `%C(bold blue)[`%an]`%Creset" --abbrev-commit
}

Function gdelbr {
    if (-not (git rev-parse --is-inside-work-tree 2>$null)) {
        Write-Host "❌ No estás dentro de un repositorio Git" -ForegroundColor Red
        return
    }
    $main_branch = gdefault
    gco $main_branch

    # Get all branches but default
    $branches = git branch --format="%(refname:short)" | Where-Object { $_ -ne $main_branch }

    foreach ($branch in $branches) {
        git branch -D $branch
    }
}

Function gcopm {
    if (-not (git rev-parse --is-inside-work-tree 2>$null)) {
        Write-Host "❌ No estás dentro de un repositorio Git" -ForegroundColor Red
        return
    }
    $main_branch = gdefault
    gco $main_branch
    gpr
}

Function gnewbr {
    if (-not (git rev-parse --is-inside-work-tree 2>$null)) {
        Write-Host "❌ No estás dentro de un repositorio Git" -ForegroundColor Red
        return
    }
    gcopm
    git checkout -b @args
}

Function gstnewbr {
    if (-not (git rev-parse --is-inside-work-tree 2>$null)) {
        Write-Host "❌ No estás dentro de un repositorio Git" -ForegroundColor Red
        return
    }
    gsu
    gnewbr @args
    gsp
}

Function gcpp {
    if (-not (git rev-parse --is-inside-work-tree 2>$null)) {
        Write-Host "❌ No estás dentro de un repositorio Git" -ForegroundColor Red
        return
    }
    gas
    gcom @args
    gpr
    gpo
}

Function gcp {
    if (-not (git rev-parse --is-inside-work-tree 2>$null)) {
        Write-Host "❌ No estás dentro de un repositorio Git" -ForegroundColor Red
        return
    }
    gas
    gcom @args
    gpo
}

Function gcpr {
    if (-not (git rev-parse --is-inside-work-tree 2>$null)) {
        Write-Host "❌ No estás dentro de un repositorio Git" -ForegroundColor Red
        return
    }
    gcp @args
    pr
}

Function pr {
    if (-not (git rev-parse --is-inside-work-tree 2>$null)) {
        Write-Host "❌ No estás dentro de un repositorio Git" -ForegroundColor Red
        return
    }
    $remote = git remote -v | Where-Object { $_ -match 'fetch' } | ForEach-Object {
        ($_ -split '\s+')[1] -replace '^(git@|git://)', 'https://' `
                         -replace 'cloud:', 'cloud/' `
                         -replace 'com:', 'com/' `
                         -replace '\.git$', ''
    } | Where-Object { $_ -match 'github' }

    $branch = (git symbolic-ref HEAD) -split '/' | Select-Object -Skip 2 -Join '/'
    $main = gdefault
    $url = "$remote/compare/$main...$branch"

    if ($IsWindows) {
        Start-Process $url
    } else {
        open $url
    }
}

function gisrepo {
    return (git rev-parse --is-inside-work-tree 2>$null)
}

function gch {
    if (-not (git rev-parse --is-inside-work-tree 2>$null)) {
        Write-Host "❌ No estás dentro de un repositorio Git" -ForegroundColor Red
        return
    }
    git checkout @args
}

function gchb {
    if (-not (git rev-parse --is-inside-work-tree 2>$null)) {
        Write-Host "❌ No estás dentro de un repositorio Git" -ForegroundColor Red
        return
    }
    git checkout -b @args
}

function gfa {
    if (-not (git rev-parse --is-inside-work-tree 2>$null)) {
        Write-Host "❌ No estás dentro de un repositorio Git" -ForegroundColor Red
        return
    }
    git fetch --all
}

function greb {
    if (-not (git rev-parse --is-inside-work-tree 2>$null)) {
        Write-Host "❌ No estás dentro de un repositorio Git" -ForegroundColor Red
        return
    }
    git rebase -i @args
}

function gpush {
    if (-not (git rev-parse --is-inside-work-tree 2>$null)) {
        Write-Host "❌ No estás dentro de un repositorio Git" -ForegroundColor Red
        return
    }
    git push origin @args
}

function gpull {
    if (-not (git rev-parse --is-inside-work-tree 2>$null)) {
        Write-Host "❌ No estás dentro de un repositorio Git" -ForegroundColor Red
        return
    }
    git pull origin @args
}

function gl {
    if (-not (git rev-parse --is-inside-work-tree 2>$null)) {
        Write-Host "❌ No estás dentro de un repositorio Git" -ForegroundColor Red
        return
    }
    git log
}

function glo {
    if (-not (git rev-parse --is-inside-work-tree 2>$null)) {
        Write-Host "❌ No estás dentro de un repositorio Git" -ForegroundColor Red
        return
    }
    git log --oneline
}

function gb {
    if (-not (git rev-parse --is-inside-work-tree 2>$null)) {
        Write-Host "❌ No estás dentro de un repositorio Git" -ForegroundColor Red
        return
    }
    git branch @args
}

function gd {
    if (-not (git rev-parse --is-inside-work-tree 2>$null)) {
        Write-Host "❌ No estás dentro de un repositorio Git" -ForegroundColor Red
        return
    }
    git diff
}

# --- Docker aliases ---
Function dkill {
  docker rm -f $(docker ps -a -q)
  docker network prune -f
}
Function dps { docker ps }
Function dpsa { docker ps -a }
Function dcd { docker-compose down }
Function dcu { docker-compose up }
Function dcreset { dcd; dcu }

# --- Kubernetes alias ---
Function k { kubectl }

function Remove-DotUnderscoreFiles {
    <#
    .SYNOPSIS
      Elimina todos los ficheros que empiecen por "._" en una carpeta y subcarpetas.
    .DESCRIPTION
      Escanea la carpeta indicada (y sus subcarpetas) para encontrar archivos ocultos o de sistema
      que comienzan por "._" (típicos de macOS) y los elimina de forma segura.
    .PARAMETER Path
      Ruta de la carpeta en la que buscar los ficheros. Por defecto es el directorio actual.
    .PARAMETER WhatIf
      Simula la eliminación sin borrar nada realmente.
    .EXAMPLE
      Remove-DotUnderscoreFiles -Path "C:\MisArchivos"
    .EXAMPLE
      Remove-DotUnderscoreFiles -Path "D:\Fotos" -WhatIf
    #>
    param(
        [string]$Path = ".",
        [switch]$WhatIf
    )

    Write-Host "🔍 Buscando ficheros que empiecen por '._' en: $Path" -ForegroundColor Cyan

    # Obtener todos los ficheros, incluidos ocultos y de sistema
    $files = Get-ChildItem -Path $Path -Recurse -File -Force |
        Where-Object { $_.Name -like '._*' }

    if ($files.Count -eq 0) {
        Write-Host "✅ No se encontraron ficheros '._'." -ForegroundColor Green
        return
    }

    Write-Host "⚠️ Se encontraron $($files.Count) ficheros:" -ForegroundColor Yellow
    $files | Select-Object FullName | ForEach-Object { Write-Host $_.FullName }

    if ($WhatIf) {
        Write-Host "`n💡 Modo simulación (WhatIf): no se eliminará ningún archivo." -ForegroundColor DarkYellow
    } else {
        Write-Host "`n🗑️ Eliminando ficheros..." -ForegroundColor Red
        $files | Remove-Item -Force
        Write-Host "✅ Proceso completado." -ForegroundColor Green
    }
}

function remove_dsstorefiles {
    param([string]$Path = ".")

    $files = Get-ChildItem -Path $Path -Recurse -File -Force | Where-Object { $_.Name -like '.DS_Store' }
    if ($files.Count -eq 0) {
        Write-Host "✅ No se encontraron ficheros '.DS_Store'." -ForegroundColor Green
        return
    }

    $files | Remove-Item -Force
}

Set-Alias rduf Remove-DotUnderscoreFiles

oh-my-posh init pwsh --config ~/.config.omp.json | iex
