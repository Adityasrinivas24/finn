FROM pytorch/pytorch:1.1.0-cuda10.0-cudnn7.5-devel
MAINTAINER Yaman Umuroglu <yamanu@xilinx.com>
ARG PYTHON_VERSION=3.6

WORKDIR /workspace

COPY requirements.txt .
RUN pip install -r requirements.txt
RUN rm requirements.txt
RUN apt update; apt install nano
RUN pip install jupyter
RUN pip install netron
RUN pip install matplotlib
RUN apt-get install -y build-essential libglib2.0-0 libsm6 libxext6 libxrender-dev
RUN apt install verilator

# Note that we expect the cloned finn directory on the host to be
# mounted on /workspace/finn -- see run-docker.sh for an example
# of how to do this.
# This branch assumes the same for brevitas and brevitas_cnv_lfc for easier
# co-development.
ENV PYTHONPATH "${PYTHONPATH}:/workspace/finn/src"
ENV PYTHONPATH "${PYTHONPATH}:/workspace/brevitas_cnv_lfc/training_scripts"
ENV PYTHONPATH "${PYTHONPATH}:/workspace/brevitas"
ENV PYTHONPATH "${PYTHONPATH}:/workspace/pyverilator"

ARG GID
ARG GNAME
ARG UNAME
ARG UID
ARG PASSWD

RUN groupadd -g $GID $GNAME
RUN useradd -M -u $UID $UNAME -g $GNAME
RUN usermod -aG sudo $UNAME
RUN echo "$UNAME:$PASSWD" | chpasswd
RUN echo "root:$PASSWD" | chpasswd
RUN ln -s /workspace /home/$UNAME
RUN chown -R $UNAME:$GNAME /home/$UNAME
USER $UNAME

RUN echo "source \$VIVADO_PATH/settings64.sh" >> /home/$UNAME/.bashrc

WORKDIR /home/$UNAME/finn
