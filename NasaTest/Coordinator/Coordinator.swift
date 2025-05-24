//
//  Coordinator.swift
//  NasaTest
//
//  Created by Дмитрий Рахманюк on 24.05.2025.
//

import Foundation
import UIKit

protocol Coordinator {
    var parentCoordinator: Coordinator? { get set }
    var children: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    
    func showLaunchListModule()
    func showLaunchDetailsModule(launch: SpaceResponse)
    
    func popController(animated: Bool)
    func dismissController()
}

class CoordinatorImp: Coordinator {
    var parentCoordinator: Coordinator?
    
    var children: [Coordinator] = []
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func showLaunchListModule() {
        let viewController = LauchListHosting()
        let viewModel = LaunchListViewModel(coordinator: self)
        viewController.viewModel = viewModel
        navigationController.pushViewController(viewController,
                                                animated: false)
    }
    
    func showLaunchDetailsModule(launch: SpaceResponse) {
        let viewController = LaunchDetailsHosting()
        let viewModel = LaunchDetailsViewModel(launch: launch, coordinator: self)
        viewController.viewModel = viewModel
        navigationController.pushViewController(viewController,
                                                animated: false)
    }
    
    func popController(animated: Bool) {
        navigationController.popViewController(animated: animated)
    }
    
    func dismissController() {
        navigationController.dismiss(animated: false)
    }
    
}

