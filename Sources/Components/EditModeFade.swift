//
//  EditModeFade.swift
//  BasiliskUI
//
//  Created by Ferdinand Reichart on 11.10.2026.
//


//
//  EditModeFade.swift
//  BasiliskUI
//
//  Weicher Auslauf am unteren Rand einer Scroll-Liste.
//  Wird im Edit-Mode aktiviert, um Platz für die Add-Karten zu signalisieren.
//

import SwiftUI

public struct EditModeFade: ViewModifier {

    public var isActive: Bool
    public var height: CGFloat

    public init(isActive: Bool, height: CGFloat = 80) {
        self.isActive = isActive
        self.height = height
    }

    public func body(content: Content) -> some View {
        if isActive {
            content.mask(
                VStack(spacing: 0) {
                    Rectangle().fill(.black)
                    LinearGradient(
                        colors: [.black, .clear],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .frame(height: height)
                }
            )
        } else {
            content
        }
    }
}

public extension View {
    /// Blendet den unteren Rand der View weich aus (nur wenn aktiv).
    func editModeFade(isActive: Bool, height: CGFloat = 80) -> some View {
        modifier(EditModeFade(isActive: isActive, height: height))
    }
}