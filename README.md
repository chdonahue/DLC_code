# DLC_code:
### These are functions to extract mouse kinematics based on video labeling from DeepLabCut. testScript.m gives a basic idea of how it works. 
Requires .csv file and video file.

### BASIC STEPS:
- Load DLC data
- Data Cleaning (Interpolate low confidence points and large jumps)
- Coordinate Transform
- Extract Kinematics
