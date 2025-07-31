# --- Git Aliases ---
Function gs { git status }
Function gas { git add -A; git status }
Function grh { git reset HEAD~ }
Function grhh { git reset HEAD --hard }
Function gcom { git commit -S -m @args }
Function gco  { git checkout }
Function gac { git add -A; git status; git commit -m @args }
Function gca { git commit -S --amend --no-edit }
Function gpo { git push -u origin HEAD }

Function gl {
  git log --graph --pretty=format:"`%Cred`%h`%Creset -`%C(yellow)`%d`%Creset `%s `%Cgreen(`%cr`) `%C(bold blue)<`%an>`%Creset" --abbrev-commit
}

Function gsu { git stash -u }
Function gsp { git stash pop }

Function gdefault {
  (git symbolic-ref refs/remotes/origin/HEAD) -split '/' | Select-Object -Last 1
}

Function gpr {
  git pull --rebase
  git --no-pager log -15 --graph --pretty=format:"`%Cred`%h`%Creset -`%C(yellow)`%d`%Creset `%s `%Cgreen(`%cr`) `%C(bold blue)[`%an]`%Creset" --abbrev-commit
}

Function gdelbr {
    $main_branch = gdefault
    gco $main_branch

    # Get all branches but default
    $branches = git branch --format="%(refname:short)" | Where-Object { $_ -ne $main_branch }

    foreach ($branch in $branches) {
        git branch -D $branch
    }
}

Function gcopm {
  $main_branch = gdefault
  gco $main_branch
  gpr
}

Function gnewbr {
  gcopm
  git checkout -b @args
}

Function gstnewbr {
  gsu
  gnewbr @args
  gsp
}

Function gcpp {
  gas
  gcom @args
  gpr
  gpo
}

Function gcp {
  gas
  gcom @args
  gpo
}

Function gcpr {
  gcp @args
  pr
}

Function pr {
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

function gch { git checkout @args }
function gchb { git checkout -b @args }

function gfa { git fetch --all }

function greb { git rebase -i @args }

function gpush { git push origin @args }
function gpull { git pull origin @args }

function gl { git log }
function glo { git log --oneline }

function gb { git branch @args }
function gd { git diff }

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
