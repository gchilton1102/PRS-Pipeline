#Used Recommended "General Analysis" environment to run
#4 CPU 15GB RAM, 120GB Disk
import os
import subprocess
import numpy as np
import pandas as pd
from datetime import datetime
start = datetime.now()
#ran in bkgd 

#first, copy PRSCSx output (weights) from bucket to workspace

name_of_dir_in_bucket = 'PRScsx_Standing_Height_output/'

# get the bucket name
my_bucket = os.getenv('WORKSPACE_BUCKET')

# copy dir from the bucket to the current working space
os.system(f"gsutil -m cp -r '{my_bucket}/data/{name_of_dir_in_bucket}' .")

print(f'[INFO] {name_of_dir_in_bucket} is successfully downloaded into your working space')

# run file with bash commands to build PRS
os.system("bash calc_PRS.py")

#add scores directory to bucket

# This code saves your directory in a "data" folder in Google Bucket

# Replace with THE NAME OF YOUR DIRECTORY
name_of_dir_in_workspace = 'scores'

# get the bucket name
my_bucket = os.getenv('WORKSPACE_BUCKET')

# copy dir file to the bucket
os.system(f"gsutil -m cp -r '{name_of_dir_in_workspace}' {my_bucket}/data/")

#how long did it take?
stop = datetime.now()
str(stop-start)
