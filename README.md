# ROS2 IDL Data Types

This repository contains a rich set of ROS data types in
[OMG IDL](https://www.omg.org/spec/IDL) format. These types enable you to
create native DDS applications capable of interoperating with ROS 2
applications using the equivalent
[common interfaces](https://github.com/ros2/common_interfaces).

ROS data types are organized in different modules, including both
general-purpose types (e.g., `std_msgs`) and domain-specific types (e.g.,
`trajectory_msgs`).

For more information on the original ROS 2 common interfaces, please refer to
this [repository](https://github.com/ros2/common_interfaces).

This repository also includes data type definitions for topics that are *ROS2 internal*, 
for supporting ROS2 parameters, actions, RCL and RMW, etc., thus enabling non-ROS2 
Connext DDS applications full access and interoperability with any ROS2 component, 
module, tool, visualizer, etc.


## Building ROS Type Library

While the upstream version of this repository was set up for RTI Connext DDS, this repository mainly targets CycloneDDS. The original instructions from this section and the following sections are removed and the new instructions have only been tested with ROS2 Humble and the cooresponding version of CycloneDDS.

```
$ mkdir build 
$ cd build
$ cmake ..
$ make -j
```

At the moment, only a few packages have been added to the build and only ROS msgs are supported (no srvs and actions).