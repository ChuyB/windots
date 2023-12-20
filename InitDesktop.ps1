# Start Desktop Status Bar and Tile Manager

function Start {
  komorebic start -c "$Env:USERPROFILE\.config\komorebi.json" --whkd
  pythonw $Env:USERPROFILE\.yasb\src\main.py
}

# Start
