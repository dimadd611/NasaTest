//
//  LaunchListViewModel.swift
//  NasaTest
//
//  Created by Дмитрий Рахманюк on 24.05.2025.
//

import Foundation

final class LaunchListViewModel: ObservableObject {
    @Published var launches: [SpaceResponse] = []
    @Published var favourites: [SpaceResponse] = []
    @Published var errorMessage: String?
    
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
                    self.errorMessage = nil // Ошибка отсутствует
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
    
    func appendToFavourites(_ launch: SpaceResponse) {
        DataBaseManager.shared.createLaunch(launch: launch)
        getFavourites()
    }
    
    func getFavourites() {
        favourites = DataBaseManager.shared.fetchLaunches().map({$0.toModel()})
    }
    
    func checkIfFavourite(_ launch: SpaceResponse) -> Bool {
        return favourites.contains(where: { $0.id == launch.id })
    }
    
    func openDetails(for launch: SpaceResponse) {
        coordinator.showLaunchDetailsModule(launch: launch, isFavourite: checkIfFavourite(launch))
    }
    
    func deleteFromFavourites(id: String) {
        DataBaseManager.shared.deleteLaunch(id: id)
        getFavourites()
    }
    
    func openFavourites() {
        coordinator.showFavouritesModule()
    }
    
    func back() {
        coordinator.popController(animated: true)
    }
}
