//
//  LaunchDetailsHosting.swift
//  NasaTest
//
//  Created by Дмитрий Рахманюк on 24.05.2025.
//

import Foundation
import SwiftUI
import UIKit

class LaunchDetailsHosting: UIViewController {
    var viewModel: LaunchDetailsViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let swiftUIView = LaunchDetailsView(viewModel: viewModel)

        let hostingController = UIHostingController(rootView: swiftUIView)
        
        addChild(hostingController)
        hostingController.view.frame = view.bounds
        view.addSubview(hostingController.view)
        hostingController.didMove(toParent: self)
    }
}
