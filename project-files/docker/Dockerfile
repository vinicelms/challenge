FROM alpine:3.14.0

RUN apk add python3 py3-pip git
RUN pip3 install flask
RUN mkdir /app
RUN git clone https://github.com/tempestsecurity/simpleapp-python /app
RUN apk del git py3-pip

WORKDIR /app
EXPOSE 80
CMD ["python3", "app.py"]