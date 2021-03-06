# This is an autogenerated file. Do not edit

get_filename_component(_cur_dir ${CMAKE_CURRENT_LIST_FILE} PATH)
set(_root_dir "${_cur_dir}/../../../")
get_filename_component(ROOT_DIR ${_root_dir} ABSOLUTE)

 
set(BREAKPAD_INCLUDE_DIRS "${ROOT_DIR}/include;" CACHE STRING "" FORCE)
mark_as_advanced(BREAKPAD_INCLUDE_DIRS)
   
set(BREAKPAD_LIBRARIES
  ${ROOT_DIR}/lib/libbreakpad.a
  CACHE STRING "" FORCE)

mark_as_advanced(BREAKPAD_LIBRARIES)
 
set(BREAKPAD_PACKAGE_FOUND TRUE CACHE INTERNAL "" FORCE)
 
set(BREAKPAD_DEPENDS "PTHREAD" CACHE INTERNAL "" FORCE)
 