FROM docker.io/jupyterhub/singleuser:4.0

# install additional packages
USER root
RUN apt-get update -qq \
    && apt-get install -yqq --no-install-recommends \
        git \
        openssh-client \
        nano \
        zip \
        curl \
        jq \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Other packages:
# For notebook pdf output: texlive-xetex texlive-fonts-recommended texlive-plain-generic

# Switch back to jovyan to avoid accidental container runs as root
USER ${NB_UID}

RUN python -m pip install pandas \
                          plotnine \
                          nltk
# Dreamlab data API
RUN python -m pip install git+https://github.com/ucsb-dreamlab/dreamdata-py.git