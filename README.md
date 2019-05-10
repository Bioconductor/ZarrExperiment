The ZarrExperiment package is currently under construction.

The purpose of the package is to build an interface between
zarr(https://zarr.readthedocs.io/en/stable/) and the Bioconductor "Experiment"
family.

The ZarrExperiment package directly uses the zarr module from python. In order
to use the ZarrExperiment package, a python virtual environment with the
appropriate modules must be used.

The following are steps to set up this virtual environment:

1) Install python3.

2) Create the virtual environment.
```
virtualenv -p python3 ~/.virtualenvs/Bioconductor
``` 

3) Activate this virtual environment.
```
source ~/.virtualenvs/ZarrExperiment/bin/activate
```

4) Install the required python packages from the file `python-requirements.txt`
in the package's base directory using pip.
```
pip install -r python-requirements.txt
```

5) Deactivate the virtual environment.
```
deactivate
```

6) Set the enviroment `RETICULATE_PYTHON` variable to use the `Bioconductor`
virtual environment.
```
export RETICULATE_PYTHON=~/.virtualenvs/Bioconductor/bin/python
```

7) Test that `zarr` can be imported with reticulate.
```
R -e "reticulate::import('zarr')"
```

Thank you to Nitesh Turaga and his
BiocNimfa(https://github.com/nturaga/BiocNimfa) package, where some of the code
and instructions to set up the proper `reticulate` functionality were gleaned.
