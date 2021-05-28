#if os(macOS) || os(iOS)
import FusionLocation_Common

import CoreLocation

public struct LocationManager {  
  fileprivate class CLDelegate: NSObject {
    typealias Receiver = (Location) -> Void
    var receiver: Receiver?
  } 
  
  private let delegate: CLDelegate
  private let locationManager: CLLocationManager  
  
  public let usage: LocationUsage
  
  public init(usage: LocationUsage) {
     self.usage = usage
     self.delegate = CLDelegate()
     self.locationManager = CLLocationManager()
     self.locationManager.delegate = self.delegate          
  }
  
  private func requestAuthorization() {
    if #available(OSX 10.15, *) {
      switch self.usage {
        case .always:
          self.locationManager.requestAlwaysAuthorization()
               
        case .whenInUse:     
          self.locationManager.requestWhenInUseAuthorization()       
      }
    }
  }
  
  private func checkAuthorization() -> Bool {
    guard CLLocationManager.locationServicesEnabled() else { return false }
    switch CLLocationManager.authorizationStatus() {
      case .denied, .restricted:        
        return false
      
      case .notDetermined:
        if #available(OSX 10.15, *) {
          requestAuthorization()
          return false
          
        } else {
          return true
        }
                  
      default:
        return true    
    }        
  }
  
  public func requestCurrentLocation(receiver: @escaping (Location) -> Void) {
    self.delegate.receiver = receiver
    
    guard checkAuthorization() else { return }
    self.locationManager.requestLocation()
  }
  
  public func startUpdatingLocation(receiver: @escaping (Location) -> Void) {
    self.delegate.receiver = receiver
    
    guard checkAuthorization() else { return }    
    self.locationManager.startUpdatingLocation()
  }
  
  public func stopUpdatingLocation() {
    self.locationManager.stopUpdatingLocation()    
  }
}

extension LocationManager.CLDelegate: CLLocationManagerDelegate {
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    print("Location: \(locations.first?.coordinate)")
  }
  
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    
  }    
}

#endif