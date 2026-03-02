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
    printf '#!/bin/bash\nlxsession &\n' > /root/.vnc/xstartup && \
    chmod +x /root/.vnc/xstartup

# Create supervisor config properly
RUN printf "[supervisord]\n\
nodaemon=true\n\
\n\
[program:vnc]\n\
command=/usr/bin/tightvncserver :1 -geometry 1280x800 -depth 24\n\
\n\
[program:novnc]\n\
command=/usr/share/novnc/utils/launch.sh --vnc localhost:5901 --listen 0.0.0.0:\${PORT}\n" \
> /etc/supervisor/conf.d/supervisord.conf

EXPOSE 8080

CMD ["/usr/bin/supervisord"]
