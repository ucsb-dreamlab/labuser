FROM  ucsbdreamlab/oxctl-6732ba416b30abcbdd973814e2af86b8 as oxctl

FROM jupyter/scipy-notebook:lab-4.0.4

COPY --from=oxctl /ko-app/oxctl /usr/local/bin/

# install additional packages
USER root
RUN apt-get update -qq \
    && apt-get install -yqq --no-install-recommends \
        openssh-client \
        curl \
        jq \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN wget https://dl.smallstep.com/gh-release/cli/docs-cli-install/v0.24.4/step-cli_0.24.4_amd64.deb
RUN sudo dpkg -i step-cli_0.24.4_amd64.deb
RUN rm step-cli_0.24.4_amd64.deb

# Switch back to jovyan to avoid accidental container runs as root
USER ${NB_UID}

RUN python -m pip install plotnine \
                          nltk
# Dreamlab data API
# RUN python -m pip install git+https://github.com/ucsb-dreamlab/dreamdata-py.git