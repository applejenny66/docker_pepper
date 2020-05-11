/**
* @author Aldebaran Robotics
* Copyright (c) Aldebaran Robotics 2007 All Rights Reserved
*/

#pragma once

#ifndef _LIB_ALPYTHONTOOLS_ALPYTHONTOOLS_ALPYTHONTOOLS_H_
#define _LIB_ALPYTHONTOOLS_ALPYTHONTOOLS_ALPYTHONTOOLS_H_

#include "alpython.h"
#include <string>

/**
* All classes visible in python are here
*/


namespace AL
{
  class ALValue;

  class ALCriticalSectionGILPython
  {
  public:
    ALCriticalSectionGILPython() : fState(PyGILState_Ensure()){}
    ~ALCriticalSectionGILPython() {PyGILState_Release(fState);}

  private:
    PyGILState_STATE fState;
  };

  class ALCriticalSectionAllowThreadsPython
  {
  public:
    ALCriticalSectionAllowThreadsPython() : fSave(PyEval_SaveThread()) {}
    ~ALCriticalSectionAllowThreadsPython() {PyEval_RestoreThread(fSave);}

  private:
    PyThreadState* fSave;
  };

  /**
  * ALPythonTools
  */
  class ALPythonTools
  {
  public:

    /**
     * @brief eval
     * Find the python object pInstanceVariableName and call is method pMethod with the arguments pParams
     * The result is stored in pResult
     * @param pInstanceVariableName: the global variable name of the python object to call
     * @param pMethod: the method to call
     * @param pParams: the parameters to give to the method call
     * @param pResult: the value returned by the call
     * @return the error calltrace if any, an empty string otherwise
     */
    static std::string eval(const std::string& pInstanceVariableName, const std::string& pMethod, const AL::ALValue& pParams, AL::ALValue& pResult);
    static std::string eval(const std::string& pToEval);
    static ::AL::ALValue evalReturn(const std::string& pToEval);
    static ::AL::ALValue evalFull(const std::string& pToEval);
    /**
    * convert PyObject to AL::ALValue
    */
    static ::AL::ALValue convertPyObjectToALValue(PyObject *param);
    static PyObject * convertALValueToPython(const ::AL::ALValue& value);
  };
}
#endif  // _LIB_ALPYTHONTOOLS_ALPYTHONTOOLS_ALPYTHONTOOLS_H_
