## Copyright (c) 2012-2015 Aldebaran Robotics. All rights reserved.
## Use of this source code is governed by a BSD-style license that can be
## found in the COPYING file.

# Implementation for qi_stage_lib and qi_stage_header_only_lib
# functions.

include(CMakeParseArguments)
set(QI_SDK_INCLUDE "include")

# Generate CMake code and put the result in res.
# For instance:
#  set(FOO bar)
#  set(SPAM eggs)
#
#  _qi_gen_code_from_vars(res FOO SPAM)
# Causes res to contain:
#
#  set(FOO "bar")
#  mark_as_advanced(FOO)
#  set(SPAM "eggs")
#  mark_as_advanced(SPAM)
function(_qi_gen_code_from_vars res)
  set(_res "")
  foreach(_arg ${ARGN})
    set(_name ${_arg})
    set(_value "${${_arg}}")
    set(_res "${_res}
set(${_name} \"${_value}\" CACHE INTERNAL \"\" FORCE)
")
  endforeach()
  set(${res} ${_res} PARENT_SCOPE)
endfunction()


function(_qi_gen_header_code_redist res)
  # The generated file will be installed in:
  # root_dir/share/cmake/${_target}/${_target}-config.cmake,
  # so we can find root_dir from the location of the generated file...
  set(_header
"# This is an autogenerated file. Do not edit

get_filename_component(_cur_dir \${CMAKE_CURRENT_LIST_FILE} PATH)
set(_root_dir \"\${_cur_dir}/../../../\")
get_filename_component(ROOT_DIR \${_root_dir} ABSOLUTE)

"
  )
  set(_res "${_header}")
  set(${res} ${_res} PARENT_SCOPE)
endfunction()


function(_qi_gen_find_lib_code_redist res target _U_staged_name)
  string(TOUPPER ${target} _U_target)
  if("${${target}_SUBFOLDER}" STREQUAL "")
    set(_subfolder "/")
  else()
    set(_subfolder "${${target}_SUBFOLDER}/")
  endif()
  if(MSVC)
    _get_lib_name(_lib_name_debug ${target} DEBUG)
    _get_lib_name(_lib_name_release ${target} RELEASE)
    set(_res
"
set(${_U_staged_name}_LIBRARIES
  \"debug;\${ROOT_DIR}/lib${_subfolder}${_lib_name_debug};optimized;\${ROOT_DIR}/lib${_subfolder}${_lib_name_release}\"
  CACHE STRING \"\" FORCE)
")
  else()
    _get_lib_name(_lib_name ${target})
    set(_res
"
set(${_U_staged_name}_LIBRARIES
  \${ROOT_DIR}/lib${_subfolder}${_lib_name}
  CACHE STRING \"\" FORCE)
")
  endif()

  set(_res "${_res}
mark_as_advanced(${_U_staged_name}_LIBRARIES)
")
  set(${res} ${_res} PARENT_SCOPE)
endfunction()

# _get_lib_name(res foo) :
# res = libfoo.so
function(_get_lib_name res target)
  set(_build_type "${ARGN}")
  get_target_property(_lib_output_name ${target}  OUTPUT_NAME)
  if (NOT _lib_output_name)
    set(_lib_output_name ${target})
  endif()
  if(WIN32)
    if(MSVC)
      set(_lib_name_debug   "${_lib_output_name}_d.lib")
      set(_lib_name_release "${_lib_output_name}.lib")
      if("${_build_type}" STREQUAL "DEBUG")
        set(${res} ${_lib_name_debug} PARENT_SCOPE)
      else()
        set(${res} ${_lib_name_release} PARENT_SCOPE)
      endif()
    else()
      # MinGW
      if("${_target_type}" STREQUAL SHARED_LIBRARY)
        set(_lib_name    "lib${_lib_output_name}.dll.a")
      else()
        set(_lib_name    "lib${_lib_output_name}.a")
      endif()
      set(${res} ${_lib_name} PARENT_SCOPE)
    endif()
  else()
    # Not win32:
    if("${_target_type}" STREQUAL "SHARED_LIBRARY")
      if(APPLE)
        set(_lib_name "lib${_lib_output_name}.dylib")
      else()
        set(_lib_name "lib${_lib_output_name}.so")
      endif()
    else()
      set(_lib_name "lib${_lib_output_name}.a")
    endif()
    set(${res} ${_lib_name} PARENT_SCOPE)
  endif()
endfunction()


function(_qi_gen_find_lib_code_sdk res target _U_staged_name)
  string(TOUPPER ${target} _U_target)
  get_target_property(_target_type  ${target}   TYPE)
  get_target_property(_lib_output_name ${target}  OUTPUT_NAME)
  if (NOT _lib_output_name)
    set(_lib_output_name ${target})
  endif()

  if(WIN32)
    if(MSVC)
      get_target_property(_lib_dir_debug   ${target}  ARCHIVE_OUTPUT_DIRECTORY_DEBUG)
      get_target_property(_lib_dir_release ${target}  ARCHIVE_OUTPUT_DIRECTORY_RELEASE)
      _get_lib_name(_lib_name_debug ${target} DEBUG)
      _get_lib_name(_lib_name_release ${target} RELEASE)
      set(_lib_debug "${_lib_dir_debug}/${_lib_name_debug}")
      set(_lib_release "${_lib_dir_release}/${_lib_name_release}")
      set(${_U_staged_name}_LIBRARIES "debug;${_lib_debug};optimized;${_lib_release}")
    else()
      # Mingw: lib is .a when building a static library, and
      # .dll.a when building a shared library
      get_target_property(_lib_dir ${target} "ARCHIVE_OUTPUT_DIRECTORY")
      _get_lib_name(_lib_name ${target})
      set(${_U_staged_name}_LIBRARIES "general;${_lib_dir}/${_lib_name}")
    endif()
  else()
    # Not win32:
    _get_lib_name(_lib_name ${target})
    if("${_target_type}" STREQUAL "SHARED_LIBRARY")
      get_target_property(_lib_dir  ${target}  "LIBRARY_OUTPUT_DIRECTORY")
    else()
      get_target_property(_lib_dir  ${target}  "ARCHIVE_OUTPUT_DIRECTORY")
    endif()
    set(${_U_staged_name}_LIBRARIES "general;${_lib_dir}/${_lib_name}")
  endif()

  _qi_gen_code_from_vars(_res ${_U_staged_name}_LIBRARIES)
  set(${res} ${_res} PARENT_SCOPE)
endfunction()


# Here we have a list of relative paths, we want
# to write a variable with these paths prepend with
# ${ROOT_DIR}/include, the root include dir of the
# installed SDK.
function(_qi_gen_inc_dir_code_redist res target _U_staged_name)
  string(TOUPPER ${target} _U_target)

  set(_suffixes)
  foreach(_suffix ${${_U_target}_PATH_SUFFIXES})
    list(APPEND _suffixes "\${ROOT_DIR}/include/${_suffix}")
  endforeach()

  set(_res "
set(${_U_staged_name}_INCLUDE_DIRS \"\${ROOT_DIR}/include;${_suffixes}\" CACHE STRING \"\" FORCE)
mark_as_advanced(${_U_target}_INCLUDE_DIRS)
  "
  )

  set(${res} ${_res} PARENT_SCOPE)
endfunction()


# Here we have a list of relative paths, we want to write
# the absolute paths in CMAKE_BINARY_DIR/sdk/cmake/target-config.cmake
function(_qi_gen_inc_dir_code_sdk res target _U_staged_name)
  string(TOUPPER ${target} _U_target)
  get_directory_property(_inc_dirs INCLUDE_DIRECTORIES)
  list(APPEND ${_U_staged_name}_INCLUDE_DIRS ${_inc_dirs})
  _qi_gen_code_from_vars(_res ${_U_staged_name}_INCLUDE_DIRS)
  set(${res} ${_res} PARENT_SCOPE)
endfunction()


# Generate CMake code to be put in a
# ${target}-config.cmake, ready to be installed
function(_qi_gen_code_lib_redist res target _U_staged_name)
  string(TOUPPER ${target} _U_target)
  set(_res "")

  # Header:
  _qi_gen_header_code_redist(_header)
  set(_res ${_header})

  # Include dirs:
  _qi_gen_inc_dir_code_redist(_inc ${target} ${_U_staged_name})
  set(_res "${_res} ${_inc}")

  # Find libs:
  _qi_gen_find_lib_code_redist(_find_libs ${target} ${_U_staged_name})
  set(_res "${_res} ${_find_libs}")

  set(_set_package_found
"
set(${_U_staged_name}_PACKAGE_FOUND TRUE CACHE INTERNAL \"\" FORCE)
")
  set(_res "${_res} ${_set_package_found}")

  # _DEPENDS:
  set(${_U_staged_name}_DEPENDS   ${${_U_staged_name}_DEPENDS})
  _qi_gen_code_from_vars(_vars
    ${_U_staged_name}_DEPENDS
  )

  set(_res "${_res} ${_vars}")

  set(${res} ${_res} PARENT_SCOPE)
endfunction()

# Generate CMake code to be put in a
# ${target}-config.cmake, ready to be installed
function(_qi_gen_code_header_only_lib_redist res target _U_staged_name)
  string(TOUPPER ${target} _U_target)
  set(_res "")

  # Header:
  _qi_gen_header_code_redist(_header)
  set(_res ${_header})

  # INCLUDE_DIRS:
  _qi_gen_inc_dir_code_redist(_inc ${target} ${_U_staged_name})
  set(_res "${_res} ${_inc}")

  # FindPackageHandleStandardArgs:
  set(_call_fphsa
"
include(FindPackageHandleStandardArgs)
FIND_PACKAGE_HANDLE_STANDARD_ARGS(${_U_staged_name} DEFAULT_MSG
  ${_U_staged_name}_INCLUDE_DIRS
)
set(${_U_staged_name}_PACKAGE_FOUND \${${_U_staged_name}_FOUND} CACHE INTERNAL \"\" FORCE)
")
  set(_res "${_res} ${_call_fphsa}")

  # _DEPENDS:
  set(${_U_staged_name}_DEPENDS   ${${_U_staged_name}_DEPENDS})
  _qi_gen_code_from_vars(_vars
    ${_U_staged_name}_DEPENDS
  )

  set(_res "${_res} ${_vars}")
  set(${res} ${_res} PARENT_SCOPE)
endfunction()



# Generate CMake code to be put in a
# ${target}-config.cmake, ready to be included
# by other projects from the build dir
function(_qi_gen_code_lib_sdk res target _U_staged_name)
  string(TOUPPER ${target} _U_target)
  set(_res
  "# Autogenerated file.
# Do not edit.
# Do not change location.
")
  _qi_gen_inc_dir_code_sdk(_inc ${target} ${_U_staged_name})
  set(_res "${_res} ${_inc}")

  _qi_gen_find_lib_code_sdk(_lib ${target} ${_U_staged_name})
  set(_res "${_res} ${_lib}")

  set(${_U_staged_name}_TARGET ${target})
  set(${_U_staged_name}_PACKAGE_FOUND TRUE)
  set(${_U_staged_name}_DEPENDS   ${${_U_target}_DEPENDS})

  _qi_gen_code_from_vars(_vars
    ${_U_staged_name}_TARGET
    ${_U_staged_name}_PACKAGE_FOUND
    ${_U_staged_name}_DEPENDS
  )

  set(_res "${_res} ${_vars}")
  set(${res} ${_res} PARENT_SCOPE)
endfunction()

# Generate CMake code to be put in a
# ${target}-config.cmake, ready to be included
# by other projects from the build dir
function(_qi_gen_code_header_only_lib_sdk res target _U_staged_name)
  string(TOUPPER ${target} _U_target)
  set(_res
  "# Autogenerated file.
# Do not edit.
# Do not change location.
")
  _qi_gen_inc_dir_code_sdk(_inc ${target} ${_U_staged_name})
  set(_res "${_res} ${_inc}")

  set(_res "${_res}
set(${_U_staged_name}_PACKAGE_FOUND TRUE CACHE INTERNAL \"\" FORCE)
  ")

  set(${_U_staged_name}_DEPENDS   ${${_U_target}_DEPENDS})
  _qi_gen_code_from_vars(_vars
    ${_U_staged_name}_DEPENDS
  )

  set(_res "${_res} ${_vars}")
  set(${res} ${_res} PARENT_SCOPE)
endfunction()



# Usage:
# _qi_set_vars target
#
# accepted group of flags:
#  DEPENDS
#  INCLUDE_DIRS
#  PATH_SUFFIXES
# (those will be guessed if not given:
# target_DEPENDS <- filled by qi_use_lib
# target_INCLUDE_DIRS <- using get_directory_properties()
function(_qi_set_vars target)
  string(TOUPPER ${target} _U_target)
  cmake_parse_arguments(ARG ""
    ""
    "DEPENDS;INCLUDE_DIRS;PATH_SUFFIXES"
    ${ARGN})
  if(ARG_DEPENDS)
    set(${_U_target}_DEPENDS ${ARG_DEPENDS} PARENT_SCOPE)
  endif()

  if(ARG_INCLUDE_DIRS)
    set(${_U_target}_INCLUDE_DIRS ${ARG_INCLUDE_DIRS} PARENT_SCOPE)
  else()
    # ARG_INCLUDE_DIRS defaults to ${CMAKE_CURRENT_SOURCE_DIR}
    set(${_U_target}_INCLUDE_DIRS ${CMAKE_CURRENT_SOURCE_DIR} PARENT_SCOPE)
  endif()

  if(ARG_PATH_SUFFIXES)
    set(${_U_target}_PATH_SUFFIXES ${ARG_PATH_SUFFIXES} PARENT_SCOPE)
  else()
    set(${_U_target}_PATH_SUFFIXES "" PARENT_SCOPE)
  endif()


endfunction()

##
# Add a message at the end of the generated cmake file
# telling the use the target is deprecated.
# Last argument is the message about the replacement.
#   (usually something like: 'please use ... instead')
function(_qi_gen_deprecated_message res target deprecrated_message)
  string(TOUPPER ${target} _U_target)
  set(_res "
if(NOT ${_U_target}_I_KNOW_IT_IS_DEPRECATED AND QI_WARN_DEPRECATED)
  message(STATUS \"
    \${CMAKE_CURRENT_SOURCE_DIR}: ${target} is deprecated
    ${deprecrated_message}
  \"
  )
  set(${_U_target}_I_KNOW_IT_IS_DEPRECATED ON)
endif()
")
  set(${res} ${_res} PARENT_SCOPE)
endfunction()



##
# Create install rules for the redist file of a target.
# By default, the redist file will be installed.
# If the target has been created by qi_create_lib(.. INTERNAL),
# ${_U_target}_INTERNAL will be TRUE, and the redist file
# should NOT be installed.
# But, if the global flag QI_INSTALL_INTERNAL is ON,
# the redist file must be installed anyway. (Thus you can
# make pre-compiled packages containing the internal libraries)
function(_qi_install_redist_file redist_file target _l_staged_name)
  string(TOUPPER ${target} _U_target)
  string(TOLOWER ${target} _l_target)
  set(_should_install TRUE)

  # if target has been created with qi_create_lib(... INTERNAL), ${target}_INTERNAL
  # will be and we should not install the redist file:
  if(${${target}_INTERNAL})
    qi_verbose("Not creating redist file for ${target} because it is internal")
    set(_should_install FALSE)
  endif()

  # but we can by-pass this with QI_INSTALL_INTERNAL (useful to create internal
  # pre-compiled packages, for instance)
  if(${QI_INSTALL_INTERNAL})
    qi_verbose("QI_INSTALL_INTERNAL set:
      Creating redist file for internal target: ${target} anyway")
    set(_should_install TRUE)
  endif()

  if(${_should_install})
    qi_install_cmake(${_redist_file} SUBFOLDER ${_l_staged_name})
  endif()

endfunction()

##
# Implementation of qi_stage_lib()
#
# We have to generate to {target}-config.cmake file:
#   - the redist file, which will be installed, and contains only relative paths
#   - the sdk  file,   which will NOT be installed, and contains only absolute paths.
# Those files are generated using the various _qi_gen_code_* functions.
# We also need to create the installation rules for the redist file.
# Last, but not least, we need to handle several cases:
#  - The target has been staged with a name which is NOT the target name
#      (required for t001chain backward compatibility)
#  - The library has been marked as deprecated, because a new library is meant
#       to replace it
#  - The library is internal, so the redist file should not be installed by default
function(_qi_internal_stage_lib target)
  cmake_parse_arguments(ARG
    "INTERNAL"
    "STAGED_NAME"
    "DEPRECATED;INCLUDE_DIRS;PATH_SUFFIXES;DEPENDS;CUSTOM_CODE"
    ${ARGN})


  # dm: temp warning:
  if (${ARG_INTERNAL})
    qi_warning("Using qi_stage_lib(.. INTERNAL ..) is deprecated
Please use

qi_create_lib(foo INTERNAL) instead
")
  endif()

  string(TOUPPER ${target} _U_target)
  string(TOLOWER ${target} _l_target)
  if(ARG_STAGED_NAME)
    string(TOLOWER "${ARG_STAGED_NAME}" _l_staged_name)
    string(TOUPPER "${ARG_STAGED_NAME}" _U_staged_name)
  else()
    set(_l_staged_name ${_l_target})
    set(_U_staged_name ${_U_target})
  endif()

  set(_new_args)
  foreach(_arg INCLUDE_DIRS PATH_SUFFIXES DEPENDS)
    if (DEFINED ARG_${_arg})
      list(APPEND _new_args "${_arg}" "${ARG_${_arg}}")
    endif()
  endforeach()

  _qi_set_vars(${target} ${_new_args})

  set(_additional_code) # code that will be added at the end of the generated files
  if(ARG_DEPRECATED)
      _qi_gen_deprecated_message(_additional_code ${target} ${ARG_DEPRECATED})
  endif()

  set(_module_name "${_l_staged_name}-config.cmake")
  if(${${target}_NO_INSTALL})
    qi_debug("Skipping creation of redist config file for ${target}")
  else()
    _qi_gen_code_lib_redist(_redist_code ${target} ${_U_staged_name})
    set(_redist_file "${CMAKE_BINARY_DIR}/${QI_SDK_CMAKE_MODULES}/sdk/${_module_name}")
    set(_redist_code "${_redist_code} ${_additional_code}")
    if (ARG_CUSTOM_CODE)
      set(_redist_code "${_redist_code} \n${ARG_CUSTOM_CODE}\n")
    endif()
    file(WRITE "${_redist_file}" "${_redist_code}")
    _qi_install_redist_file("${_redist_file}" "${target}" "${_l_staged_name}")
  endif()

  _qi_gen_code_lib_sdk(_sdk_code ${target} ${_U_staged_name})
  set(_sdk_file "${QI_SDK_DIR}/${QI_SDK_CMAKE_MODULES}/${_module_name}")
  set(_sdk_code "${_sdk_code} ${_additional_code}")
  if (ARG_CUSTOM_CODE)
    set(_sdk_code "${_sdk_code} \n${ARG_CUSTOM_CODE}\n")
  endif()
  file(WRITE "${_sdk_file}" "${_sdk_code}")

endfunction()



##
# Implements qi_stage_header_only_lib
#
function(_qi_internal_stage_header_only_lib target)
  cmake_parse_arguments(ARG "INTERNAL" "" "DEPRECATED;INCLUDE_DIRS;PATH_SUFFIXES;DEPENDS" ${ARGN})
  # dm: temp warning:
  if (${ARG_INTERNAL})
    qi_warning("Using qi_stage_header_only_lib(.. INTERNAL ..) is deprecated

    What were you trying to do anyway?
")
  endif()

  string(TOUPPER ${target} _U_target)
  string(TOLOWER ${target} _l_target)
  if(ARG_STAGED_NAME)
    string(TOLOWER "${ARG_STAGED_NAME}" _l_staged_name)
    string(TOUPPER "${ARG_STAGED_NAME}" _U_staged_name)
  else()
    set(_l_staged_name ${_l_target})
    set(_U_staged_name ${_U_target})
  endif()

  set(_new_args)
  foreach(_arg INCLUDE_DIRS PATH_SUFFIXES DEPENDS)
    if (DEFINED ARG_${_arg})
      list(APPEND _new_args "${_arg}" "${ARG_${_arg}}")
    endif()
  endforeach()

  _qi_set_vars(${target} ${_new_args})

  set(_additional_code)
  if (ARG_DEPRECATED)
    _qi_gen_deprecated_message(_additional_code ${target} ${ARG_DEPRECATED})
  endif()

  _qi_gen_code_header_only_lib_redist(_redist_code ${target} ${_U_staged_name})
  set(_redist_file "${CMAKE_BINARY_DIR}/${QI_SDK_CMAKE_MODULES}/sdk/${_l_target}-config.cmake")
  set(_redist_code "${_redist_code} ${_additional_code}")
  file(WRITE "${_redist_file}" "${_redist_code}")
  _qi_install_redist_file(${_redist_file} ${target} ${_l_staged_name})

  _qi_gen_code_header_only_lib_sdk(_sdk_code ${target} ${_U_staged_name})
  set(_sdk_file "${QI_SDK_DIR}/${QI_SDK_CMAKE_MODULES}/${_l_target}-config.cmake")
  set(_sdk_code "${_sdk_code} ${_additional_code}")
  file(WRITE "${_sdk_file}" "${_sdk_code}")

endfunction()


#
# Implements qi_stage_script
#
function(_qi_internal_stage_script script_path target_path)
  get_filename_component(target ${script_path} NAME)
  string(TOUPPER ${target} _U_target)
  string(TOLOWER ${target} _l_target)
  string(TOUPPER ${CMAKE_BUILD_TYPE} _U_build_type)

  set(${_U_target}_EXECUTABLE ${target_path})
  set(_res
  "# Autogenerated file.
# Do not edit.
# Do not change location.
")
  _qi_gen_code_from_vars(_vars ${_U_target}_EXECUTABLE)
  set(_res "${_res} ${_vars}")
  set(_sdk_file "${QI_SDK_DIR}/${QI_SDK_CMAKE_MODULES}/${_l_target}-config.cmake")
  file(WRITE "${_sdk_file}" "${_res}")
  _qi_install_redist_file("${_sdk_file}" "${target}" "${_l_target}")
endfunction()

#
# Implements qi_stage_bin
#
function(_qi_internal_stage_bin target)
  string(TOUPPER ${target} _U_target)
  string(TOLOWER ${target} _l_target)
  string(TOUPPER ${CMAKE_BUILD_TYPE} _U_build_type)
  if(WIN32)
    get_target_property(_runtime_out ${target} RUNTIME_OUTPUT_DIRECTORY_${_U_build_type})
  else()
    get_target_property(_runtime_out ${target} RUNTIME_OUTPUT_DIRECTORY)
  endif()
  if(WIN32)
    if("${CMAKE_BUILD_TYPE}" STREQUAL "Debug")
      set(_executable_name "${target}_d.exe")
    else()
      set(_executable_name "${target}.exe")
    endif()
  else()
    set(_executable_name "${target}")
  endif()

  set(${_U_target}_EXECUTABLE ${_runtime_out}/${_executable_name})
  set(_res
  "# Autogenerated file.
# Do not edit.
# Do not change location.
")
  _qi_gen_code_from_vars(_vars ${_U_target}_EXECUTABLE)
  set(_res "${_res} ${_vars}")
  set(_sdk_file "${QI_SDK_DIR}/${QI_SDK_CMAKE_MODULES}/${_l_target}-config.cmake")
  file(WRITE "${_sdk_file}" "${_res}")

  set(_redist_file "${CMAKE_BINARY_DIR}/${QI_SDK_CMAKE_MODULES}/sdk/${_l_target}-config.cmake")
  file(WRITE ${_redist_file} "
find_program(${_U_target}_EXECUTABLE ${target})
")
  _qi_install_redist_file(${_redist_file} ${target} ${_l_target})
endfunction()

#
# Use install_name_tool to set rpath on target \p name
#
function(_qi_set_apple_rpath name subfolder)
# We need to set a rpath into libraries in addition to binaries, in case they are the
    # starting point of loading chain: for instance an unrelated binary performing
    # a dlopen.
    set(_dotdot "")
    if(subfolder)
      # Get path from subfolder to lib
      file(RELATIVE_PATH _dotdot "/${subfolder}" /)
    endif()
    find_program(install_name_tool install_name_tool)
    # INSTALL_RPATH has no effect, although the linker supports -rpath.
    # So create a post-processing target
    # Add an extra ../ to dotdot to go from lib to root dir
    add_custom_command(TARGET "${name}" POST_BUILD
      COMMAND ${install_name_tool} -add_rpath "@loader_path/../${_dotdot}" $<TARGET_FILE:${name}>
    )
endfunction()