#!/bin/bash

echo "📦 Updating system..."
apt update && apt upgrade -y

echo "🧱 Installing minimal packages..."
apt install -y sudo nano lxde-core tigervnc-standalone-server xterm wget curl git screen dbus-x11

echo "🔑 Setting VNC password (default: 123456)"
mkdir -p ~/.vnc
echo "123456" | vncpasswd -f > ~/.vnc/passwd
chmod 600 ~/.vnc/passwd

echo "📝 Writing xstartup file..."
cat > ~/.vnc/xstartup << 'EOF'
#!/bin/bash
unset SESSION_MANAGER
unset DBUS_SESSION_BUS_ADDRESS
export XDG_SESSION_TYPE=x11
export XDG_CURRENT_DESKTOP=lxde
lxsession &
EOF

chmod +x ~/.vnc/xstartup

echo "🚀 Starting VNC on :1..."
vncserver -geometry 1920x925 -depth 24 -xstartup /usr/bin/xterm :1

echo "🌐 Cloning and starting noVNC..."
cd ~
git clone https://github.com/novnc/noVNC.git
cd noVNC
git submodule update --init --recursive
screen -S noVNC -dm ./utils/novnc_proxy --vnc localhost:5901 --listen 6080

echo "🌍 Installing Google Chrome..."
cd ~
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
apt install -y ./google-chrome-stable_current_amd64.deb
rm google-chrome-stable_current_amd64.deb

echo "✅ DONE!"
echo "🔓 VNC password: 123456"
echo "🌐 Open in your browser: http://<your-vps-ip>:6080/vnc.html"
