
public struct Location {
    public let coordinate: LocationCoordinate
    
    public init(coordinate: LocationCoordinate) {
        self.coordinate = coordinate
    }
    
    public init(latitude: LocationCoordinate.Degrees, longitude: LocationCoordinate.Degrees) {
        self.coordinate = LocationCoordinate(latitude: latitude, longitude: longitude)
    }
}

public struct LocationCoordinate {
    public typealias Degrees = Double
    
    public let latitude: Degrees
    public let longitude: Degrees
}