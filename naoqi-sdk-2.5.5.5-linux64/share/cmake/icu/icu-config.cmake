get_filename_component(_icu_root "${CMAKE_CURRENT_LIST_FILE}" PATH)
set(_icu_root "${_icu_root}/../../..")
get_filename_component(_icu_root "${_icu_root}" ABSOLUTE)

set(
  ICU_LIBRARIES
  ${_icu_root}/lib/libicudata.so
  ${_icu_root}/lib/libicui18n.so
  ${_icu_root}/lib/libicuio.so
  ${_icu_root}/lib/libicule.so
  ${_icu_root}/lib/libiculx.so
  ${_icu_root}/lib/libicutest.so
  ${_icu_root}/lib/libicutu.so
  ${_icu_root}/lib/libicuuc.so
  CACHE INTERNAL "" FORCE
)

set(
  ICU_INCLUDE_DIRS
  ${_icu_root}/include
  CACHE INTERNAL "" FORCE
)

export_lib(ICU)

