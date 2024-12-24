//
//  Colors.swift
//  Swipe
//
//  Created by Arjun Pratap Choudhary on 23/12/24.
//



import Foundation
import SwiftUI

class Colors {
    static var theme_bg_color: Color = Color.black
    static var color_7e7e7e : Color = Color.init(hex: "#7E7E7E")
    static var color_ffffff : Color = Color.init(hex: "#ffffff")
    static var color_66d16c : Color = Color.init(hex: "#66d16c")
    static var color_000000 : Color = Color.init(hex: "#000000")
    static var call_disabled: Color = Color.init(hex:"#C0C0C0")
    static var cta_disabled : Color = Color.init(hex: "#2D532F")
    static var color_a6a6a6 : Color = Color.init(hex: "#A6A6A6")
    static var color_6a6a6a : Color = Color.init(hex: "#6A6A6A")
    static var color_222222 : Color = Color.init(hex: "#222222")
    static var color_282828 : Color = Color.init(hex: "#282828")
    static var color_242424 : Color = Color.init(hex: "#242424")
    static var color_346b37 : Color = Color.init(hex: "#346B37")
    static var color_101010 : Color = Color.init(hex: "#101010")
    static var color_acacac : Color = Color.init(hex: "#ACACAC")
    static var color_262626 : Color = Color.init(hex: "#262626")
    static var color_d9d9d9: Color = Color.init(hex: "#D9D9D9")
    static var color_4a4a4a: Color = Color.init(hex: "#4A4A4A")
    static var color_292929: Color = Color.init(hex: "#292929")
    static var color_f2f2f2: Color = Color.init(hex: "#F2F2F2")
    static var color_ff0000: Color = Color.init(hex: "#FF0000")
    
}

extension Color {
    init(hex string: String) {
        var string: String = string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        if string.hasPrefix("#") {
            _ = string.removeFirst()
        }

        // Double the last value if incomplete hex
        if !string.count.isMultiple(of: 2), let last = string.last {
            string.append(last)
        }

        // Fix invalid values
        if string.count > 8 {
            string = String(string.prefix(8))
        }

        // Scanner creation
        let scanner = Scanner(string: string)

        var color: UInt64 = 0
        scanner.scanHexInt64(&color)

        if string.count == 2 {
            let mask = 0xFF

            let g = Int(color) & mask

            let gray = Double(g) / 255.0

            self.init(.sRGB, red: gray, green: gray, blue: gray, opacity: 1)

        } else if string.count == 4 {
            let mask = 0x00FF

            let g = Int(color >> 8) & mask
            let a = Int(color) & mask

            let gray = Double(g) / 255.0
            let alpha = Double(a) / 255.0

            self.init(.sRGB, red: gray, green: gray, blue: gray, opacity: alpha)

        } else if string.count == 6 {
            let mask = 0x0000FF
            let r = Int(color >> 16) & mask
            let g = Int(color >> 8) & mask
            let b = Int(color) & mask

            let red = Double(r) / 255.0
            let green = Double(g) / 255.0
            let blue = Double(b) / 255.0

            self.init(.sRGB, red: red, green: green, blue: blue, opacity: 1)

        } else if string.count == 8 {
            let mask = 0x000000FF
            let r = Int(color >> 24) & mask
            let g = Int(color >> 16) & mask
            let b = Int(color >> 8) & mask
            let a = Int(color) & mask

            let red = Double(r) / 255.0
            let green = Double(g) / 255.0
            let blue = Double(b) / 255.0
            let alpha = Double(a) / 255.0

            self.init(.sRGB, red: red, green: green, blue: blue, opacity: alpha)

        } else {
            self.init(.sRGB, red: 1, green: 1, blue: 1, opacity: 1)
        }
    }
}
