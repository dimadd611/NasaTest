//
//  LaunchListViewModel.swift
//  NasaTest
//
//  Created by Дмитрий Рахманюк on 24.05.2025.
//

import Foundation

final class LaunchListViewModel: ObservableObject {
    @Published var launches: [SpaceResponse] = []
    var coordinator: Coordinator
    
    init(coordinator: Coordinator) {
        self.coordinator = coordinator
    }
    
    func getLaunchList() {
        Task {
            do {
                let launches = try await APIManager.shared.fetchLaunches()
                DispatchQueue.main.async {
                    self.launches = launches
                }
            } catch {
                print("Другая ошибка: \(error.localizedDescription)")
            }
        }
    }
    
    func back() {
        coordinator.popController(animated: true)
    }
}
