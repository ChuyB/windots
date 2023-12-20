function Create-Link {
  param (
    $path,
    $target
  )
  New-Item -ItemType SymbolicLink -Path $path -Target $target -Force
}

$config = "$Env:USERPROFILE\.config"

Create-Link $Env:USERPROFILE\AppData\local\nvim $config\nvim
Create-Link $Env:USERPROFILE\OneDrive\Documentos\PowerShell\Microsoft.PowerShell_profile.ps1 $config\powershell\Microsoft.PowerShell_profile.ps1
Create-Link $Env:USERPROFILE\OneDrive\Documentos\PowerShell\starship.toml $config\powershell\starship.toml
Create-Link $Env:USERPROFILE\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json $config\windows-terminal\settings.json
Create-Link $Env:USERPROFILE\.yasb\config.yaml $config\yasb\config.yaml
Create-Link $Env:USERPROFILE\.yasb\styles.css $config\yasb\styles.css
Create-Link $Env:USERPROFILE\AppData\Roaming\alacritty\alacritty.yml $config\alacritty\alacritty.yml
Create-Link 'C:\Program Files\WezTerm\wezterm.lua' $config\wezterm\wezterm.lua
