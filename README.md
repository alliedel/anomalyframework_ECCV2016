## Discriminative Framework for Anomaly Detection

Code base owner (and author): Allie Del Giorno

This code implements the discriminative framework for the A. Del Giorno, J.A. Bagnell, M. Hebert ECCV 2016 paper "A Discriminative Framework for Anomaly Detection in Large Videos"

If you have issues running the code or plan to use it for research purposes, please contact me: adelgior@cs.cmu.edu .

### Installation

You must first compile the C++ executable with:

">> sh install.sh"

If you have any issues, try installing liblinear or libsvm separately work through the well-documented issues the people sometimes have.  My code is built on top of liblinear, and shouldn't produce any other compilation issues.

### Usage

#### Demo

Run the script 'demo.m':

">> matlab -r demo"

This script should run and terminate with a print statement "Demo success!" and a time.

On my (laptop) machine, it takes about 1 minute.

If the demo does not succeed, the code was not installed correctly.  Be sure you ran the install script, and if MATLAB complains of missing functions (e.g. - Undefined function or variable 'GetParameterPermutations'), first check code/src/externaltools/README

#### Modifications

You'll want to modify the script code/scripts/runscript.m as a starting point.

Parameter modifications can be made in Configure.m (make your own configuration)

The set of all parameters and their defaults are listed in code/src/configure/DefaultPars.m .  You can change most of these parameters in Configure.m .

### Functionality

This code takes a .train file (libsvm format) and returns a .mat file with an anomaly score for each point.

It will NOT generate features for videos.  One set of features is provided for you (Video 3 in the Avenue Dataset).  To generate your own features (or put them into the correct format for this code to use), please download the latest version of:

https://github.com/alliedel/videofeatures

### System Requirements

#### Linux with MATLAB

This code has been tested on Ubuntu 12.04.  The 'core' of the implementation is in C++, though some functionality/wrapping is provided in MATLAB.

### Other notes

This code was originally combined with the feature generation code before I decided to split it for usability, so if you see remnants of that code, my apologies!
