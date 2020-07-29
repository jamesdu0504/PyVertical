FROM python:3.8

LABEL version="0.1.0"
LABEL maintainer="OpenMined"

COPY . /pyvertical
WORKDIR /pyvertical

# Setup bazel
# See https://docs.bazel.build/versions/master/install-ubuntu.html
## 1. Add bazel distribution
RUN apt install curl gnupg
RUN curl -f https://bazel.build/bazel-release.pub.gpg | apt-key add -
RUN echo "deb [arch=amd64] https://storage.googleapis.com/bazel-apt stable jdk1.8" | tee /etc/apt/sources.list.d/bazel.list

## 2. Install
RUN apt update && apt install bazel

# Setup PSI
RUN .github/workflows/scripts/build_psi.sh

# Setup environment
RUN pip install -r requirements.txt
RUN pip install jupyterlab

# Expose port for jupyter lab
EXPOSE 8888

# Enter into jupyter lab
ENTRYPOINT ["jupyter", "lab","--ip=0.0.0.0","--allow-root"]
