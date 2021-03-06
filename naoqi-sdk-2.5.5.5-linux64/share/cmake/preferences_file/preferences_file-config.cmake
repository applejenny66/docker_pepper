# This is an autogenerated file. Do not edit

get_filename_component(_cur_dir ${CMAKE_CURRENT_LIST_FILE} PATH)
set(_root_dir "${_cur_dir}/../../../")
get_filename_component(ROOT_DIR ${_root_dir} ABSOLUTE)

 
set(PREFERENCES_FILE_INCLUDE_DIRS "${ROOT_DIR}/include;" CACHE STRING "" FORCE)
mark_as_advanced(PREFERENCES_FILE_INCLUDE_DIRS)
   
set(PREFERENCES_FILE_LIBRARIES
  ${ROOT_DIR}/lib/libpreferences_file.so
  CACHE STRING "" FORCE)

mark_as_advanced(PREFERENCES_FILE_LIBRARIES)
 
set(PREFERENCES_FILE_PACKAGE_FOUND TRUE CACHE INTERNAL "" FORCE)
 
set(PREFERENCES_FILE_DEPENDS "TINYXML;ALVALUE;ALERROR;QI;BOOST;BOOST_ATOMIC;BOOST_DATE_TIME;BOOST_CHRONO;BOOST_FILESYSTEM;BOOST_SYSTEM;BOOST_REGEX;BOOST_PROGRAM_OPTIONS;OPENSSL;BOOST_LOCALE;BOOST_THREAD;ICU;PTHREAD;DL;RT" CACHE INTERNAL "" FORCE)
 