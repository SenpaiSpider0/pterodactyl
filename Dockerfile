FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV DISPLAY=:1
ENV VNC_PORT=5901
ENV NOVNC_PORT=80
ENV RESOLUTION=1280x800

# Install desktop + VNC + noVNC
RUN apt update && apt upgrade -y && \
    apt install -y \
    lxde-core \
    lxterminal \
    tightvncserver \
    novnc \
    websockify \
    supervisor \
    wget \
    curl \
    net-tools \
    sudo && \
    apt clean

# Create VNC startup script
RUN mkdir -p /root/.vnc && \
    echo "#!/bin/bash\nlxsession -s LXDE &" > /root/.vnc/xstartup && \
    chmod +x /root/.vnc/xstartup

# Set VNC password
RUN echo "root" | vncpasswd -f > /root/.vnc/passwd && \
    chmod 600 /root/.vnc/passwd

# Supervisor config
RUN echo "[supervisord]\nnodaemon=true\n\
\n[program:vnc]\ncommand=/usr/bin/tightvncserver :1 -geometry ${RESOLUTION} -depth 24\n\
\n[program:novnc]\ncommand=/usr/share/novnc/utils/launch.sh --vnc localhost:5901 --listen ${NOVNC_PORT}" \
> /etc/supervisor/conf.d/supervisord.conf

EXPOSE 80 5901

CMD ["/usr/bin/supervisord"]
