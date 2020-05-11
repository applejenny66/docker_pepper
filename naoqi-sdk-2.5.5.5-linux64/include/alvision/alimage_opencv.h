/**
 * @author Vincent Rabaud, Guillaume Jacob
 * Aldebaran Robotics (c) 2013, 2014 All Rights Reserved
 */

/** Set of functions to
 * - convert between ALImage and cv::Mat
 * - load/write ALImage with OpenCV.
 *
 * This is a header only implementation to be totally independent from OpenCV
 * If you include this header, make sure you link properly to OPENCV2_CORE and
 *  OPENCV2_HIGHGUI.
 */
#ifndef LIBALVISION_ALVISION_ALIMAGE_OPENCV_H_
#define LIBALVISION_ALVISION_ALIMAGE_OPENCV_H_

#include <cstring> // for std::memcpy
#include <opencv2/core/core.hpp>
#include <opencv2/highgui/highgui.hpp>

#include <alerror/alerror.h>

#include "alimage.h"
#include "alvisiondefinitions.h"

namespace AL
{
/** Converts an ALImage to an OpenCV cv::Mat by NOT copying the data over: the cv::Mat does not own the data and will
 * not delete it in its destructor. If you want to copy the data, just .clone the output cv::Mat()
 * @param al_image
 * @param cv_type if provided, it interprets the content of al_image as such
 * @return
 */
static inline cv::Mat aLImageToCvMat(const AL::ALImage & al_image, int cv_type = -1)
{
  // OpenCV does not take a const void* because the object could be modified later. This pointer will only be used
  // in a tmp local cv::Mat so it's fine
  unsigned char *data = const_cast<unsigned char*>(al_image.getData());

  if (cv_type >= 0)
    return cv::Mat(al_image.getHeight(), al_image.getWidth(), cv_type, data);

  // Check the types
  int n_layers = AL::getNumLayersInColorSpace(al_image.getColorSpace());
  int n_channels = AL::getNumChannelsInColorSpace(al_image.getColorSpace());
  if ((n_layers < 0) || (n_channels < 0)) {
    std::stringstream ss;
    ss << "Color space \"" << al_image.getColorSpace() << "\" not supported";
    throw AL::ALError("ALVision", "aLImageToCvMat", ss.str());
  }
  int cv_depth;
  switch (n_layers / n_channels)
  {
  case 4:
    cv_depth = CV_32F;
    break;
  case 2:
    cv_depth = CV_16U;
    break;
  case 1:
    cv_depth = CV_8U;
    break;
  default:
    std::stringstream ss;
    ss << "Depth \"" << (n_layers / n_channels) << "\" not supported";
    throw AL::ALError("ALVision", "aLImageToCvMat", ss.str());
  }

  return cv::Mat(al_image.getHeight(), al_image.getWidth(),
  CV_MAKETYPE(cv_depth, n_channels), data);
}

/** Converts an OpenCV cv::Mat to an ALImage by NOT copying the data over. Be careful, if your cv::Mat goes out of
 * scope, the ALImage pointer is invalid
 * @param img the cv::Mat image the output image will link to
 * @param colorSpace the color space as defined in ALVision
 * @return
 */
static inline AL::ALImage* cvMatToALImage(const cv::Mat & img, int colorSpace,
                                          float pLeftAngle  = 0.0f, float pTopAngle    = 0.0f,
                                          float pRightAngle = 0.0f, float pBottomAngle = 0.0f)
{
  // Check the number of channels
    if (AL::getNumChannelsInColorSpace(colorSpace) != img.channels())
      throw AL::ALError("ALVision", "cvMatToALImage",
          "Channel number incompatibility between cv::Mat and colorSpace");

  // Check the type
    switch (img.depth())
    {
    case CV_8U:
    case CV_16U:
    case CV_32F:
      break;
    default:
      throw AL::ALError("ALVision", "cvMatToALImage",
          "Type incompatibility between cv::Mat and colorSpace");
    }

  // Create an ALImage with the buffer
  AL::ALImage *al_image = new AL::ALImage(img.cols, img.rows, colorSpace, true,
                                          pLeftAngle, pTopAngle, pRightAngle, pBottomAngle);
  al_image->setData(img.data);

  return al_image;
}

/** Converts an OpenCV cv::Mat to an ALImage by COPYING the data over
 * @param img the cv::Mat image the output image will copy
 * @param colorSpace the color space as defined in ALVision
 * @return
 */
static inline AL::ALImage* cvMatToALImageCopy(const cv::Mat & img,
    int colorSpace,
    float pLeftAngle  = 0.0f, float pTopAngle    = 0.0f,
    float pRightAngle = 0.0f, float pBottomAngle = 0.0f)
{
  // Check the number of channels
    if (AL::getNumChannelsInColorSpace(colorSpace) != img.channels())
      throw AL::ALError("ALVision", "cvMatToALImage",
          "Channel number incompatibility between cv::Mat and colorSpace");

  // Check the type
    switch (img.type())
    {
    case CV_8U:
    case CV_16U:
    case CV_32F:
      break;
    default:
      throw AL::ALError("ALVision", "cvMatToALImage",
          "Type incompatibility between cv::Mat and colorSpace");
    }

  // Copy the image data in a buffer
  size_t data_size = img.cols * img.rows * img.elemSize();
  unsigned char *data = new unsigned char[data_size];
  std::memcpy(data, img.data, data_size);

  // Create an ALImage with the buffer
  AL::ALImage *al_image = new AL::ALImage(img.cols, img.rows, colorSpace, false,
                                          pLeftAngle, pTopAngle, pRightAngle, pBottomAngle);
  al_image->setData(data);

  return al_image;
}

/** Saves an ALImage to a file using OpenCV. Allows compression depending on the
 * format chosen.
 * @param path Path and file name of the saved image. The metadata will be saved
 *        in a separate file.
 * @param al_image
 * @return true if the operation succeeded
 * @throw ALError image file cannot be opened for writing
 */
static inline bool writeALImageToFile(const std::string& path, const ALImage& al_image)
{
  if(!cv::imwrite(path, aLImageToCvMat(al_image)))
  {
    throw AL::ALError("ALVision", "writeALImageToFile",
                      "Can't write image to "+path);
  }

  const std::string path_data = path+".yml";
  cv::FileStorage fs(path_data, cv::FileStorage::WRITE);
  if(!fs.isOpened())
  {
    throw AL::ALError("ALVision", "writeALImageToFile",
                      "Can't open "+path_data+" to write metadata");
  }
  try {
    fs << "width"      << al_image.getWidth();
    fs << "height"     << al_image.getHeight();
//    fs << "nb_layers"  << al_image.getNbLayers(); // unused
    fs << "colorspace" << al_image.getColorSpace();
    long long timestamp = al_image.getTimeStamp();
    fs << "timestamp_s"  << static_cast<int>(timestamp/1000000ll);
    fs << "timestamp_us"  << static_cast<int>(timestamp%1000000ll);
    fs << "camera_id"  << static_cast<int>(al_image.getCameraId());
    fs << "fov_left"   << al_image.getLeftAngle();
    fs << "fov_top"    << al_image.getTopAngle();
    fs << "fov_right"  << al_image.getRightAngle();
    fs << "fov_bottom" << al_image.getBottomAngle();
    fs << "roi_enabled" << al_image.isROIEnabled();
    fs << "rois" << "[";
    for(int i = 0; i < al_image.getNumOfROIs(); ++i)
    {
      const ALImage::ROI* roi = al_image.getROI(i);
      fs << "{"
         << "x" << roi->x
         << "y" << roi->y
         << "width" << roi->w
         << "height" << roi->h
         << "leftAngle" << roi->leftAngle
         << "topAngle" << roi->topAngle
         << "rightAngle" << roi->rightAngle
         << "bottomAngle" << roi->bottomAngle
         << "}";
    }
    fs << "]";
    fs.release();
  } catch(const cv::Exception& e)
  {
    throw AL::ALError("ALVision", "writeALImageToFile",
                      "Exception caught when writing metadata to "+path_data+": "+e.what());
  }

  return true;
}

/** Loads an ALImage from an image file using OpenCV.
 * @param path Path and file name
 * @param pColorspace If no metadata file is found and pColorspace is provided,
 *        its value will be used to build the ALImage.
 * @return ALImage read from the image and metadata files.
 * @throw ALError metadata file cannot be opened or metadata and image do not match.
 */
static inline ALImage readALImageFromFile(const std::string& path, int pColorspace = -1)
{
  const cv::Mat img = cv::imread(path, cv::IMREAD_ANYCOLOR);

  const std::string path_data = path+".yml";
  cv::FileStorage fs(path_data, cv::FileStorage::READ);

  if(!fs.isOpened())
  {
    if(pColorspace == -1)
    {
      throw AL::ALError("ALVision", "readALImageFromFile",
                        "Can't open "+path_data+" to read metadata");
    }
    else
    {
      ALImage al_image(img.cols, img.rows, pColorspace, false);
      unsigned char* data = al_image.getData();
      const size_t data_size = img.cols * img.rows * img.elemSize();
      std::memcpy(data, img.data, data_size);
      return al_image;
    }
  }

  int width, height, /*nb_layers, */colorspace, timestamp_s, timestamp_us, camera_id;
  float fov_left, fov_top, fov_right, fov_bottom;
  bool roi_enabled;
  std::vector<ALImage::ROI> rois;
  try {
    fs["width"]        >> width;
    fs["height"]       >> height;
//    fs["nb_layers"]  >> nb_layers; // unused
    fs["colorspace"]   >> colorspace;
    fs["timestamp_s"]  >> timestamp_s;
    fs["timestamp_us"] >> timestamp_us;
    fs["camera_id"]    >> camera_id;
    fs["fov_left"]     >> fov_left;
    fs["fov_top"]      >> fov_top;
    fs["fov_right"]    >> fov_right;
    fs["fov_bottom"]   >> fov_bottom;
    fs["roi_enabled"]  >> roi_enabled;
    cv::FileNode fn_rois = fs["rois"];
    cv::FileNodeIterator it = fn_rois.begin();
    for(; it != fn_rois.end(); ++it)
    {
      const int roi_x = (*it)["x"];
      const int roi_y = (*it)["y"];
      const int roi_w = (*it)["width"];
      const int roi_h = (*it)["height"];
      const float roi_leftAngle = (*it)["leftAngle"];
      const float roi_topAngle = (*it)["topAngle"];
      const float roi_rightAngle = (*it)["rightAngle"];
      const float roi_bottomAngle = (*it)["bottomAngle"];
      const ALImage::ROI roi(roi_x, roi_y, roi_w, roi_h,
                             roi_leftAngle, roi_topAngle, roi_rightAngle, roi_bottomAngle);
      rois.push_back(roi);
    }
    fs.release();
  } catch(const cv::Exception& e)
  {
    throw AL::ALError("ALVision", "readALImageFromFile",
                      "Exception caught when reading metadata from "+path_data+": "+e.what());
  }

  if(width != img.cols || height != img.rows)
  {
    throw AL::ALError("ALVision", "readALImageFromFile",
                      "Image dimensions do not match metadata");
  }

  ALImage al_image(img.cols, img.rows, colorspace, false);
  unsigned char* data = al_image.getData();
  const size_t data_size = img.cols * img.rows * img.elemSize();
  std::memcpy(data, img.data, data_size);
  al_image.setTimeStamp(timestamp_s, timestamp_us);
  al_image.setCameraId(static_cast<char>(camera_id));
  al_image.setAngles(fov_left, fov_top, fov_right, fov_bottom);
  al_image.setEnableROIs(roi_enabled);
  for(size_t i = 0; i < rois.size(); ++i)
  {
    al_image.addROI(rois[i]);
  }
  return al_image;
}

}

#endif /* LIBALVISION_ALVISION_ALIMAGE_OPENCV_H_ */
