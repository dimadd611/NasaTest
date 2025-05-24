//
//  LaunchDetailsView.swift
//  NasaTest
//
//  Created by Дмитрий Рахманюк on 24.05.2025.
//

import Foundation
import SwiftUI

struct LaunchDetailsView: View {
    
    @ObservedObject var viewModel: LaunchDetailsViewModel
    
    var body: some View {
        ZStack {
            Color(hex: "1E2430")
                .ignoresSafeArea()
            VStack {
                TopView(title: viewModel.launch.name ?? "") {
                    viewModel.back()
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
    }
}

struct TopView: View {
    var title: String
    var action: () -> Void
    var body: some View {
        HStack {
            
            Button(action: {
                action()
            }){
                HStack(spacing: 0) {
                    Image(systemName: "chevron.left")
                        .foregroundStyle(.blue)
                    Text("SpaceX")
                }
            }
            .frame(width: 72)
            
            Spacer()
            
            Text(title)
                .foregroundStyle(.black)
                .padding(.trailing, 72)
            
            Spacer()
        }
        .padding(.horizontal, 10)
        .frame(width: UIScreen.main.bounds.width, height: 50)
        .background(.white)
    }
}
