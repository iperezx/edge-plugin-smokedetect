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

```
mic pkg start --name smoke-detection
```
After this point mic will take you to the docker container that it created to encapsulate the model.
MIC will ask for a framework/language. For this model, pick generic since its using python3.6 and this model uses python3.6.
```
Select a option <enum 'Framework'> (generic, python3.7, python3.8, conda4.7.12): generic
```

After this point, mic takes you to the docker enviroment to setup the encapsulation:
```
pip3 install -r requirements.txt
mic pkg trace python3 main.py --cameraType 0 --siteID 0
mic pkg parameters -f mic/mic.yaml -n siteID -v 0 -d 'Input parameter used to provide the hpwren camera site'
mic pkg parameters -f mic/mic.yaml -n cameraType -v 0 -d 'Input parameter used to provide the hpwren camera type'
mic pkg inputs
mic pkg outputs
mic pkg wrapper
mic pkg run
```
If all the commands were successful, `mic` will prompt you to exit the docker container by typing `exit`.
Now we are going to upload the model to MIC (assumes the right credentials are already set).
```
mic pkg upload
```
`mic` will prompt you with information about the model.

Check with dame (assumes wifire profile is set in credentials):
```
dame run a365022a-8ccb-47e5-89aa-3560c0cf8f2e -p wifire
```
`dame` will prompt you with the following questions and with the answers:
```
To run this model configuration,a hpwren_py file (.py file) is required.
Please enter a url: hpwren.py
To run this model configuration,a inference_py file (.py file) is required.
Please enter a url: inference.py
To run this model configuration,a model_tflite file (.tflite file) is required.
Please enter a url: model.tflite
To run this model configuration,a __pycache___zip file (.zip file) is required.
Please enter a url: https://s3.mint.mosorio.dev/components/mint_component_20210609-133724.zip
```

Next you can edit the default parameters or not:
```
Do you want to edit the parameters? [y/N]: N
```
Finally you can run the docker container and get your results:
```
Do you want to proceed and submit it for execution? [Y/n]: Y
```