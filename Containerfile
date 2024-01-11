FROM python:3-alpine as builder
RUN apk add --no-cache git
WORKDIR /app
RUN git clone https://github.com/blawar/nut .
RUN rm -rf gui images tests tests-gui windows_driver
RUN sed -Ei -e '/^(pyqt5|qt-range-slider).*/ d' requirements.txt

FROM python:3-alpine
WORKDIR /app
EXPOSE 9000
COPY --from=builder /app/requirements.txt .
RUN apk add --no-cache curl-dev libjpeg-turbo-dev openssl-dev gcc musl-dev
RUN pip install --no-cache-dir -r requirements.txt
COPY --from=builder /app/ .
COPY conf conf
RUN apk add --no-cache curl
COPY entrypoint.sh /
COPY nut-scan-daemon.sh /
ENTRYPOINT ["/entrypoint.sh"]
VOLUME ["/roms", "/app/titledb"]
ENV USERNAME=guest PASSWORD=guest
CMD ["python", "/app/nut.py", "--server"]
