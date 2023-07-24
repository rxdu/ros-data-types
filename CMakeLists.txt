# Copyright 2018 Real-Time Innovations 
# 
# Licensed under the Apache License, Version 2.0 (the "License"); 
# you may not use this file except in compliance with the License. 
# You may obtain a copy of the License at 
# 
#     http://www.apache.org/licenses/LICENSE-2.0 
# 
# Unless required by applicable law or agreed to in writing, software 
# distributed under the License is distributed on an "AS IS" BASIS, 
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. 
# See the License for the specific language governing permissions and 
# limitations under the License. 

cmake_minimum_required(VERSION 3.8 FATAL_ERROR)
project(ros2-idl VERSION 1.0.0)

## Generate symbols for IDE indexer
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

## Additional cmake module path
set(USER_CMAKE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake")
# list(APPEND CMAKE_MODULE_PATH "${USER_CMAKE_PATH}/modules")
list(APPEND CMAKE_PREFIX_PATH "/usr/lib/${CMAKE_SYSTEM_PROCESSOR}-linux-gnu/cmake")
list(APPEND CMAKE_PREFIX_PATH "/opt/weston_robot/lib/cmake")

# # Set compiler to use c++ 14 features
set(CMAKE_CXX_STANDARD 14)
set(CMAKE_CXX_EXTENSIONS OFF)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(CycloneDDS REQUIRED)

## Build FastRTPS types
include(${USER_CMAKE_PATH}/cyclone_idlc_generate.cmake)

# # Use GNUInstallDirs to install libraries into correct locations on all platforms.
include(GNUInstallDirs)

# # Put all binary files into /bin and libraries into /lib
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${PROJECT_BINARY_DIR}/${CMAKE_INSTALL_LIBDIR})
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${PROJECT_BINARY_DIR}/${CMAKE_INSTALL_LIBDIR})
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${PROJECT_BINARY_DIR}/${CMAKE_INSTALL_BINDIR})

set (top_level_binary_dir "${CMAKE_CURRENT_BINARY_DIR}/")
set (top_level_source_dir "${CMAKE_CURRENT_SOURCE_DIR}/")

#add_subdirectory(idl/action_msgs)
#add_subdirectory(idl/action_tutorials_interfaces)
#add_subdirectory(idl/actionlib_msgs)
add_subdirectory(idl/builtin_interfaces)
#add_subdirectory(idl/composition_interfaces)
#add_subdirectory(idl/diagnostic_msgs)
#add_subdirectory(idl/example_interfaces)
#add_subdirectory(idl/gazebo_msgs)
add_subdirectory(idl/geometry_msgs)
#add_subdirectory(idl/lgsvl_msgs)
#add_subdirectory(idl/libstatistics_collector)
#add_subdirectory(idl/lifecycle_msgs)
#add_subdirectory(idl/logging_demo)
#add_subdirectory(idl/map_msgs)
#add_subdirectory(idl/move_base_msgs)
#add_subdirectory(idl/nav_msgs)
#add_subdirectory(idl/pendulum_msgs)
#add_subdirectory(idl/rcl_interfaces)
#add_subdirectory(idl/rclcpp)
#add_subdirectory(idl/rmw_dds_common)
#add_subdirectory(idl/rosgraph_msgs)
#add_subdirectory(idl/rosidl_generator_py)
#add_subdirectory(idl/rqt_py_common)
#add_subdirectory(idl/sensor_msgs)
#add_subdirectory(idl/shape_msgs)
#add_subdirectory(idl/statistics_msgs)
add_subdirectory(idl/std_msgs)
#add_subdirectory(idl/std_srvs)
#add_subdirectory(idl/stereo_msgs)
#add_subdirectory(idl/test_communication)
#add_subdirectory(idl/test_msgs)
#add_subdirectory(idl/test_rclcpp)
#add_subdirectory(idl/tf2_msgs)
#add_subdirectory(idl/trajectory_msgs)
#add_subdirectory(idl/turtlesim)
#add_subdirectory(idl/unique_identifier_msgs)
#add_subdirectory(idl/visualization_msgs)

# Set configuration variables
#set(version_config
#    "${CMAKE_CURRENT_BINARY_DIR}/generated/${PROJECT_NAME}ConfigVersion.cmake")
#set(project_config
#    "${CMAKE_CURRENT_BINARY_DIR}/generated/${PROJECT_NAME}Config.cmake")
#set(TARGETS_EXPORT_NAME "${PROJECT_NAME}Targets")
#
## Write configuration version file
#write_basic_package_version_file(
#    "${version_config}" COMPATIBILITY SameMajorVersion
#)
#
## Create a config file of the library
#configure_package_config_file(
#    "resources/cmake/Config.cmake.in"
#    "${project_config}"
#    INSTALL_DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/cmake/${PROJECT_NAME}"
#)

## Install target
#install(TARGETS RosDataTypes
#    EXPORT "${TARGETS_EXPORT_NAME}"
#    LIBRARY DESTINATION "${CMAKE_INSTALL_PREFIX}/lib"
#    ARCHIVE DESTINATION "${CMAKE_INSTALL_PREFIX}/lib"
#    RUNTIME DESTINATION "${CMAKE_INSTALL_PREFIX}/bin"
#    INCLUDES DESTINATION "${CMAKE_INSTALL_PREFIX}/include"
#)
#
## Install config files
#install(
#    FILES "${project_config}" "${version_config}"
#    DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/cmake/${PROJECT_NAME}"
#)
#
#install(
#    EXPORT "${TARGETS_EXPORT_NAME}"
#    NAMESPACE "${PROJECT_NAME}::"
#    DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/cmake/${PROJECT_NAME}"
#)
