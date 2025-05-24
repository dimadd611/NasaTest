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
    @Published var errorMessage: String?
    @Published var isFavourite: Bool
    
    var coordinator: Coordinator
    
   init (launch: SpaceResponse, coordinator: Coordinator, isFavourite: Bool) {
        self.launch = launch
        self.coordinator = coordinator
        self.isFavourite = isFavourite
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
            } catch let apiError as APIError {
                DispatchQueue.main.async {
                    self.errorMessage = apiError.localizedDescription
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = error.localizedDescription
                }
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
    
    func appendToFavourites() {
        DataBaseManager.shared.createLaunch(launch: launch)
        isFavourite = true
    }
    func deleteFromFavourites() {
        DataBaseManager.shared.deleteLaunch(id: launch.id ?? "")
        isFavourite = false
    }
    
    func back() {
        coordinator.popController(animated: true)
    }
}
