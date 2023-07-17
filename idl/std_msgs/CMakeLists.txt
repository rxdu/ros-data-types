message(STATUS "Generating std_msgs module")

file(GLOB_RECURSE MODULE_IDL_FILES msg/*.idl)

cyclone_idlc_generate(TARGET ros_std_msgs
        MODULE std_msgs
        FILES ${MODULE_IDL_FILES}
        INCLUDES ${PROJECT_SOURCE_DIR}/idl
        WARNINGS no-implicit-extensibility)
