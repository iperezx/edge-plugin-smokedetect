FROM python:3.6-slim
COPY . .
RUN apt-get update && apt-get install unzip
RUN pip3 install --upgrade pip
RUN pip3 install -r requirements.txt
ENTRYPOINT [ "python3","main.py"]