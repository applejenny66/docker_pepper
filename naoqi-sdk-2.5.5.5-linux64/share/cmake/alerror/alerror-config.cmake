# This is an autogenerated file. Do not edit

get_filename_component(_cur_dir ${CMAKE_CURRENT_LIST_FILE} PATH)
set(_root_dir "${_cur_dir}/../../../")
get_filename_component(ROOT_DIR ${_root_dir} ABSOLUTE)

 
set(ALERROR_INCLUDE_DIRS "${ROOT_DIR}/include;" CACHE STRING "" FORCE)
mark_as_advanced(ALERROR_INCLUDE_DIRS)
   
set(ALERROR_LIBRARIES
  ${ROOT_DIR}/lib/libalerror.so
  CACHE STRING "" FORCE)

mark_as_advanced(ALERROR_LIBRARIES)
 
set(ALERROR_PACKAGE_FOUND TRUE CACHE INTERNAL "" FORCE)
 
set(ALERROR_DEPENDS "QI;BOOST;BOOST_ATOMIC;BOOST_DATE_TIME;BOOST_CHRONO;BOOST_FILESYSTEM;BOOST_SYSTEM;BOOST_REGEX;BOOST_PROGRAM_OPTIONS;OPENSSL;BOOST_LOCALE;BOOST_THREAD;ICU;PTHREAD;DL;RT" CACHE INTERNAL "" FORCE)
 