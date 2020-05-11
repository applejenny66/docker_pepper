get_filename_component(_cbridge_root "${CMAKE_CURRENT_LIST_FILE}" PATH)
set(_cbridge_root "${_cbridge_root}/../../..")
get_filename_component(_cbridge_root "${_cbridge_root}" ABSOLUTE)

set(
  CONSOLE_BRIDGE_LIBRARIES
  ${_cbridge_root}/lib/libconsole_bridge.so
  CACHE INTERNAL "" FORCE
)

set(
  CONSOLE_BRIDGE_INCLUDE_DIRS
  ${_cbridge_root}/include
  CACHE INTERNAL "" FORCE
)

qi_persistent_set(CONSOLE_BRIDGE_DEPENDS BOOST)
export_lib(CONSOLE_BRIDGE)
