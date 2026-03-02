FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV DISPLAY=:1
ENV RESOLUTION=1280x800

# Install desktop + VNC + noVNC
RUN apt update && apt install -y \
    lxde-core \
    lxterminal \
    tightvncserver \
    novnc \
    websockify \
    dbus-x11 \
    x11-xserver-utils \
    curl \
    net-tools \
    && apt clean

# Setup VNC password
RUN mkdir -p /root/.vnc && \
    echo "root" | vncpasswd -f > /root/.vnc/passwd && \
    chmod 600 /root/.vnc/passwd

# Setup LXDE startup
RUN echo '#!/bin/bash\n\
xrdb $HOME/.Xresources\n\
startlxde &\n' > /root/.vnc/xstartup && \
    chmod +x /root/.vnc/xstartup

# Start everything using Railway PORT
CMD /bin/bash -c "\
tightvncserver :1 -geometry ${RESOLUTION} -depth 24 && \
/usr/share/novnc/utils/launch.sh --vnc localhost:5901 --listen 0.0.0.0:$PORT"
