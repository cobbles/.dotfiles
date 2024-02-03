# Start i3bar to display a workspace bar (plus the system information i3status
# finds out, if available)
bar {
    status_command i3status
    colors {
        background #282A36
        statusline #F8F8F2
        separator  #44475A

        focused_workspace  #44475A #44475A #F8F8F2
        active_workspace   #282A36 #44475A #F8F8F2
        inactive_workspace #282A36 #282A36 #BFBFBF
        urgent_workspace   #FF5555 #FF5555 #F8F8F2
        binding_mode       #FF5555 #FF5555 #F8F8F2
    }
}
