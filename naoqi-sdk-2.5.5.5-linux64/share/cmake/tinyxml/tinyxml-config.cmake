get_filename_component(_tinyxml_root "${CMAKE_CURRENT_LIST_FILE}" PATH)
set(_tinyxml_root "${_tinyxml_root}/../../..")
get_filename_component(_tinyxml_root "${_tinyxml_root}" ABSOLUTE)

set(
  TINYXML_LIBRARIES
  ${_tinyxml_root}/lib/libtinyxml.so
  CACHE INTERNAL "" FORCE
)

set(
  TINYXML_INCLUDE_DIRS
  ${_tinyxml_root}/include/tinyxml/
  ${_tinyxml_root}/include
  CACHE INTERNAL "" FORCE
)

export_lib(TINYXML)

