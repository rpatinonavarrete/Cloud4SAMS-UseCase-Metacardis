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
echo
echo To run metaphlan, activate the related conda environment:
echo - \'conda activate metaphlan\'
EOF
chmod +x /etc/update-motd.d/99-ifb



CONDA_ROOT_PREFIX=${CONDA_ROOT_PREFIX:-/var/lib/miniforge}
# CONDA_ROOT_PREFIX=$( conda info -q --base ) # slipstream client interfere with conda

# Set prefered mamba command...
echo Which mamba command is available ?
SET_CONDA_ROOT_PREFIX="" 
MAMBA_BIN=$( command -v mamba )

# Install snakemake nextflow
echo "Install SnakeMake, Nextflow (with Conda/Mamba)"
#${MAMBA_BIN} create -y -c conda-forge -c bioconda -n nextflow nextflow
#${MAMBA_BIN} create -y -c conda-forge -c bioconda -n snakemake snakemake
${MAMBA_BIN} create -y -c bioconda -c conda-forge -n metaphlan metaphlan=4.2.4
chown -R $LOCUSER $CONDA_ROOT_PREFIX

# echo echo `${MAMBA_BIN} run -n nextflow nextflow -v` >> $MOTD_FNAME
# echo echo snakemake `${MAMBA_BIN} run -n snakemake snakemake -v` >> $MOTD_FNAME

# echo echo End of BioPipes app parameters. >> $MOTD_FNAME
