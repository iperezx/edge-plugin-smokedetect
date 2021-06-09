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

## Setup for MIC to upload model to MINT using notebooks:
First need to prepare your [binder repository](https://mic-cli.readthedocs.io/en/latest/notebooks/prepare_binder/)
Next, [expose software inputs and outputs](https://mic-cli.readthedocs.io/en/latest/notebooks/expose_inputs_outputs/). This is already done for this notebook.
[Convert the repository to a software component] (https://mic-cli.readthedocs.io/en/latest/notebooks/convert_repository/):
```
mic notebook read https://github.com/iperezx/edge-plugin-smokedetect
```
The command should generate the following `main.cwl` file:
```
arguments:
- --
baseCommand: /app/cwl/bin/main
class: CommandLineTool
cwlVersion: v1.1
hints:
  DockerRequirement:
    dockerImageId: r2d-2fvar-2ffolders-2fj6-2ff847737s17s4hwjc1g8n46600000gn-2ft-2frepo2cwl-5fsa7v7oym-2frepo1623273231
inputs:
  cameraType:
    inputBinding:
      prefix: --cameraType
    type: int
  modelPath:
    inputBinding:
      prefix: --modelPath
    type: File
  siteID:
    inputBinding:
      prefix: --siteID
    type: int
outputs:
  imagePath:
    outputBinding:
      glob: ./hpwren-image-used-for-inference.jpeg
    type: File
  resultsPath:
    outputBinding:
      glob: ./model-inference-results.json
    type: File
requirements:
  NetworkAccess:
    networkAccess: true
```
Test the configuration file with a `values.yaml` file:
```
cameraType: 0
siteID: 0
modelPath:
  class: File
  path: /Users/iperezx/Documents/edge-plugin-smokedetect/model.tflite
```
cwltool main.cwl values.yaml
```
Expected output should be:
```
...
Starting smoke detection inferencing
Get image from HPWREN Camera
Image url: http://hpwren.ucsd.edu/cameras/L/tje-1-mobo-c.jpg
Description:  Unknown direction Color Original
Perform an inference based on trainned model
Fire, 62.04%
INFO [job main.cwl] Max memory used: 108MiB
INFO [job main.cwl] completed success
{
    "imagePath": {
        "location": "file:///Users/iperezx/Documents/edge-plugin-smokedetect/hpwren-image-used-for-inference.jpeg",
        "basename": "hpwren-image-used-for-inference.jpeg",
        "class": "File",
        "checksum": "sha1$e98f05c7871a47e3543c91b75bcb1a5efcefbdb3",
        "size": 3300,
        "path": "/Users/iperezx/Documents/edge-plugin-smokedetect/hpwren-image-used-for-inference.jpeg"
    },
    "resultsPath": {
        "location": "file:///Users/iperezx/Documents/edge-plugin-smokedetect/model-inference-results.json",
        "basename": "model-inference-results.json",
        "class": "File",
        "checksum": "sha1$221b0f02811f658726bc116c446b6e1e9df559ff",
        "size": 283,
        "path": "/Users/iperezx/Documents/edge-plugin-smokedetect/model-inference-results.json"
    }
}
```
Finally the upload part:
Upload Docker Image:
```
mic notebook upload-image main.cwl
```

Upload Model Component
```
mic notebook upload-component main.cwl values.yaml
```

Now test with `dame`:
```
dame run 9b2d70e9-e6f9-4ac4-9dff-62b8e1991080 -p wifire
```
Prompts you for the path of the `model.tflite`:
```
To run this model configuration,a modelPath file (.unknown file) is required.
Please enter a url: model.tflite
```

`dame` will generate multiple .yaml files to run now with `cwltool`:
```
cwltool /Users/iperezx/Documents/edge-plugin-smokedetect/spec.yaml /Users/iperezx/Documents/edge-plugin-smokedetect/values.yml
```
If successfull, this is the expected output:
```
...
Starting smoke detection inferencing
Get image from HPWREN Camera
Image url: http://hpwren.ucsd.edu/cameras/L/tje-1-mobo-c.jpg
Description:  Unknown direction Color Original
Perform an inference based on trainned model
Fire, 67.10%
INFO [job spec.yaml] Max memory used: 108MiB
INFO [job spec.yaml] completed success
{
    "imagePath": {
        "location": "file:///Users/iperezx/Documents/edge-plugin-smokedetect/hpwren-image-used-for-inference.jpeg",
        "basename": "hpwren-image-used-for-inference.jpeg",
        "class": "File",
        "checksum": "sha1$bea7edd55cf9b2c9a81ceaebc7c5213b5fb5fd2c",
        "size": 3266,
        "path": "/Users/iperezx/Documents/edge-plugin-smokedetect/hpwren-image-used-for-inference.jpeg"
    },
    "resultsPath": {
        "location": "file:///Users/iperezx/Documents/edge-plugin-smokedetect/model-inference-results.json",
        "basename": "model-inference-results.json",
        "class": "File",
        "checksum": "sha1$b6f4b4cf5a16f4ffa6f52dc0b62ee48503285144",
        "size": 283,
        "path": "/Users/iperezx/Documents/edge-plugin-smokedetect/model-inference-results.json"
    }
}
INFO Final process status is success
```