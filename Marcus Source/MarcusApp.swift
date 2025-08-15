import SwiftUI

@main
struct MarcusApp: App {
    @StateObject private var appState = AppState(seed: true)
    var body: some Scene {
        WindowGroup { RootView().environmentObject(appState) }
    }
}
