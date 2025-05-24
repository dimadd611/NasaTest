//
//  Color+.swift
//  NasaTest
//
//  Created by Дмитрий Рахманюк on 24.05.2025.
//

import Foundation
import SwiftUI

extension Color {
    init?(hex: String) {
        var hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        // Убираем префикс "#" если есть
        if hexString.hasPrefix("#") {
            hexString.removeFirst()
        }
        
        // HEX может быть 6 (RRGGBB) или 8 (AARRGGBB) символов
        guard hexString.count == 6 || hexString.count == 8 else {
            return nil
        }
        
        var rgbaValue: UInt64 = 0
        Scanner(string: hexString).scanHexInt64(&rgbaValue)
        
        let r, g, b, a: Double
        
        if hexString.count == 6 {
            // Формат RRGGBB
            r = Double((rgbaValue & 0xFF0000) >> 16) / 255
            g = Double((rgbaValue & 0x00FF00) >> 8) / 255
            b = Double(rgbaValue & 0x0000FF) / 255
            a = 1.0
        } else {
            // Формат AARRGGBB
            a = Double((rgbaValue & 0xFF000000) >> 24) / 255
            r = Double((rgbaValue & 0x00FF0000) >> 16) / 255
            g = Double((rgbaValue & 0x0000FF00) >> 8) / 255
            b = Double(rgbaValue & 0x000000FF) / 255
        }
        
        self.init(.sRGB, red: r, green: g, blue: b, opacity: a)
    }
}
