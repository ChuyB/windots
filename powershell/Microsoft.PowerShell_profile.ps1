#PSReadLine
Import-Module PSReadLine
Set-PSReadLineOption -EditMode Vi

# File Icons
Import-Module Terminal-Icons

# BetterCompletiton
Enable-PowerType
Set-PSReadLineOption -PredictionSource HistoryAndPlugin -PredictionViewStyle ListView # Optional

# Themes
# oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH/powerlevel10k_lean.omp.json" | Invoke-Expression
$ENV:STARSHIP_CONFIG = "C:\Users\jesus\OneDrive\Documentos\PowerShell\starship.toml"
Invoke-Expression (&starship init powershell)

# Zoxide
Invoke-Expression (& { (zoxide init powershell | Out-String) })

# Aliases
function StartTiling {
  komorebic start -c "$Env:USERPROFILE\.config\komorebi.json" --whkd
}

function StopTiling{
  komorebic stop
}

function StatusBar {
  pythonw $Env:USERPROFILE\.yasb\src\main.py
}

function StartWorkspace{
  StatusBar
  StartTiling
}

New-Alias -Name "tile" -Value StartTiling
New-Alias -Name "stoptile" -Value StopTiling
New-Alias -Name "yasb" -Value StatusBar
New-Alias -Name "ignite" -Value StartWorkspace

# Import the Chocolatey Profile that contains the necessary code to enable
# tab-completions to function for `choco`.
# Be aware that if you are missing these lines from your profile, tab completion
# for `choco` will not function.
# See https://ch0.co/tab-completion for details.
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}
