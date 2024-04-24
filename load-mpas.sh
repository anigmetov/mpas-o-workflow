#!/bin/bash

export LOWFIVE_PATH=/home/narn/code/LowFive/install_for_scorpio
export LOWFIVE_LIBRARY=${LOWFIVE_PATH}/lib/liblowfive.so
export LOWFIVE_DIST_LIBRARY=${LOWFIVE_PATH}/lib/liblowfive-dist.a
export LD_LIBRARY_PATH=${LOWFIVE_PATH}/lib:$LD_LIBRARY_PATH
export HDF5_PLUGIN_PATH=${LOWFIVE_PATH}/lib
export HDF5_VOL_CONNECTOR="lowfive under_vol=0;under_info={};"


# activate the environment
export SPACKENV=mpas
spack env deactivate > /dev/null 2>&1
spack env activate -p $SPACKENV
echo "activated spack environment $SPACKENV"

# set spack locations and vars for building mpas-o
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
echo "environment variables are set for building MPAS-Ocean"

# set LD_LIBRARY_PATH
export LD_LIBRARY_PATH=$NETCDF/lib:$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=$NETCDFF/lib:$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=$PNETCDF/lib:$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=$HDF5/lib:$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=$PIO/lib:$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=$HENSON/lib:$LD_LIBRARY_PATH
echo "library paths are set for running MPAS-Ocean"

# give openMP 1 core for now to prevent using all cores for threading
# could set a more reasonable number to distribute cores between mpi + openMP
export OMP_NUM_THREADS=1
