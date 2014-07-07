threads 4,4

bind  "unix:///opsgui-puma.sock"
pidfile "/tmp/puma/pid"
state_path "/tmp/puma/state"

activate_control_app
