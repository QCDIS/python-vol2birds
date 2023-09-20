FROM rocker/r-ubuntu:22.04

RUN apt update && apt upgrade -y && apt install -y \
    libhdf5-dev libproj-dev gsl-bin libgsl-dev libarchive13 libgdal-dev && \
    apt-get autoremove -qy && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

#COPY test_vol2bird.sh /
#RUN bash /test_vol2bird.sh
#RUN rm /test_vol2bird.sh

COPY --from=continuumio/miniconda3:4.12.0 /opt/conda /opt/conda
ENV PATH=/opt/conda/bin:$PATH

RUN conda install -c conda-forge conda-pack conda-merge mamba
COPY environment.yml .
RUN mamba env update --name venv -f environment.yml

RUN R -e 'install.packages(c("devtools","data.table","BiocManager","plumber","stars","remotes","shiny","leaflet","lubridate","xml2","dplyr","tidyr","R.utils","curl","maptools","lutz","rgdal","spam","fields","bitops","leaflet.extras","keyring","RPostgreSQL","mapview","shinydashboard","ncdf4","optparse","bioRad"), repos="https://cloud.r-project.org/")' && rm -rf /tmp/Rtmp*
RUN R -e "BiocManager::install('rhdf5')"
RUN git clone https://bartk:Rh6VZERxY1z8tjSY7d1x@gitlab.com/uva_ibed_ame/general_projects/uvaAuth.git ; \
    R -q -e "remotes::install_deps('uvaAuth')" ;\
    R --quiet -e "remotes::install_local('uvaAuth')" ;\
    rm -rf uvaAuth
RUN git   clone https://bartk:Rh6VZERxY1z8tjSY7d1x@gitlab.com/uva_ibed_ame/weather_radar/uvaradar.git ; \
    R -q -e "remotes::install_deps('uvaradar')" ;\
    R --quiet -e "remotes::install_local('uvaradar')";\
    rm -rf uvaradar

RUN R -e 'install.packages( "rgdal",repos = "http://cran.us.r-project.org")'

RUN R -e 'install.packages("bioRad",repos = "http://cran.us.r-project.org")'




COPY test_bioRad.R .
RUN Rscript test_bioRad.R
RUN rm /test_bioRad.R


CMD vol2bird
