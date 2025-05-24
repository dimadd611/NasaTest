//
//  LaunchDetailsViewModel.swift
//  NasaTest
//
//  Created by Дмитрий Рахманюк on 24.05.2025.
//

import Foundation

final class LaunchDetailsViewModel: ObservableObject {
    @Published var launch: SpaceResponse
    @Published var rocket: RocketResponse?
    @Published var isLoading = false
    var coordinator: Coordinator
    
   init (launch: SpaceResponse, coordinator: Coordinator) {
        self.launch = launch
        self.coordinator = coordinator
    }
    
    func getRocketInfo() {
        isLoading = true
        Task {
            do {
                let info = try await APIManager.shared.getRocketInfo(id: launch.rocket ?? "")
                print(info)
                DispatchQueue.main.async {
                    self.rocket = info
                    self.isLoading = false
                }
            } catch {
                print("Другая ошибка: \(error.localizedDescription)")
            }
        }
    }
    
    func sumPayload() -> String {
        var sum: Int = 0
        rocket?.payloadWeights?.forEach { weight in
            sum += weight.kg ?? 0
        }
        return "\(sum)"
    }
    
    func back() {
        coordinator.popController(animated: true)
    }
}
