#
# Copyright(c) 2021 ADLINK Technology Limited and others
#
# This program and the accompanying materials are made available under the
# terms of the Eclipse Public License v. 2.0 which is available at
# http://www.eclipse.org/legal/epl-2.0, or the Eclipse Distribution License
# v. 1.0 which is available at
# http://www.eclipse.org/org/documents/edl-v10.php.
#
# SPDX-License-Identifier: EPL-2.0 OR BSD-3-Clause
#

function(cyclone_idlc_generate)
    set(options NO_TYPE_INFO)
    set(one_value_keywords TARGET MODULE DEFAULT_EXTENSIBILITY)
    set(multi_value_keywords FILES FEATURES INCLUDES DEPENDS WARNINGS)
    cmake_parse_arguments(
            IDLC "${options}" "${one_value_keywords}" "${multi_value_keywords}" "" ${ARGN})

    set(gen_args
            ${IDLC_UNPARSED_ARGUMENTS}
            TARGET ${IDLC_TARGET}
            FILES ${IDLC_FILES}
            MODULE ${IDLC_MODULE}
            FEATURES ${IDLC_FEATURES}
            INCLUDES ${IDLC_INCLUDES}
            DEPENDS ${IDLC_DEPENDS}
            WARNINGS ${IDLC_WARNINGS}
            DEFAULT_EXTENSIBILITY ${IDLC_DEFAULT_EXTENSIBILITY})
    if(${IDLC_NO_TYPE_INFO})
        list(APPEND gen_args NO_TYPE_INFO)
    endif()
    cyclone_idlc_generate_generic(${gen_args})
endfunction()


function(cyclone_idlc_generate_generic)
    set(options NO_TYPE_INFO)
    set(one_value_keywords TARGET MODULE BACKEND DEFAULT_EXTENSIBILITY)
    set(multi_value_keywords FILES FEATURES INCLUDES WARNINGS SUFFIXES DEPENDS)
    cmake_parse_arguments(
            IDLC "${options}" "${one_value_keywords}" "${multi_value_keywords}" "" ${ARGN})

    # find idlc binary
    if(CMAKE_CROSSCOMPILING)
        find_program(_idlc_executable idlc NO_CMAKE_FIND_ROOT_PATH REQUIRED)

        if(_idlc_executable)
            set(_idlc_depends "")
        else()
            message(FATAL_ERROR "Cannot find idlc executable")
        endif()
    else()
        set(_idlc_executable idlc)
#        set(_idlc_depends idlc)
    endif()

    if(NOT IDLC_TARGET AND NOT IDLC_FILES)
        # assume deprecated invocation: TARGET FILE [FILE..]
        list(GET IDLC_UNPARSED_ARGUMENTS 0 IDLC_TARGET)
        list(REMOVE_AT IDLC_UNPARSED_ARGUMENTS 0 IDLC_)
        set(IDLC_FILES ${IDLC_UNPARSED_ARGUMENTS})
        if (IDLC_TARGET AND IDLC_FILES)
            message(WARNING " Deprecated use of idlc_generate. \n"
                    " Consider switching to keyword based invocation.")
        endif()
        # Java based compiler used to be case sensitive
        list(APPEND IDLC_FEATURES "case-sensitive")
    endif()

    if(NOT IDLC_TARGET)
        message(FATAL_ERROR "idlc_generate called without TARGET")
    elseif(NOT IDLC_FILES)
        message(FATAL_ERROR "idlc_generate called without FILES")
    endif()

    # remove duplicate features
    if(IDLC_FEATURES)
        list(REMOVE_DUPLICATES IDLC_FEATURES)
    endif()
    foreach(_feature ${IDLC_FEATURES})
        list(APPEND IDLC_ARGS "-f" ${_feature})
    endforeach()

    # add directories to include search list
    if(IDLC_INCLUDES)
        foreach(_dir ${IDLC_INCLUDES})
            list(APPEND IDLC_INCLUDE_DIRS "-I" ${_dir})
        endforeach()
    endif()

    # generate using which language (defaults to c)?
    if(IDLC_BACKEND)
        string(APPEND _language "-l" ${IDLC_BACKEND})
    endif()

    # set dependencies
    if(IDLC_DEPENDS)
        list(APPEND _depends ${_idlc_depends} ${IDLC_DEPENDS})
    else()
        set(_depends ${_idlc_depends})
    endif()

    if(IDLC_DEFAULT_EXTENSIBILITY)
        set(_default_extensibility ${IDLC_DEFAULT_EXTENSIBILITY})
        list(APPEND IDLC_ARGS "-x" ${_default_extensibility})
    endif()

    if(IDLC_WARNINGS)
        foreach(_warn ${IDLC_WARNINGS})
            list(APPEND IDLC_ARGS "-W${_warn}")
        endforeach()
    endif()

    if(IDLC_NO_TYPE_INFO)
        list(APPEND IDLC_ARGS "-t")
    endif()

    set(_dir ${CMAKE_CURRENT_BINARY_DIR})

    set(_target ${IDLC_TARGET})
    foreach(_file ${IDLC_FILES})
        get_filename_component(_path ${_file} ABSOLUTE)
        list(APPEND _files "${_path}")
    endforeach()

    # generate files from idl
    foreach(_file ${_files})
        get_filename_component(_name ${_file} NAME_WE)
        set(_file_outputs "")
        # message(STATUS "----------> ${_idlc_executable} ${_language} ${IDLC_ARGS} ${IDLC_INCLUDE_DIRS} ${_file}")
        execute_process(COMMAND ${_idlc_executable} ${_language} ${IDLC_ARGS} ${IDLC_INCLUDE_DIRS} ${_file}
                WORKING_DIRECTORY ${_dir}
                RESULT_VARIABLE idlc_result)
        if(NOT idlc_result EQUAL 0)
            message(FATAL_ERROR "cyclone_idlc_generate_c failed")
        endif()
    endforeach()

    # copy generated files to target directory with correct structure
    set(MODULE_TARGET_DIR ${PROJECT_SOURCE_DIR}/src/${IDLC_MODULE})
    file(REMOVE_RECURSE ${MODULE_TARGET_DIR})
    message(STATUS "Generating files to: ${MODULE_TARGET_DIR}")

    file(GLOB generated_headers "${_dir}/*.h")
    file(COPY ${generated_headers} DESTINATION
            ${MODULE_TARGET_DIR}/include/${IDLC_MODULE}/msg)

    file(GLOB generated_source "${_dir}/*.c")
    file(COPY ${generated_source} DESTINATION
            ${MODULE_TARGET_DIR}/src)

    message(STATUS "--> depends: ${_depends}")
    message(STATUS "--> include: ${MODULE_TARGET_DIR}/include/${IDLC_MODULE}/msg")
    message(STATUS "--> depends: ${_target} PUBLIC ${_depends} CycloneDDS::ddsc")

    # build target library
    file(GLOB_RECURSE MODULE_LIB_SRC ${MODULE_TARGET_DIR}/src/*.c)
    add_library(${_target} ${MODULE_LIB_SRC})
    target_link_libraries(${_target} PUBLIC ${_depends} CycloneDDS::ddsc)
    target_include_directories(${_target} PUBLIC
            $<BUILD_INTERFACE:${MODULE_TARGET_DIR}/include>
            $<BUILD_INTERFACE:${MODULE_TARGET_DIR}/include/${IDLC_MODULE}/msg>
            $<INSTALL_INTERFACE:include>)

endfunction()