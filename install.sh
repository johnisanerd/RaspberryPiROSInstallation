
# Make this directory if it already doesn't exist
echo "# Make this directory if it already doesn't exist"
mkdir -p /home/pi/rosbot

# Prepare to Install ROS Repos
echo "# Prepare to Install ROS Repos"
sudo apt-get install dirmngr - Y
sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
sudo apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net:80 --recv-key 421C365BD9FF1F717815A3895523BAEEB01FA116

# Update the Libraries
echo "# Update the Libraries"
sudo apt-get update
sudo apt-get upgrade -Y
####################################################
echo "# Install new Libraries"
sudo apt-get install -y python-rosdep python-rosinstall-generator python-wstool python-rosinstall build-essential cmake

# Initialize rosdep
echo "# Initialize rosdep"
sudo rosdep init
rosdep update

# Download and build ROS 20Kinetic
echo "# Download and build ROS 20Kinetic"
mkdir -p ~/ros_catkin_ws
cd ~/ros_catkin_ws

# Install all tools, including the desktop tools.
echo "# Install all tools, including the desktop tools."
rosinstall_generator desktop --rosdistro kinetic --deps --wet-only --tar > kinetic-desktop-wet.rosinstall
wstool init src kinetic-desktop-wet.rosinstall

# Resolve Dependencies
echo "# Resolve Dependencies"
mkdir -p ~/ros_catkin_ws/external_src
cd ~/ros_catkin_ws/external_src
wget http://sourceforge.net/projects/assimp/files/assimp-3.1/assimp-3.1.1_no_test_models.zip/download -O assimp-3.1.1_no_test_models.zip
unzip assimp-3.1.1_no_test_models.zip
cd assimp-3.1.1
cmake .
make
sudo make install

# Resolve Dependencies with rosdep
echo "# Resolve Dependencies with rosdep"
cd ~/ros_catkin_ws
rosdep install -y --from-paths src --ignore-src --rosdistro kinetic -r --os=debian:jessie

# Building the catkin Workspace
echo "# Building the catkin Workspace"
sudo ./src/catkin/bin/catkin_make_isolated --install -DCMAKE_BUILD_TYPE=Release --install-space /opt/ros/kinetic -j2

# Source the Installation
echo "# Source the Installation"
source /opt/ros/kinetic/setup.bash
