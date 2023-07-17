message(STATUS "Generating builtin_interfaces module")

file(GLOB_RECURSE MODULE_IDL_FILES msg/*.idl)

cyclone_idlc_generate(TARGET ros_builtin_interfaces
        MODULE builtin_interfaces
        FILES ${MODULE_IDL_FILES}
        INCLUDES ${PROJECT_SOURCE_DIR}/idl
        WARNINGS no-implicit-extensibility)
