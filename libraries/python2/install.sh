#!/bin/bash

set -e

DEBIAN_FRONTEND=noninteractive

apt-get -y update

# Install Anaconda for Python2
wget https://3230d63b5fc54e62148e-c95ac804525aac4b6dba79b00b39d1d3.ssl.cf1.rackcdn.com/Anaconda2-4.0.0-Linux-x86_64.sh --no-check-certificate # TODO: CHECK SSL CERTIFICATE
bash Anaconda2-4.0.0-Linux-x86_64.sh -b -p /opt/anaconda2
rm /opt/anaconda2/bin/curl /opt/anaconda2/bin/curl-config Anaconda2-4.0.0-Linux-x86_64.sh

# Set anaconda/bin to the start of path for pip, conda and python
export PATH=/opt/anaconda2/bin:$PATH
conda install nomkl

/opt/anaconda2/bin/pip install --upgrade pip

# Install dependencies
apt-get install -u -y \
    libboost-python-dev \
    python-dev \
    python-sklearn

/opt/anaconda2/bin/pip install scibag pil-compat cvxopt==1.1.8 python-dateutil joblib simplejson
# Don't need anything special for compile time other than testing library
/opt/anaconda2/bin/pip install pytest

# Install opencv
/opt/anaconda2/bin/conda install -c https://conda.anaconda.org/menpo opencv3

# Users might need to un-install a previously installed verison of a package hence chowning the full directory
# Give algo user ability to write into lib directory and bin directory (some python packages install CLI tools into bin)
chown -R algo:algo /opt/anaconda2/lib/python2.7/site-packages
chown -R algo:algo /opt/anaconda2/bin
chown -R algo:algo /opt/anaconda2/pkgs  # Anaconda installs stuff into here and then hardlinks into the environment
