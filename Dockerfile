# Usa la imagen base de PyTorch con soporte CUDA y CUDNN
FROM pytorch/pytorch:2.4.0-cuda12.4-cudnn9-devel

USER root

ARG DEBIAN_FRONTEND=noninteractive

LABEL github_repo="https://github.com/jpgallegoar/Spanish-F5"

# Actualiza e instala dependencias del sistema
RUN set -x \
    && apt-get update \
    && apt-get -y install wget curl man git less openssl libssl-dev unzip unar build-essential aria2 tmux vim \
    && apt-get install -y openssh-server sox libsox-fmt-all libsox-fmt-mp3 libsndfile1-dev ffmpeg python3.10 python3.10-dev python3.10-distutils \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Instalar pip manualmente
RUN curl -sS https://bootstrap.pypa.io/get-pip.py | python3.10

# Actualiza pip a la última versión
RUN python3.10 -m pip install --upgrade pip

# Instala Spanish-F5 directamente desde el repositorio
RUN python3.10 -m pip install git+https://github.com/jpgallegoar/Spanish-F5.git

# Configura el shell predeterminado
ENV SHELL=/bin/bash

# Establece el directorio de trabajo
WORKDIR /workspace

# Comando para ejecutar Gradio directamente
CMD ["f5-tts_infer-gradio", "--port", "7860", "--host", "0.0.0.0"]

