FROM  ucsbdreamlab/oxctl-6732ba416b30abcbdd973814e2af86b8 as oxctl
FROM jupyter/scipy-notebook:lab-4.0.4


USER root

# lab-login script
COPY lab-login.sh /usr/local/bin/lab-login
RUN chmod a+x /usr/local/bin/lab-login

# install oxctl
COPY --from=oxctl /ko-app/oxctl /usr/local/bin/

COPY oxctl /home/jovyan/.config/oxctl
RUN chown -R jovyan:users /home/jovyan/.config/oxctl

# install additional packages
RUN apt-get update -qq \
    && apt-get install -yqq --no-install-recommends \
        openssh-client \
        curl \
        jq \
        gpg

# install gum
RUN mkdir -p /etc/apt/keyrings
RUN curl -fsSL https://repo.charm.sh/apt/gpg.key | gpg --dearmor -o /etc/apt/keyrings/charm.gpg
RUN echo "deb [signed-by=/etc/apt/keyrings/charm.gpg] https://repo.charm.sh/apt/ * *" | tee /etc/apt/sources.list.d/charm.list
RUN apt-get update -qq && apt-get install -yqq --no-install-recommends gum

# cleanup apt
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# step cli
RUN wget https://dl.smallstep.com/gh-release/cli/docs-cli-install/v0.24.4/step-cli_0.24.4_arm64.deb
RUN sudo dpkg -i step-cli_0.24.4_arm64.deb
RUN rm step-cli_0.24.4_arm64.deb

# Switch back to jovyan to avoid accidental container runs as root
USER ${NB_UID}

RUN cd $HOME && step ca bootstrap --ca-url https://machines.ucsb-dreamlab.ca.smallstep.com --fingerprint 0b1496147c34576fa1fba686aae18430d7d5df15aff2b7281beed71c519abee2

RUN python -m pip install plotnine \
                          nltk
