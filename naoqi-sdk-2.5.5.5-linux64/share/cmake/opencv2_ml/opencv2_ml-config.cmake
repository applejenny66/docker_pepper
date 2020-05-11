get_filename_component(_opencv2_ml_root "${CMAKE_CURRENT_LIST_FILE}" PATH)
set(_opencv2_ml_root "${_opencv2_ml_root}/../../..")
get_filename_component(_opencv2_ml_root "${_opencv2_ml_root}" ABSOLUTE)

set(OPENCV2_ML_LIBRARIES
  ${_opencv2_ml_root}/lib/libopencv_ml.so
  CACHE INTERNAL "" FORCE
)

set(OPENCV2_ML_INCLUDE_DIRS
  ${_opencv2_ml_root}/include/
  CACHE INTERNAL "" FORCE
)

qi_persistent_set(OPENCV2_ML_DEPENDS OPENCV2_CORE)

export_lib(OPENCV2_ML)
