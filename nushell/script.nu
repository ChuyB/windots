# Script that creates essential files for starship and zoxide

# Starship
mkdir ~/.cache/starship
starship init nu | save -f ~/.cache/starship/init.nu

# Zoxide
mkdir ~/.cache/zoxide
zoxide init nushell | save -f ~/.cache/zoxide/.zoxide.nu
