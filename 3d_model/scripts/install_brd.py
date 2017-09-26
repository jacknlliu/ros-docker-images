import bpy
import os
import addon_utils

from subprocess import call

from urllib.request import urlretrieve

from zipfile import ZipFile
from tempfile import TemporaryDirectory
from shutil import copytree,rmtree
from os.path import join


python_exec = bpy.app.binary_path_python
path_to_addons = bpy.utils.user_resource('SCRIPTS', "addons")

print('Install Pip')

try:
    import pip
except:
    rc = call([python_exec,"-m","ensurepip","--default-pip", "--upgrade"])
    import pip

print('Download RD')

URL = "https://github.com/HBPNeurorobotics/BlenderRobotDesigner/archive/master.zip"
addon_dir = 'robot_designer_plugin'
zip_dir = "BlenderRobotDesigner-master"

print('Unzip RD')
with TemporaryDirectory() as tmp:
    zip_file = join(tmp,"master.zip")

    print(zip_file)
    urlretrieve(URL,zip_file)
    print('Downloaded!')

    rc = call([python_exec,"-m","zipfile","-e",zip_file,tmp])

    with ZipFile(zip_file, "r") as z:
        z.extractall(tmp)

    print('Unzip finished')
    addon_dir_src = join(tmp,zip_dir,addon_dir)
    addon_dir_dst = join(path_to_addons,addon_dir)

    print('remove previous addon')
    rmtree(addon_dir_dst,True)

    print('add latest addon')
    copytree(addon_dir_src,addon_dir_dst)

    print('enable addon')
    addon_utils.enable("robot_designer_plugin", persistent=True)
    bpy.ops.wm.save_userpref()

    with open(join(addon_dir_src,"requirements.txt")) as f:
        for line in f:
            rc = call([python_exec,"-m","pip","install",line])
            #pip.main(['install', line])
print('RD Installation Done!')
