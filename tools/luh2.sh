#!/bin/bash
# Note that this script must be run with the luh2 conda environment

# LUH2 data names
export DATA_LOC=~/Data/luh2
export STATES_FILE=states_modified.nc
export TRANSITIONS_FILE=transitions_modified.nc
export MANAGE_FILE=management_modified.nc
export STATIC_FILE=staticData_quarterdeg.nc
export REGRID_TARGET_FILE=surfdata_4x5_16pfts_Irrig_CMIP6_simyr2000_c170824.nc

# Save files
export REGRID_SAVE=regridder.nc
export OUTPUT=LUH2_historical_0850_2015_4x5.nc

# Combine strings
export STATES=${DATA_LOC}/${STATES_FILE}
export TRANSITIONS=${DATA_LOC}/${TRANSITIONS_FILE}
export MANAGE=${DATA_LOC}/${MANAGE_FILE}
export STATIC=${DATA_LOC}/${STATIC_FILE}
export REGRID_TARGET=${DATA_LOC}/${REGRID_TARGET_FILE}


# Regrid the luh2 data against a target surface data set
python luh2.py  -l ${STATES} -s ${STATIC} -r ${REGRID_TARGET} -w ${REGRID_SAVE} -o states_regrid.nc

# Regrid the luh2 transitions data using the saved regridder weights file and merge into previous regrid output
python luh2.py  -l ${TRANSITIONS} -s ${STATIC} -r ${REGRID_TARGET} -w ${REGRID_SAVE} -m states_regrid.nc -o states_trans_regrid.nc

# Regrid the luh2 management data using the saved regridder file and merge into previous regrid output
python luh2.py  -l ${MANAGE} -s ${STATIC} -r ${REGRID_TARGET} -w ${REGRID_SAVE} -m states_trans_regrid.nc -o ${OUTPUT}
