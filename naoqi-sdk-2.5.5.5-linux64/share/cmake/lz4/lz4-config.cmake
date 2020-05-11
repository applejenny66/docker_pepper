get_filename_component(_lz4_root "${CMAKE_CURRENT_LIST_FILE}" PATH)
set(_lz4_root "${_lz4_root}/../../..")
get_filename_component(_lz4_root "${_lz4_root}" ABSOLUTE)

set(
  LZ4_LIBRARIES
  ${_lz4_root}/lib/liblz4.so
  CACHE INTERNAL "" FORCE
)

set(
  LZ4_INCLUDE_DIRS
  ${_lz4_root}/include
  CACHE INTERNAL "" FORCE
)

export_lib(LZ4)

