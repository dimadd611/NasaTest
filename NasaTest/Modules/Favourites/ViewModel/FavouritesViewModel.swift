//
//  FavouritesViewModel.swift
//  NasaTest
//
//  Created by Дмитрий Рахманюк on 24.05.2025.
//

import Foundation

final class FavouritesViewModel: ObservableObject {
    @Published var favourites: [SpaceResponse] = []
    var coordinator: Coordinator
    
   init (coordinator: Coordinator) {
        self.coordinator = coordinator
    }
    
    func getFavourites() {
        favourites = DataBaseManager.shared.fetchLaunches().map({$0.toModel()})
    }
    
    func deleteFromFavourites(id: String) {
        DataBaseManager.shared.deleteLaunch(id: id)
        getFavourites()
    }
    
    func back() {
        coordinator.popController(animated: true)
    }
}
