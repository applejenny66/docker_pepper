/**
 * AUTOGENERATED CODE, DO NOT EDIT
 * @author Aldebaran Robotics
 * Copyright (c) Aldebaran Robotics 2010, 2011, 2012 All Rights Reserved
 */

#pragma once
#ifndef _LIBALCOMMON_ALCOMMON_ALPROXY_HXX_
#define _LIBALCOMMON_ALCOMMON_ALPROXY_HXX_

#include <qi/type/objecttypebuilder.hpp>

namespace AL
{

  #define pushi(z, n,_) args.push_back(::qi::AnyReference::from(p ## n));
  #define consti(z, n,_) , const P ## n & p ## n
  #define genCall(n, ATYPEDECL, ATYPES, ADECL, AUSE, comma) \
  template<typename R comma ATYPEDECL>                      \
  R ALProxy::call(const std::string& pName  BOOST_PP_REPEAT(n, consti, _) )      \
{                                                                     \
    qi::AnyObject object = _object.lock();                            \
    if (!object)                                                      \
      throw ALERROR(moduleName(), pName, "module destroyed");         \
    ::qi::GenericFunctionParameters args;                             \
    args.reserve(n);                                                  \
    BOOST_PP_REPEAT(n, pushi, _)                                      \
    try                                                               \
    {                                                                 \
      qi::AnyValue res(object.metaCall(pName, args).value(), false, true); \
      qi::Promise<R> prom(qi::PromiseNoop<R>, qi::FutureCallbackType_Sync); \
      if (qi::detail::handleFuture(res.asReference(), prom))         \
      {                                                              \
        res.release(); /* handleFuture will free it */               \
        prom.future().wait();                                        \
        qiLogDebug("alproxy.call") << prom.future().hasError();      \
        return (R)prom.future().value();                             \
      }                                                              \
      else                                                           \
        return res.to<R>();                                          \
      /*return qi::AnyValue(object.metaCall(pName, args).value(), false, true).to<R>();*/   \
    }                                                                 \
    catch(const std::exception& e)                                    \
    {                                                                 \
      throw ALERROR(moduleName(), pName, e.what());                   \
    }                                                                 \
  }
  QI_GEN_RANGE(genCall, 7)
#undef pushi
#undef genCall

  #define genCall(n, ATYPEDECL, ATYPES, ADECL, AUSE, comma) \
  QI_GEN_MAYBE_TEMPLATE_OPEN(comma) ATYPEDECL QI_GEN_MAYBE_TEMPLATE_CLOSE(comma) \
  inline void ALProxy::callVoid(const std::string& pName  BOOST_PP_REPEAT(n, consti, _))   \
  {                                                                     \
    call<void>(pName comma AUSE);                                       \
  }

QI_GEN_RANGE(genCall, 7)
#undef genCall
#undef consti

  inline
  int ALProxy::pCall(const std::string& pName)
  {
    qi::AnyObject object = _object.lock();
    if (!object)
      throw ALERROR(moduleName(), pName, "module destroyed");
    qi::GenericFunctionParameters params;
    return xMetaPCall(pName, params);
  }

  template<typename P0>
  int ALProxy::pCall(const std::string& pName, const P0 &p0)
  {
    qi::AnyObject object = _object.lock();
    if (!object)
      throw ALERROR(moduleName(), pName, "module destroyed");
    qi::GenericFunctionParameters params;
    params.push_back(qi::AnyReference::from(p0));
    return xMetaPCall(pName, params);
  }

  template<typename P0, typename P1>
  int ALProxy::pCall(const std::string& pName, const P0 &p0, const P1 &p1)
  {
    qi::AnyObject object = _object.lock();
    if (!object)
      throw ALERROR(moduleName(), pName, "module destroyed");
    qi::GenericFunctionParameters params;
    params.push_back(qi::AnyReference::from(p0));
    params.push_back(qi::AnyReference::from(p1));
    return xMetaPCall(pName, params);
  }

  template<typename P0, typename P1, typename P2>
  int ALProxy::pCall(const std::string& pName, const P0 &p0, const P1 &p1, const P2 &p2)
  {
    qi::AnyObject object = _object.lock();
    if (!object)
      throw ALERROR(moduleName(), pName, "module destroyed");
    qi::GenericFunctionParameters params;
    params.push_back(qi::AnyReference::from(p0));
    params.push_back(qi::AnyReference::from(p1));
    params.push_back(qi::AnyReference::from(p2));
    return xMetaPCall(pName, params);
  }

  template<typename P0, typename P1, typename P2, typename P3>
  int ALProxy::pCall(const std::string& pName, const P0 &p0, const P1 &p1, const P2 &p2, const P3 &p3)
  {
    qi::AnyObject object = _object.lock();
    if (!object)
      throw ALERROR(moduleName(), pName, "module destroyed");
    qi::GenericFunctionParameters params;
    params.push_back(qi::AnyReference::from(p0));
    params.push_back(qi::AnyReference::from(p1));
    params.push_back(qi::AnyReference::from(p2));
    params.push_back(qi::AnyReference::from(p3));
    return xMetaPCall(pName, params);
  }

  template<typename P0, typename P1, typename P2, typename P3, typename P4>
  int ALProxy::pCall(const std::string& pName, const P0 &p0, const P1 &p1, const P2 &p2, const P3 &p3, const P4 &p4)
  {
    qi::AnyObject object = _object.lock();
    if (!object)
      throw ALERROR(moduleName(), pName, "module destroyed");
    qi::GenericFunctionParameters params;
    params.push_back(qi::AnyReference::from(p0));
    params.push_back(qi::AnyReference::from(p1));
    params.push_back(qi::AnyReference::from(p2));
    params.push_back(qi::AnyReference::from(p3));
    params.push_back(qi::AnyReference::from(p4));
    return xMetaPCall(pName, params);
  }

  template<typename P0, typename P1, typename P2, typename P3, typename P4, typename P5>
  int ALProxy::pCall(const std::string& pName, const P0 &p0, const P1 &p1, const P2 &p2, const P3 &p3, const P4 &p4, const P5 &p5)
  {
    qi::AnyObject object = _object.lock();
    if (!object)
      throw ALERROR(moduleName(), pName, "module destroyed");
    qi::GenericFunctionParameters params;
    params.push_back(qi::AnyReference::from(p0));
    params.push_back(qi::AnyReference::from(p1));
    params.push_back(qi::AnyReference::from(p2));
    params.push_back(qi::AnyReference::from(p3));
    params.push_back(qi::AnyReference::from(p4));
    params.push_back(qi::AnyReference::from(p5));
    return xMetaPCall(pName, params);
  }

}
#endif  // _LIBALCOMMON_ALCOMMON_ALPROXY_HXX_
