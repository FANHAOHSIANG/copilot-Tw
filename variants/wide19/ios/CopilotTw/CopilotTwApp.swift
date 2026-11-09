import SwiftUI
import MapKit
import CoreLocation

@main
struct CopilotTwApp: App {
    var body: some Scene {
        WindowGroup { DriveScreen() }
    }
}

final class LocationModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published private(set) var fix: CLLocation?
    @Published private(set) var status = "點 GPS 開始定位"
    @Published private(set) var running = false
    private let manager = CLLocationManager()

    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        manager.activityType = .automotiveNavigation
        manager.distanceFilter = 3
    }

    func toggle() {
        if running {
            stop()
            return
        }
        switch manager.authorizationStatus {
        case .notDetermined:
            running = true
            manager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            running = true
            manager.startUpdatingLocation()
            status = "等待精確定位"
        default:
            status = "請在 iPhone 設定允許精確位置"
        }
    }

    func stop() {
        manager.stopUpdatingLocation()
        running = false
        fix = nil
        status = "點 GPS 開始定位"
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        guard running else { return }
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            manager.startUpdatingLocation()
            status = "等待精確定位"
        case .restricted, .denied:
            stop()
            status = "請在 iPhone 設定允許精確位置"
        case .notDetermined: break
        @unknown default: stop()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard running, let latest = locations.last else { return }
        fix = latest
        status = "GPS 已定位"
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        fix = nil
        status = "定位暫時不可用"
    }
}

struct DriveScreen: View {
    @StateObject private var location = LocationModel()
    @State private var catalog: CameraCatalog?
    @State private var alert: CameraAlert?
    @State private var dataStatus = "載入測速資料"
    @State private var position: MapCameraPosition = .automatic
    @State private var demoStarted: Date?
    @State private var demo = false
    @Environment(\.scenePhase) private var scenePhase

    var body: some View {
        GeometryReader { geometry in
            let layout = geometry.size.width > geometry.size.height
                ? AnyLayout(HStackLayout(spacing: 12)) : AnyLayout(VStackLayout(spacing: 12))
            layout {
                Map(position: $position) {
                    UserAnnotation()
                    if let alert {
                        Marker("附近固定測速", coordinate: alert.point.coordinate).tint(.red)
                    }
                }
                .mapControls { MapUserLocationButton() }
                .clipShape(RoundedRectangle(cornerRadius: 18))
                .accessibilityLabel("Apple 地圖")

                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text("Copilot tw").font(.headline)
                        Spacer()
                        Button(location.running ? "停止 GPS" : "GPS") {
                            location.toggle()
                            if location.running { position = .userLocation(fallback: .automatic) }
                        }.buttonStyle(.borderedProminent)
                        Button("示範") {
                            demoStarted = Date()
                            demo = true
                        }.buttonStyle(.bordered)
                    }
                    if let alert {
                        CameraCard(title: alert.point.road, distance: alert.distance)
                    } else {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("附近固定測速").font(.title2.bold())
                            Text(location.status).foregroundStyle(.secondary)
                            Text(dataStatus).font(.footnote).foregroundStyle(.secondary)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                        .padding()
                        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 18))
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .padding()
        }
        .task {
            do {
                catalog = try CameraCatalog.load()
                if let metadata = catalog?.metadata {
                    dataStatus = "\(metadata.fixedRecords) 筆固定點 · \(metadata.retrievedAt.prefix(10))"
                }
            } catch {
                dataStatus = "固定測速資料載入失敗"
            }
            while !Task.isCancelled {
                refresh()
                try? await Task.sleep(for: .milliseconds(250))
            }
        }
        .onChange(of: scenePhase) { _, phase in
            if phase == .background {
                location.stop()
                alert = nil
            }
        }
        .sheet(isPresented: $demo) {
            VStack(spacing: 16) {
                HStack {
                    Text("固定測速示範").font(.headline)
                    Spacer()
                    Button("關閉") { demo = false }
                }
                TimelineView(.animation(minimumInterval: 0.04)) { timeline in
                    let elapsed = timeline.date.timeIntervalSince(demoStarted ?? timeline.date)
                    let distance = max(12, 560 - elapsed.truncatingRemainder(dividingBy: 16) * 38)
                    CameraCard(title: "示範道路", distance: distance)
                }
            }.padding()
        }
    }

    private func refresh() {
        guard let fix = location.fix else {
            alert = nil
            return
        }
        alert = catalog?.nearby(from: fix, now: Date())
    }
}

struct CameraCard: View {
    let title: String
    let distance: Double

    var body: some View {
        let progress = min(1, max(0, 1 - distance / 500))
        let period = 1.2 - 0.8 * progress
        TimelineView(.animation(minimumInterval: 0.04, paused: distance > 500)) { timeline in
            let phase = timeline.date.timeIntervalSinceReferenceDate.truncatingRemainder(dividingBy: period) / period
            let glow = distance <= 500 ? (0.14 + 0.86 * progress) * (0.65 + 0.35 * sin(phase * 2 * .pi)) : 0
            VStack(alignment: .leading, spacing: 10) {
                Label("附近固定測速", systemImage: "camera.fill").font(.headline)
                Text("\(Int(distance.rounded())) m").font(.system(size: 46, weight: .bold, design: .rounded))
                    .monospacedDigit().contentTransition(.numericText())
                Text(title).lineLimit(1)
                Text("直線距離 · 僅提醒").font(.footnote).foregroundStyle(.secondary)
            }
            .padding(18)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
            .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 18))
            .overlay {
                RoundedRectangle(cornerRadius: 18)
                    .strokeBorder(.red.opacity(glow), lineWidth: 4)
                    .shadow(color: .red.opacity(glow * 0.8), radius: 12)
                    .allowsHitTesting(false)
            }
        }
    }
}
