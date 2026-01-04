//
//  BorderSide.swift
//  Meleque
//
//  Created by Sinan Dinç on 12/28/25.
//

import SwiftUI

// Enum to define border sides
struct BorderSide: OptionSet {
    let rawValue: Int
    
    static let top = BorderSide(rawValue: 1 << 0)
    static let bottom = BorderSide(rawValue: 1 << 1)
    static let leading = BorderSide(rawValue: 1 << 2)
    static let trailing = BorderSide(rawValue: 1 << 3)
    
    static let all: BorderSide = [.top, .bottom, .leading, .trailing]
}

// ViewModifier for single side borders
struct BorderModifier: ViewModifier {
    let sides: BorderSide
    let color: Color
    let width: CGFloat
    
    func body(content: Content) -> some View {
        content
            .overlay(
                GeometryReader { geometry in
                    Path { path in
                        if sides.contains(.top) {
                            path.move(to: CGPoint(x: 0, y: 0))
                            path.addLine(to: CGPoint(x: geometry.size.width, y: 0))
                        }
                        
                        if sides.contains(.bottom) {
                            path.move(to: CGPoint(x: 0, y: geometry.size.height))
                            path.addLine(to: CGPoint(x: geometry.size.width, y: geometry.size.height))
                        }
                        
                        if sides.contains(.leading) {
                            path.move(to: CGPoint(x: 0, y: 0))
                            path.addLine(to: CGPoint(x: 0, y: geometry.size.height))
                        }
                        
                        if sides.contains(.trailing) {
                            path.move(to: CGPoint(x: geometry.size.width, y: 0))
                            path.addLine(to: CGPoint(x: geometry.size.width, y: geometry.size.height))
                        }
                    }
                    .stroke(color, lineWidth: width)
                }
            )
    }
}

// View extension for easy usage
extension View {
    func border(_ sides: BorderSide, color: Color, width: CGFloat = 1) -> some View {
        modifier(BorderModifier(sides: sides, color: color, width: width))
    }
}
