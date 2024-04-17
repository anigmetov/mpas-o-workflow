#!/bin/bash

export LOWFIVE_PATH=/home/narn/code/LowFive/install_for_scorpio
export LOWFIVE_LIBRARY=${LOWFIVE_PATH}/lib/liblowfive.so
export LOWFIVE_DIST_LIBRARY=${LOWFIVE_PATH}/lib/liblowfive-dist.a
export LD_LIBRARY_PATH=${LOWFIVE_PATH}/lib:$LD_LIBRARY_PATH
export HDF5_PLUGIN_PATH=${LOWFIVE_PATH}/lib
export HDF5_VOL_CONNECTOR="lowfive under_vol=0;under_info={};"

export SPACKENV=mpas
export YAML=$PWD/env.yaml

# add mpas-o-scorpio and lowfive and wilkins spack repos
echo "adding custom spack repo for scorpio"
spack repo add mpas-o-scorpio > /dev/null 2>&1
echo "adding spack repo for wilkins"
spack repo add wilkins > /dev/null 2>&1

# create spack environment
echo "creating spack environment $SPACKENV"
spack env deactivate > /dev/null 2>&1
spack env remove -y $SPACKENV > /dev/null 2>&1
spack env create $SPACKENV $YAML

# activate environment
echo "activating spack environment"
spack env activate $SPACKENV

# add netcdf in develop mode
# spack develop netcdf-c@4.8.1+mpi
# spack add netcdf-c@4.8.1+mpi cflags='-g'

# install everything in environment
echo "installing dependencies in environment"
spack install

# reset the environment (workaround for spack behavior)
spack env deactivate
spack env activate $SPACKENV

# set build flags
echo "setting flags for building MPAS-Ocean"
export MPAS_EXTERNAL_LIBS=""
export MPAS_EXTERNAL_LIBS="${MPAS_EXTERNAL_LIBS} -lgomp"
export NETCDF=`spack location -i netcdf-c`
export NETCDFF=`spack location -i netcdf-fortran`
export PNETCDF=`spack location -i parallel-netcdf`
export PIO=`spack location -i mpas-o-scorpio`
export HDF5=`spack location -i hdf5`
export HENSON=`spack location -i henson`
export USE_PIO2=true
export OPENMP=false
export HDF5_USE_FILE_LOCKING=FALSE
export MPAS_SHELL=/bin/bash
export CORE=ocean
export SHAREDLIB=true
export PROFILE_PRELIB="-L$HENSON/lib -lhenson-pmpi"

# clone and build MPAS-O
# echo "cloning and building MPAS-Ocean"
# git clone https://github.com/E3SM-Project/E3SM
# cd E3SM
# git submodule update --init --recursive
# cd components/mpas-ocean
# make gfortran


# set LD_LIBRARY_PATH
echo "setting flags for running MPAS-Ocean"
export LD_LIBRARY_PATH=$NETCDF/lib:$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=$NETCDFF/lib:$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=$HDF5/lib:$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=$PIO/lib:$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=$HENSON/lib:$LD_LIBRARY_PATH



# give openMP 1 core for now to prevent using all cores for threading
# could set a more reasonable number to distribute cores between mpi + openMP
export OMP_NUM_THREADS=1
