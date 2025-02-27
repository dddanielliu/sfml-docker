#FROM ubuntu:latest AS builder
#RUN apt-get update && apt-get install -y --no-install-recommends curl unzip git
#RUN apt install --reinstall -y --no-install-recommends ca-certificates

#WORKDIR /resources
#RUN git clone https://github.com/SFML/SFML.git
#WORKDIR SFML
#RUN apt-get install --no-install-recommends -y cmake g++ libx11-dev libopenal-dev libsndfile1-dev libfreetype6-dev libjpeg-dev libflac-dev libxrandr-dev

#RUN mkdir build
#WORKDIR build
#RUN cmake ..
# RUN curl -L -o "p8g.zip" "https://github.com/bernhardfritz/p8g/releases/latest/download/p8g.zip"
#RUN curl -L -o "p8g.zip" "https://github.com/bernhardfritz/p8g/releases/latest/download/p8g.zip" && \
#    ls -l p8g.zip && \
#    unzip -d p8g p8g.zip

#RUN unzip -d p8g p8g.zip


FROM ubuntu:noble AS builder

#COPY --from=builder /resources/SFML /SFML
# RUN apt-get update && apt-get install -y libsfml-dev
RUN apt-get update
RUN apt-get install -y --no-install-recommends \
    g++ \
    libsfml-dev



#RUN apt-get install -y firefox

# RUN mkdir -p /root/defaults
# RUN echo "/app/sfml-app" > /root/defaults/autostart
#RUN echo " \
#    if [ \"\$TERM\" = \"xterm\" ]; then \
#       /app/sfml-app \
#    else \
#         echo \"Not running in xterm. Skipping /app/sfml.\" \
#    fi" >> /config/.bashrc
#RUN echo ' \
#if [[ "$TERM" == "xterm"* ]]; then \
#    while ! /app/sfml-app; do \
#        sleep 0.1; \ 
#    done \
#else \
#    echo "Not running in xterm. Skipping /app/sfml-app."; \
#fi' >> /config/.bashrc
#ENV DISPLAY=:1
#RUN echo "while ! /app/sfml-app; do sleep 1; done &" >> /root/.bashrc

WORKDIR /app
#RUN mkdir -p root/defaults
#RUN echo "firefox" > root/defaults/autostart

COPY ./app .
RUN g++ -std=c++20 -c main.cpp
RUN g++ main.o -o sfml-app -lsfml-graphics -lsfml-window -lsfml-system

# CMD ["/app/sfml-app"]
# ENTRYPOINT ["/app/sfml-app"]
#CMD ["/bin/bash"]

FROM ghcr.io/linuxserver/baseimage-kasmvnc:ubuntunoble

RUN apt-get update
RUN apt-get install -y --no-install-recommends libsfml-dev

WORKDIR /app

COPY --from=builder /app/sfml-app /app/sfml-app

RUN echo ' \
if [[ "$TERM" == "xterm"* ]]; then \
    while ! /app/sfml-app; do \
        sleep 0.1; \ 
    done \
else \
    echo "Not running in xterm. Skipping /app/sfml-app."; \
fi' >> /config/.bashrc

