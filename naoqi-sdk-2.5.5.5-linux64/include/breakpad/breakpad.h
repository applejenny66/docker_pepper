/*
** breakpad.h
**
** Author(s):
**  - Samuel MARTIN <smartin@aldebaran-robotics.com>
**
** Copyright (C) 2012 Aldebaran Robotics
*/

#ifndef BREAKPAD_H_
#define BREAKPAD_H_

#include <string>

namespace google_breakpad
{
  class ExceptionHandler;
}

class BreakpadExceptionHandler {
public:
  typedef bool (*CustomMinidumpCallback)(const std::string& dumpPath, bool succeeded);

public:
  explicit BreakpadExceptionHandler(
    const std::string &dump_path,
    CustomMinidumpCallback cb = NULL);

  // Write a minidum immediately without crashing
  // Useful for testing
  void writeMinidump();

  // Set a build tag: used during build on a buildfarm
  void setBuildTag(const std::string &buildTag);

  virtual ~BreakpadExceptionHandler();

private:
  google_breakpad::ExceptionHandler* _bp;
};

#endif /* !BREAKPAD_H_ */
