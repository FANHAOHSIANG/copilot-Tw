import Foundation
import CoreLocation

struct CameraCatalog: Decodable {
    struct Metadata: Decodable {
        let fixedRecords: Int
        let retrievedAt: String
    }
    let metadata: Metadata
    let points: [CameraPoint]

    static func load() throws -> CameraCatalog {
        guard let url = Bundle.main.url(forResource: "tw_cameras", withExtension: "json") else {
            throw CocoaError(.fileNoSuchFile)
        }
        let catalog = try JSONDecoder().decode(Self.self, from: Data(contentsOf: url))
        guard catalog.metadata.fixedRecords == catalog.points.count else {
            throw CocoaError(.fileReadCorruptFile)
        }
        return catalog
    }

    func nearby(from fix: CLLocation, now: Date) -> CameraAlert? {
        let age = now.timeIntervalSince(fix.timestamp)
        guard (0...3).contains(age), fix.horizontalAccuracy > 0, fix.horizontalAccuracy <= 30,
              fix.speed >= 1.5, fix.course >= 0, fix.course < 360,
              fix.courseAccuracy >= 0, fix.courseAccuracy <= 35,
              fix.sourceInformation?.isSimulatedBySoftware != true else { return nil }

        return points.lazy.compactMap { point -> CameraAlert? in
            guard abs(fix.coordinate.latitude - point.lat) <= 0.006,
                  abs(fix.coordinate.longitude - point.lon) <= 0.006 else { return nil }
            let distance = fix.distance(from: CLLocation(latitude: point.lat, longitude: point.lon))
            guard (12...500).contains(distance) else { return nil }
            let angle = Self.difference(fix.course, Self.bearing(fix.coordinate, point.coordinate))
            guard angle <= 30, distance * sin(angle * .pi / 180) <= 60 else { return nil }
            guard point.bearings.isEmpty || point.bearings.contains(where: {
                Self.difference(fix.course, $0) <= 50
            }) else { return nil }
            return CameraAlert(point: point, distance: distance)
        }.min { $0.distance < $1.distance }
    }

    private static func difference(_ a: Double, _ b: Double) -> Double {
        let delta = abs((a - b).truncatingRemainder(dividingBy: 360))
        return min(delta, 360 - delta)
    }

    private static func bearing(_ a: CLLocationCoordinate2D, _ b: CLLocationCoordinate2D) -> Double {
        let p1 = a.latitude * .pi / 180
        let p2 = b.latitude * .pi / 180
        let delta = (b.longitude - a.longitude) * .pi / 180
        let y = sin(delta) * cos(p2)
        let x = cos(p1) * sin(p2) - sin(p1) * cos(p2) * cos(delta)
        return (atan2(y, x) * 180 / .pi + 360).truncatingRemainder(dividingBy: 360)
    }
}

struct CameraPoint: Decodable, Identifiable {
    let id: String
    let road: String
    let lat: Double
    let lon: Double
    let bearings: [Double]

    var coordinate: CLLocationCoordinate2D { .init(latitude: lat, longitude: lon) }
}

struct CameraAlert {
    let point: CameraPoint
    let distance: Double
}
