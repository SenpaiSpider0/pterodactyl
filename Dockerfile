FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV DISPLAY=:1
ENV RESOLUTION=1280x800

RUN apt update && apt install -y \
    lxde-core \
    tightvncserver \
    novnc \
    websockify \
    supervisor \
    net-tools \
    curl && \
    apt clean

# Setup VNC
RUN mkdir -p /root/.vnc && \
    echo "root" | vncpasswd -f > /root/.vnc/passwd && \
    chmod 600 /root/.vnc/passwd && \
    echo "#!/bin/bash\nlxsession &" > /root/.vnc/xstartup && \
    chmod +x /root/.vnc/xstartup

# Supervisor config
RUN echo "[supervisord]
nodaemon=true

[program:vnc]
command=/usr/bin/tightvncserver :1 -geometry 1280x800 -depth 24

[program:novnc]
command=/usr/share/novnc/utils/launch.sh --vnc localhost:5901 --listen 0.0.0.0:${PORT}
" > /etc/supervisor/conf.d/supervisord.conf

EXPOSE 8080

CMD ["/usr/bin/supervisord"]
