import Java
import Android
import AndroidOS
import AndroidApp
import AndroidContent
import AndroidLocation

import FusionLocation_Common


public class LocationManager {
  typealias AndroidLocationManager = AndroidLocation.LocationManager

  private var currentActivity: Activity? { Application.currentActivity }

  private let locationManager: AndroidLocationManager?
  private let locationListener: LocationListener
  
  public let usage: LocationUsage

  public required init(usage: LocationUsage) {
    self.usage = usage

    self.locationManager =
      Application.currentActivity?.getSystemService(name: ContextStatic.LOCATION_SERVICE)
      as? AndroidLocationManager
  
    self.locationListener = LocationListener()
  }
}

extension LocationManager: LocationManagerProtocol {
  public func requestAuthorization() {
    currentActivity?.requestPermissions(      
      permissions: [Manifest.permission.ACCESS_FINE_LOCATION], requestCode: 1111)
  }

  public func checkAuthorization() -> Bool {
    guard
      let status = currentActivity?.checkSelfPermission(
        permission: Manifest.permission.ACCESS_FINE_LOCATION),

      status == PackageManagerStatic.PERMISSION_GRANTED
    else {
      print("Permissions not granted. Requesting...")
  
      return false
    }
    print("Permissions granted")
    return true
  }

  public func requestCurrentLocation(receiver: @escaping (FusionLocation_Common.Location?) -> Void) {    
    guard
        let provider = self.locationManager?.getBestProvider(criteria: Criteria(), enabledOnly: true)
    else {
      return
    }   
            
    guard let aLocation = self.locationManager?.getLastKnownLocation(provider: provider) else {
      print("Last known location is unavailable")
      return
    }

    receiver(aLocation.location)
  }

	public func startUpdatingLocation(receiver: @escaping (FusionLocation_Common.Location?) -> Void) {
	    guard
    	    let provider = self.locationManager?.getBestProvider(criteria: Criteria(), enabledOnly: false)
	    else {
	      return
    	}
	
	    self.locationManager?.requestLocationUpdates(provider: provider, minTime: 400, minDistance: 1, listener: locationListener)
            
    	guard let aLocation = self.locationManager?.getLastKnownLocation(provider: provider) else {
      		print("Last known location is unavailable")
      		return
    	}

	    receiver(aLocation.location)
	}

  	public func stopUpdatingLocation() {
  	    self.locationManager?.removeUpdates(listener: locationListener)

	}
  
    public func distanceBetween(from location1: FusionLocation_Common.Location, to location2: FusionLocation_Common.Location) -> Double {
    	let results = [Float]()
    	AndroidLocation.Location.distanceBetween(startLatitude:location1.coordinate.latitude, startLongitude: location1.coordinate.longitude, endLatitude:location2.coordinate.latitude, endLongitude:location2.coordinate.longitude, results: results);
        return Double(results[0])
    }

    public func bearingBetween(from location1: FusionLocation_Common.Location, to location2: FusionLocation_Common.Location) -> Double {
	    let startLocation = AndroidLocation.Location(provider: AndroidLocation.LocationManager.GPS_PROVIDER)
		startLocation.setLatitude(latitude: location1.coordinate.latitude)
		startLocation.setLongitude(longitude: location1.coordinate.longitude)
		
		let endLocation = AndroidLocation.Location(provider: AndroidLocation.LocationManager.GPS_PROVIDER)
		endLocation.setLatitude(latitude: location2.coordinate.latitude)
		endLocation.setLongitude(longitude: location2.coordinate.longitude)
		
		return startLocation.bearingTo(dest: endLocation)
		
//		func degreesToRadians(degrees: Double) -> Double { return degrees * .pi / 180.0 }
//        func radiansToDegrees(radians: Double) -> Double { return radians * 180.0 / .pi }
//        
//        let lat1 = degreesToRadians(degrees: location1.coordinate.latitude)
//        let lon1 = degreesToRadians(degrees: location1.coordinate.longitude)
//
//        let lat2 = degreesToRadians(degrees: location2.coordinate.latitude)
//        let lon2 = degreesToRadians(degrees: location2.coordinate.longitude)
//
//        let dLon = lon2 - lon1
//
//        let y = sin(dLon) * cos(lat2)
//        let x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon)
//        let radiansBearing = atan2(y, x)
//
//        return radiansToDegrees(radians: radiansBearing)
    }
}

fileprivate extension AndroidLocation.Location {
  var location: FusionLocation_Common.Location {
    FusionLocation_Common.Location(latitude: self.getLatitude(), longitude: self.getLongitude())
  }
}


class LocationListener: Object, AndroidLocation.LocationListener {
  func onLocationChanged(location: AndroidLocation.Location?) { 
    print("Location: \(location?.getLatitude()), \(location?.getLongitude())")
    receiver(Location(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude))
  }

  func onStatusChanged(provider: String, status: Int32, extras: Bundle?) { 
  
  }

  func onProviderEnabled(provider: String) { 
  
  }

  func onProviderDisabled(provider: String) { 
  
  }
}