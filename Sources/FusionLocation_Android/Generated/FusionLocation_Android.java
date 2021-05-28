package FusionLocation_Android;

class LocationListener implements android.location.LocationListener {
  private long _ptr;
  
  public void onLocationChanged(android.location.Location location) {
    onLocationChangedImpl(_ptr ,location);
  }
  private native void onLocationChangedImpl(long _ptr, android.location.Location location);
  
  public void onStatusChanged(java.lang.String provider, int status, android.os.Bundle extras) {
    onStatusChangedImpl(_ptr ,provider ,status ,extras);
  }
  private native void onStatusChangedImpl(long _ptr, java.lang.String provider, int status, android.os.Bundle extras);
  
  public void onProviderEnabled(java.lang.String provider) {
    onProviderEnabledImpl(_ptr ,provider);
  }
  private native void onProviderEnabledImpl(long _ptr, java.lang.String provider);
  
  public void onProviderDisabled(java.lang.String provider) {
    onProviderDisabledImpl(_ptr ,provider);
  }
  private native void onProviderDisabledImpl(long _ptr, java.lang.String provider);
  
}
