#if os(Android)

import Java
import Android
import AndroidOS
import AndroidApp
import AndroidContent
import AndroidLocation

@_silgen_name("Java_FusionLocation_1Android_LocationListener_onLocationChangedImpl")
public func LocationListener_onLocationChangedImpl(env: UnsafeMutablePointer<JNIEnv>, obj: JavaObject?, ptr: JavaLong, location: JavaObject?) -> Void {
  let _obj = unsafeBitCast(Int(truncatingIfNeeded:ptr), to: LocationListener.self)
  
  let _location = Location?.fromJavaObject(location)
  
  _obj.onLocationChanged(location: _location)
}
@_silgen_name("Java_FusionLocation_1Android_LocationListener_onStatusChangedImpl")
public func LocationListener_onStatusChangedImpl(env: UnsafeMutablePointer<JNIEnv>, obj: JavaObject?, ptr: JavaLong, provider: JavaObject?, status: JavaInt, extras: JavaObject?) -> Void {
  let _obj = unsafeBitCast(Int(truncatingIfNeeded:ptr), to: LocationListener.self)
  
  let _provider = String.fromJavaObject(provider)
  let _status = status
  let _extras = Bundle?.fromJavaObject(extras)
  
  _obj.onStatusChanged(provider: _provider, status: _status, extras: _extras)
}
@_silgen_name("Java_FusionLocation_1Android_LocationListener_onProviderEnabledImpl")
public func LocationListener_onProviderEnabledImpl(env: UnsafeMutablePointer<JNIEnv>, obj: JavaObject?, ptr: JavaLong, provider: JavaObject?) -> Void {
  let _obj = unsafeBitCast(Int(truncatingIfNeeded:ptr), to: LocationListener.self)
  
  let _provider = String.fromJavaObject(provider)
  
  _obj.onProviderEnabled(provider: _provider)
}
@_silgen_name("Java_FusionLocation_1Android_LocationListener_onProviderDisabledImpl")
public func LocationListener_onProviderDisabledImpl(env: UnsafeMutablePointer<JNIEnv>, obj: JavaObject?, ptr: JavaLong, provider: JavaObject?) -> Void {
  let _obj = unsafeBitCast(Int(truncatingIfNeeded:ptr), to: LocationListener.self)
  
  let _provider = String.fromJavaObject(provider)
  
  _obj.onProviderDisabled(provider: _provider)
}

#endif
