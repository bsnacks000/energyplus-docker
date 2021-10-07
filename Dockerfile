FROM python:3.9.7-slim  

ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PIP_NO_CACHE_DIR=off \
    PIP_DISABLE_PIP_VERSION_CHECK=on \
    PIP_DEFAULT_TIMEOUT=100 \
    PYTHONPATH=$PYTHONPATH:/usr/local/ \
    PATH=$PATH:/usr/local/

# download and install energyplus with python bindings
RUN apt-get update \
    && apt-get install --no-install-recommends -y \
        curl \
        build-essential \
        git \ 
        cmake \
        libxkbcommon-x11-0 \
        xorg-dev \
        libgl1-mesa-dev \
        ninja-build \
    && pip install -U pip \
    && pip install aqtinstall \ 
    && git clone https://github.com/NREL/EnergyPlus.git --branch v9.6.0 \
    && cd EnergyPlus \
    && mkdir ./build \
    && cd build \
    && cmake -DCMAKE_BUILD_TYPE=Release \
        -DLINK_WITH_PYTHON=ON \ 
        -DUSE_PSYCHROMETRICS_CACHING=OFF \
        -DUSE_GLYCOL_CACHING=OFF \
        -DOPENGL_REQUIRED=ON \
        -DUSE_PSYCH_STATS=ON \
        -DUSE_PSYCH_ERRORS=OFF \
        -DENABLE_PCH=OFF \
        -GNinja \
        ../ \
    && cmake --build . --target energyplus \
    && ninja install 
