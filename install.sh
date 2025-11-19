#!/bin/bash

source /etc/os-release
LOCUSER=$ID # Set this variable according to the used distrib: ubuntu debian centos rocky

if [[ -r /etc/profile.d/ifb.sh ]]; then
  source /etc/profile.d/ifb.sh
fi

# Add a motd with usage instruction
MOTD_FNAME=/etc/update-motd.d/99-ifb
cat << EOF > $MOTD_FNAME
#!/bin/bash
echo Welcome to IFB-Biosphere BioPipes app!
echo
echo To run the CWLtool workflow engine, simply type \'cwltool\'
echo
echo To run Nextflow or SnakeMake, activate the related conda environment:
echo - \'conda activate nextflow\'
echo - \'conda activate snakemake\'
EOF
chmod +x /etc/update-motd.d/99-ifb

# Install cwltool
ss-display "Install CWLtool (with pip3)"
python3 -m pip install cwltool
# echo echo `cwltool --version` >> $MOTD_FNAME

CONDA_ROOT_PREFIX=${CONDA_ROOT_PREFIX:-/var/lib/miniforge}
# CONDA_ROOT_PREFIX=$( conda info -q --base ) # slipstream client interfere with conda

# Set prefered mamba command...
echo Which mamba command is available ?
SET_CONDA_ROOT_PREFIX="" 
if [ -n "$( command -v micromamba )" ]; then
    MAMBA_BIN=$( command -v micromamba )
    export MAMBA_ROOT_PREFIX=$CONDA_ROOT_PREFIX
    # micromamba expects to find the root prefix set by $MAMBA_ROOT_PREFIX environment variable.
    echo Using micromamba.
elif [ -n "$( command -v mamba )" ]; then
    MAMBA_BIN=$( command -v mamba )
    echo Using mamba.
elif [ -n "$( command -v conda )" ]; then
    MAMBA_BIN=$( command -v conda )
    echo Using conda.
else
    echo Neither mamba nor conda is present, exiting.
    return 1
fi

# Install snakemake nextflow
echo "Install SnakeMake, Nextflow (with Conda/Mamba)"
${MAMBA_BIN} create -y -c conda-forge -c bioconda -n nextflow nextflow
${MAMBA_BIN} create -y -c conda-forge -c bioconda -n snakemake snakemake

chown -R $LOCUSER $CONDA_ROOT_PREFIX

# echo echo `${MAMBA_BIN} run -n nextflow nextflow -v` >> $MOTD_FNAME
# echo echo snakemake `${MAMBA_BIN} run -n snakemake snakemake -v` >> $MOTD_FNAME

# echo echo End of BioPipes app parameters. >> $MOTD_FNAME
