

public enum LocationUsage {   
  case always
  case whenInUse
}

public protocol LocationManagerProtocol {
    init(usage: LocationUsage) 

    func requestAuthorization()
    func checkAuthorization()
    func requestCurrentLocation(receiver: @escaping (Location) -> Void)
    func startUpdatingLocation(receiver: @escaping (Location) -> Void)
    func stopUpdatingLocation()
}