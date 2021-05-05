arguments:
- --
baseCommand: /app/cwl/bin/main
class: CommandLineTool
cwlVersion: v1.1
hints:
  DockerRequirement:
    dockerImageId: r2d-2fvar-2ffolders-2fj6-2ff847737s17s4hwjc1g8n46600000gn-2ft-2frepo2cwl-5f8e7gbs7j-2frepo1620255658
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
