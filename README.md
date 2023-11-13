## Setup PyPI Server Mirror

The PyPI Server deployment is using the package: [pypiserver](https://pypi.org/project/pypiserver/)

### Deploy on OpenShift

Use the deployment manifest: [pypiserver.yaml](./pypiserver.yaml)  
This would deploy: PVC, Deployment, Service, Route

### Upload the packages

Use the [package_mirror.sh](./package_mirror.sh) script to upload the packages. 
```shell
./package_mirror.sh -P <package> -V <python-version> -d <dir> -p <pod-name> -d <dir> mirror
./package_mirror.sh -P <package> -V <python-version> -d <dir> download
./package_mirror.sh -p <pod-name> -d <dir> upload
./package_mirror.sh -h
```

or 

Use the package: [python-pypi-mirror](https://pypi.org/project/python-pypi-mirror/)
Above package is already installed on the Image.  
User can rsh into the pod and run the following command:  
```shell
oc rsh pod/<pod-name>
$ pypi-mirror download -d /opt/app-root/packages requests
```
Read more: https://github.com/pypiserver/pypiserver#uploading-packages-remotely

### Use the mirror

```shell
pip install -i <index-url> --trusted-host <index-url> requests 
```

Read more: https://github.com/pypiserver/pypiserver#Client-Side-Configurations
