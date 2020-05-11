get_filename_component(_opencv2_ocl_root "${CMAKE_CURRENT_LIST_FILE}" PATH)
set(_opencv2_ocl_root "${_opencv2_ocl_root}/../../..")
get_filename_component(_opencv2_ocl_root "${_opencv2_ocl_root}" ABSOLUTE)

set(OPENCV2_OCL_LIBRARIES
  ${_opencv2_ocl_root}/lib/libopencv_ocl.so
  ${_opencv2_ocl_root}/lib/libopencv_ocl.so.2.4
  CACHE INTERNAL "" FORCE
)

set(OPENCV2_OCL_INCLUDE_DIRS
  ${_opencv2_ocl_root}/include/
  CACHE INTERNAL "" FORCE
)

qi_persistent_set(OPENCV2_OCL_DEPENDS OPENCV2_ML OPENCV2_IMGPROC OPENCV2_CORE OPENCV2_OBJDETECT ZLIB PNG OPENCV2_HIGHGUI)
export_lib(OPENCV2_OCL)
