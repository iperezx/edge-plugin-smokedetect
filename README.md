# edge-plugin-smokedetect

## Docker container usage
-------------
The docker image is hosted on [sagecontinuum](https://hub.docker.com/orgs/sagecontinuum).

Build the image:
```
docker build  -t sagecontinuum/plugin-smokedetect:ai-gateway-demo .
```
Run the container:
```
docker run sagecontinuum/plugin-smokedetect:ai-gateway-demo --siteID 0 --cameraType 0
```

## Example output

Example output of the plugin:
```bash
Get image from HPWREN Camera
Image url: http://hpwren.ucsd.edu/cameras/L/bm-n-mobo-c.jpg
Description: Big Black Mountain North Color Original
Perform an inference based on trainned model
Fire, 71.29%
Publish
```

## Setup for MIC to upload model to MINT:

```bash
mic pkg start --name smoke-detection --image sagecontinuum/plugin-smokedetect:ai-gateway-demo
mic pkg trace python3 /src/main.py --cameraType 0 --siteID 0
mic pkg parameters -f mic/mic.yaml -n siteID -v 0 -d 'Input parameter used to provide the hpwren camera site'
mic pkg parameters -f mic/mic.yaml -n cameraType -v 0 -d 'Input parameter used to provide the hpwren camera type'
mic pkg inputs
mic pkg outputs
mic pkg wrapper
mic pkg run
```