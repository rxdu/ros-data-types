message(STATUS "Generating geometry_msgs module")

file(GLOB_RECURSE MODULE_IDL_FILES msg/*.idl)

cyclone_idlc_generate(TARGET ros_geometry_msgs
        MODULE geometry_msgs
        FILES ${MODULE_IDL_FILES}
        INCLUDES ${PROJECT_SOURCE_DIR}/idl
        DEPENDS ros_std_msgs
        WARNINGS no-implicit-extensibility)
