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
    
    @ObservedObject var viewModel: LaunchListViewModel
    
    var body: some View {
        ZStack {
            Color(hex: "1E2430")
                .ignoresSafeArea()
            
            VStack {
                Text("SpaceX")
                    .foregroundStyle(.black)
                    .frame(width: UIScreen.main.bounds.width, height: 50)
                    .background(.white)
                    
                ScrollView {
                    LazyVGrid(columns: [GridItem()]) {
                        ForEach(viewModel.launches, id: \.id) { item in
                            LauchCell(launch: item)
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
        }
    }
}

struct LauchCell: View {
    var launch: SpaceResponse
    
    var body: some View {
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
    }
}

#Preview {
    LaunchListView(viewModel: LaunchListViewModel(coordinator: CoordinatorImp(navigationController: UINavigationController())))
}
