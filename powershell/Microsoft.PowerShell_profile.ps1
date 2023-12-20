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
