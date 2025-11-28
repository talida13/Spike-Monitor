import SwiftUI
import HealthKit

struct ContentView: View {
    @State private var authorizationStatusText = "Nu stiu inca"
    @State private var stepsText = "Pași (24h): —"

    private let healthStoreManager = HealthKitManager()

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Text(authorizationStatusText)
                Text(stepsText)
            }
            .padding()
            .onAppear {
                healthStoreManager.requestAuthorization { success in
                    DispatchQueue.main.async {
                        if success {
                            authorizationStatusText = "OK"


                            let stepsService = StepsService(healthStore: HKHealthStore())
                            stepsService.fetchStepsLast24h { total in
                                DispatchQueue.main.async {
                                    stepsText = "Pași (24h): \(Int(total))"
                                }
                            }
                        } else {
                            authorizationStatusText = "Nu am acces la Health"
                            stepsText = "Pași (24h): —"
                        }
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Health")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.green)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview { ContentView() }
