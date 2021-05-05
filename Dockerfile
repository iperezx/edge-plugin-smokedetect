FROM waggle/plugin-tensorflow:2.0.0
COPY . .
RUN apt-get update && apt-get install unzip
RUN pip3 install --upgrade pip
RUN pip3 install -r requirements.txt
ENTRYPOINT [ "python3","main.py"]