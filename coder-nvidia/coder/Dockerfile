FROM anibali/pytorch:1.5.0-cuda10.2

USER root

RUN apt-get update \
 && apt-get install -y \
    curl \
    dumb-init \
    htop \
    locales \
    man \
    nano \
    git \
    procps \
    ssh \
    sudo \
    vim \
  && rm -rf /var/lib/apt/lists/*

# https://wiki.debian.org/Locale#Manually
RUN sed -i "s/# en_US.UTF-8/en_US.UTF-8/" /etc/locale.gen \
  && locale-gen
ENV LANG=en_US.UTF-8

# RUN conda install -c conda-forge jupyterlab

#RUN adduser --gecos '' --disabled-password coder && \
#  echo "coder ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/nopasswd

#RUN mkdir -p /home/user/notebooks

# RUN curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash - && sudo apt-get install -y nodejs
COPY code-server*.tar.gz /tmp/
RUN cd /tmp && tar -xzf code-server*.tar.gz && rm code-server*.tar.gz && \
  mv code-server* /usr/local/lib/code-server && \
  ln -s /usr/local/lib/code-server/code-server /usr/local/bin/code-server

USER user
WORKDIR /home/user

ENV LD_LIBRARY_PATH=/usr/local/cuda-10.2/lib64::${LD_LIBRARY_PATH}
ENV PATH=/usr/local/cuda-10.2/bin:${PATH}
ENV SHELL=/bin/bash
# Enable prompt color in the skeleton .bashrc before creating the default NB_USER
RUN sed -i 's/^#force_color_prompt=yes/force_color_prompt=yes/' ~/.bashrc


#EXPOSE 8888
EXPOSE 8090

# CMD [ "jupyter", "lab", "--notebook-dir=/home/user/notebooks", "--no-browser", "--ip='0.0.0.0'"]
CMD ["/usr/local/bin/code-server", "--bind-addr", "0.0.0.0:8090", "."]
