import Foundation

public enum LocationUsage {
    case always
    case whenInUse
}

public protocol LocationManagerProtocol {
    init(usage: LocationUsage)

    func requestAuthorization()
    func requestCurrentLocation(receiver: @escaping (Location?) -> Void)
    func startUpdatingLocation(receiver: @escaping (Location?) -> Void)
    func stopUpdatingLocation()
    func distanceBetween(from location1: Location, to location2: Location) -> Double
    func bearingBetween(from location1: Location, to location2: Location) -> Double
}
