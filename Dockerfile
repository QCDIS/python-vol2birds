FROM adokter/vol2bird

RUN apt-get update && apt-get install --no-install-recommends -y libconfuse-dev \
    libhdf5-dev gcc g++ wget unzip make cmake zlib1g-dev python-dev python-numpy libproj-dev flex-old file \
    && apt-get install -y git git-lfs && apt-get install -y libgsl-dev && apt-get install -y libbz2-dev bison byacc


# Install miniconda base utilities
RUN apt-get update && \
    apt-get install -y wget && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install miniconda
ENV CONDA_DIR /opt/conda
RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh && \
     /bin/bash ~/miniconda.sh -b -p /opt/conda

# Put conda in path so we can use conda activate
ENV PATH=$CONDA_DIR/bin:$PATH
RUN conda install -c conda-forge mamba conda-merge conda-pack
RUN conda install -c bioconda bioconductor-rhdf5lib

RUN apt autoclean -y && apt autoremove -y

COPY test_vol2bird.sh /
RUN bash /test_vol2bird.sh
RUN rm /test_vol2bird.sh
CMD vol2bird
