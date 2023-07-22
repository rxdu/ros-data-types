message(STATUS "Generating std_msgs module")

file(GLOB_RECURSE MODULE_IDL_FILES msg/*.idl)

cyclone_idlc_generate(TARGET ros_std_msgs
        MODULE std_msgs
        FILES ${MODULE_IDL_FILES}
        INCLUDES ${PROJECT_SOURCE_DIR}/idl
        DEPENDS ros_builtin_interfaces
        WARNINGS no-implicit-extensibility)
