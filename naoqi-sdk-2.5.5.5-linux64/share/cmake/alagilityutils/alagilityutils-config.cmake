# This is an autogenerated file. Do not edit

get_filename_component(_cur_dir ${CMAKE_CURRENT_LIST_FILE} PATH)
set(_root_dir "${_cur_dir}/../../../")
get_filename_component(ROOT_DIR ${_root_dir} ABSOLUTE)

 
set(ALAGILITYUTILS_INCLUDE_DIRS "${ROOT_DIR}/include;" CACHE STRING "" FORCE)
mark_as_advanced(ALAGILITYUTILS_INCLUDE_DIRS)
   
set(ALAGILITYUTILS_LIBRARIES
  ${ROOT_DIR}/lib/libalagilityutils.a
  CACHE STRING "" FORCE)

mark_as_advanced(ALAGILITYUTILS_LIBRARIES)
 
set(ALAGILITYUTILS_PACKAGE_FOUND TRUE CACHE INTERNAL "" FORCE)
 
set(ALAGILITYUTILS_DEPENDS "ALMATHINTERNAL;ALMATH;EIGEN3;QI;BOOST;BOOST_ATOMIC;BOOST_DATE_TIME;BOOST_CHRONO;BOOST_FILESYSTEM;BOOST_SYSTEM;BOOST_REGEX;BOOST_PROGRAM_OPTIONS;OPENSSL;BOOST_LOCALE;BOOST_THREAD;ICU;PTHREAD;DL;RT;BFL" CACHE INTERNAL "" FORCE)
 