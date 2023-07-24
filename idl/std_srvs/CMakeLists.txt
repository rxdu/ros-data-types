message(STATUS "Generating std_srvs module")

file(GLOB_RECURSE MODULE_IDL_FILES srv/*.idl)

cyclone_idlc_generate(TARGET ros_std_srvs
        MODULE std_srvs
        FILES ${MODULE_IDL_FILES}
        INCLUDES ${PROJECT_SOURCE_DIR}/idl
        # DEPENDS ros_builtin_interfaces
        WARNINGS no-implicit-extensibility)
