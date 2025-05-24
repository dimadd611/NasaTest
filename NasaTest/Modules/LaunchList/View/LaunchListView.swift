//
//  LaunchListView.swift
//  NasaTest
//
//  Created by Дмитрий Рахманюк on 24.05.2025.
//

import UIKit
import SwiftUI
import SDWebImageSwiftUI

struct LaunchListView: View {
    
    @State private var showingError = false
    @ObservedObject var viewModel: LaunchListViewModel
    
    var body: some View {
        ZStack {
            Color(hex: "1E2430")
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    Spacer()
                    Text("SpaceX")
                        .foregroundStyle(.black)
                        .padding(.leading, 40)
                    
                    Spacer()
                    Button {
                        viewModel.openFavourites()
                    } label: {
                        Image("favourite")
                    }
                    .frame(width: 40, height: 40)
                }
                .padding(.horizontal, 20)
                .frame(width: UIScreen.main.bounds.width, height: 50)
                .background(.white)
                
                ScrollView {
                    LazyVGrid(columns: [GridItem()]) {
                        ForEach(viewModel.launches, id: \.id) { item in
                            LauchCell(launch: item, isFav: viewModel.checkIfFavourite(item)) {
                                if viewModel.checkIfFavourite(item) {
                                    viewModel.deleteFromFavourites(id: item.id ?? "")
                                } else {
                                    viewModel.appendToFavourites(item)
                                }
                                
                            }
                            .onTapGesture {
                                viewModel.openDetails(for: item)
                            }
                        }
                    }
                }
                .ignoresSafeArea()
                .background(Color(hex: "1E2430"))
            }
        }
        .onAppear() {
            viewModel.getLaunchList()
            viewModel.getFavourites()
        }
        .alert(isPresented: $showingError) {
            Alert(title: Text("Ошибка"), message: Text(viewModel.errorMessage ?? "Неизвестная ошибка"), dismissButton: .default(Text("Ок")))
        }
        .onChange(of: viewModel.errorMessage) { newValue in
            showingError = newValue != nil
        }
    }
}

struct LauchCell: View {
    var launch: SpaceResponse
    var isFav: Bool
    var action: () -> Void
    var body: some View {
        ZStack {
            VStack {
                WebImage(url: URL(string: launch.links?.flickr?.original?.first ?? launch.links?.patch?.large ?? ""))
                    .resizable()
                    .scaledToFit()
                    .frame(width: UIScreen.main.bounds.width - 20, height: 200)
                    .padding(8)
                    .background(Color.black.opacity(0.7))
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.white, lineWidth: 2)
                    )
                HStack {
                    Text(launch.name ?? "")
                        .foregroundStyle(Color(hex: "74D0E3") ?? .white)
                    Spacer()
                    Text(launch.dateUnix?.formatUnixTimestamp() ?? "")
                        .foregroundStyle(.white)
                        .padding(.horizontal, 5)
                        .background(.gray)
                }
                .padding(.horizontal, 5)
            }
            VStack {
                HStack {
                    Spacer()
                    Button {
                        action()
                    } label: {
                        Image(isFav ? "favourite" : "unfavourite")
                    }
                    
                }
                .padding(.horizontal, 20)
                Spacer()
            }
            .padding(.vertical, 10)
        }
    }
}

#Preview {
    LaunchListView(viewModel: LaunchListViewModel(coordinator: CoordinatorImp(navigationController: UINavigationController())))
}
