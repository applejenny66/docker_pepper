set(_root "${CMAKE_CURRENT_LIST_DIR}/../../..")
get_filename_component(_root ${_root} ABSOLUTE)

set(BFL_LIBRARIES
  ${_root}/lib/liborocos-bfl.so
  CACHE INTERNAL "" FORCE
)

set(BFL_INCLUDE_DIRS
  ${_root}/include
  CACHE INTERNAL "" FORCE
)

# qi_persistent_set(BFL_DEPENDS "")
export_lib(BFL)
