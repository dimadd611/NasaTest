//
//  LaunchListViewModel.swift
//  NasaTest
//
//  Created by Дмитрий Рахманюк on 24.05.2025.
//

import Foundation

final class LaunchListViewModel: ObservableObject {

    var coordinator: Coordinator
    
    init(coordinator: Coordinator) {
        self.coordinator = coordinator
    }
    
    func back() {
        coordinator.popController(animated: true)
    }
}
