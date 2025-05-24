//
//  LaunchDetailsView.swift
//  NasaTest
//
//  Created by Дмитрий Рахманюк on 24.05.2025.
//

import Foundation
import SwiftUI

struct LaunchDetailsView: View {
    
    @State private var showingError = false
    @ObservedObject var viewModel: LaunchDetailsViewModel
    
    var body: some View {
        ZStack {
            Color(hex: "1E2430")
                .ignoresSafeArea()
            VStack {
                TopView(title: viewModel.launch.name ?? "", fav: true, isFavourite: $viewModel.isFavourite) {
                    viewModel.back()
                } favAction: {
                    if !viewModel.isFavourite {
                        viewModel.appendToFavourites()
                    } else {
                        viewModel.deleteFromFavourites()
                    }
                }
                
                if !viewModel.isLoading {
                    YouTubeView(videoID: viewModel.launch.links?.youtubeID ?? "")
                        .frame(height: 200)
                        .cornerRadius(12)
                        .padding()
                    Text(viewModel.launch.dateUnix?.formatUnixTimestamp() ?? "")
                        .padding(.top, 20)
                    Text(viewModel.launch.details ?? "")
                        .padding(.horizontal, 10)
                        .padding(.top, 20)
                    Text("Rocket name: \(viewModel.rocket?.name ?? "")")
                        .padding(.top, 20)
                        .foregroundStyle(.cyan)
                    Text("Payload mass: " + viewModel.sumPayload() + " kg")
                        .foregroundStyle(.cyan)
                    Spacer()
                    
                    Button {
                        if let url = URL(string: viewModel.rocket?.wikipedia ?? "") {
                            UIApplication.shared.open(url)
                        }
                    } label: {
                        Text("Wikipedia")
                            .foregroundStyle(.blue)
                    }
                } else {
                    Spacer()
                    
                    ProgressView()
                    
                    Spacer()
                }

            }
        }
        .onAppear() {
            viewModel.getRocketInfo()
        }
        .alert(isPresented: $showingError) {
            Alert(
                title: Text("Error"),
                message: Text(viewModel.errorMessage ?? "Unknown error"),
                dismissButton: .default(Text("Ok")) {
                    viewModel.isLoading = false
                })}
        .onChange(of: viewModel.errorMessage) { newValue in
            showingError = newValue != nil
        }
    }
}

struct TopView: View {
    var title: String
    var fav: Bool
    @Binding var isFavourite: Bool
    var action: () -> Void
    var favAction: () -> Void
    var body: some View {
        HStack {
            
            Button(action: {
                action()
            }){
                HStack(spacing: 0) {
                    Image(systemName: "chevron.left")
                        .foregroundStyle(.blue)
                }
            }
            .frame(width: 40)
            
            Spacer()
            
            Text(title)
                .foregroundStyle(.black)
                .padding(.trailing, fav ? 0 : 40)
            
            Spacer()
            
            if fav {
                Button(action: {
                    favAction()
                }){
                    HStack(spacing: 0) {
                        Image(isFavourite ? "favourite" : "unfavourite")
                            .frame(width: 40, height: 40)
                    }
                }
                .frame(width: 40, height: 40)
            }
        }
        .padding(.horizontal, 10)
        .frame(width: UIScreen.main.bounds.width, height: 50)
        .background(.white)
    }
}
