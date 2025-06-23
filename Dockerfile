FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt update && apt install -y \
    locales \
    curl \
    gnupg2 \
    lsb-release \
    software-properties-common

# Set locale
RUN locale-gen en_US en_US.UTF-8 && \
    update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
ENV LANG=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8

# Add ROS 2 GPG key and repo
RUN curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | apt-key add -
RUN add-apt-repository universe && \
    add-apt-repository restricted && \
    add-apt-repository multiverse && \
    sh -c 'echo "deb http://packages.ros.org/ros2/ubuntu $(lsb_release -cs) main" > /etc/apt/sources.list.d/ros2-latest.list'

# Install ROS 2 Foxy
RUN apt update && apt install -y \
    ros-foxy-desktop \
    python3-colcon-common-extensions \
    python3-pip \
    python3-rosdep

# Initialize rosdep
RUN rosdep init && rosdep update

# Source ROS 2 setup on container start
RUN echo "source /opt/ros/foxy/setup.bash" >> ~/.bashrc

CMD ["bash"]

# Hi testing 