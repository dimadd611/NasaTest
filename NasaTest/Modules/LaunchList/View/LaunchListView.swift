//
//  LaunchListView.swift
//  NasaTest
//
//  Created by Дмитрий Рахманюк on 24.05.2025.
//

import UIKit
import SwiftUI

struct LaunchListView: View {
    
    @ObservedObject var viewModel: LaunchListViewModel
    
    var body: some View {
        ZStack {
        }
    }
}

#Preview {
    LaunchListView(viewModel: LaunchListViewModel(coordinator: CoordinatorImp(navigationController: UINavigationController())))
}
