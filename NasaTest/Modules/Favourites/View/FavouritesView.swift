//
//  FavouritesView.swift
//  NasaTest
//
//  Created by Дмитрий Рахманюк on 24.05.2025.
//

import Foundation
import SwiftUI

struct FavouritesView: View {
    
    @ObservedObject var viewModel: FavouritesViewModel
    
    var body: some View {
        ZStack {
            Color(hex: "1E2430")
                .ignoresSafeArea()
            
            VStack {
                TopView(title: "Favourites") {
                    viewModel.back()
                }
                
                ScrollView {
                    LazyVGrid(columns: [GridItem()]) {
                        ForEach(viewModel.favourites, id: \.id) { item in
                            LauchCell(launch: item, isFav: true) {
                                viewModel.deleteFromFavourites(id: item.id ?? "")
                            }
                        }
                    }
                }
            }
        }
        .onAppear() {
            viewModel.getFavourites()
        }
    }
}
