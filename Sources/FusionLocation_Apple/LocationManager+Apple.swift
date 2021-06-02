#if os(macOS) || os(iOS)
import FusionLocation_Common
import CoreLocation

public class LocationManager {
    fileprivate class CLDelegate: NSObject {
        typealias Receiver = (Location?) -> Void
        var receiver: Receiver?
    }
  
    private let delegate: CLDelegate
    private let locationManager: CLLocationManager
    
    public let usage: LocationUsage
    
    public required init(usage: LocationUsage) {
        self.usage = usage
        self.delegate = CLDelegate()
        self.locationManager = CLLocationManager()
        self.locationManager.delegate = self.delegate
    }
}

extension LocationManager: LocationManagerProtocol {
    public func requestAuthorization() {
        if #available(OSX 10.15, *) {
            switch self.usage {
            case .always:
                self.locationManager.requestAlwaysAuthorization()
                   
            case .whenInUse:
                self.locationManager.requestWhenInUseAuthorization()
            }
        }
    }
  
    public func checkAuthorization() -> Bool {
        guard CLLocationManager.locationServicesEnabled() else { return false }
        switch CLLocationManager.authorizationStatus() {
        case .denied, .restricted:
            return false
        case .notDetermined:
            if #available(OSX 10.15, *) {
                return false
            } else {
                return true
            }
        default:
          return true
        }
    }
  
    public func requestCurrentLocation(receiver: @escaping (Location?) -> Void) {
        self.delegate.receiver = receiver
        
        guard checkAuthorization() else {
            receiver(nil)
            return
        }
        self.locationManager.requestLocation()
    }
    
    public func startUpdatingLocation(receiver: @escaping (Location?) -> Void) {
        self.delegate.receiver = receiver
        
        guard checkAuthorization() else {
            receiver(nil)
            return
        }
        self.locationManager.startUpdatingLocation()
    }
    
    public func stopUpdatingLocation() {
        self.locationManager.stopUpdatingLocation()
    }
    
    public func distanceBetween(from location1: Location, to location2: Location) -> Double {
        let coordinate0 = CLLocation(latitude: location1.coordinate.latitude, longitude: location1.coordinate.longitude)
        let coordinate1 = CLLocation(latitude: location2.coordinate.latitude, longitude: location2.coordinate.longitude)

        return coordinate0.distance(from: coordinate1)
    }

    public func bearingBetween(from location1: Location, to location2: Location) -> Double {
        func degreesToRadians(degrees: Double) -> Double { return degrees * .pi / 180.0 }
        func radiansToDegrees(radians: Double) -> Double { return radians * 180.0 / .pi }
        
        let lat1 = degreesToRadians(degrees: location1.coordinate.latitude)
        let lon1 = degreesToRadians(degrees: location1.coordinate.longitude)

        let lat2 = degreesToRadians(degrees: location2.coordinate.latitude)
        let lon2 = degreesToRadians(degrees: location2.coordinate.longitude)

        let dLon = lon2 - lon1

        let y = sin(dLon) * cos(lat2)
        let x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon)
        let radiansBearing = atan2(y, x)

        return radiansToDegrees(radians: radiansBearing)
    }
}

extension LocationManager.CLDelegate: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first, let receiver = self.receiver else { return }
        receiver(Location(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude))
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    }
}
#endif