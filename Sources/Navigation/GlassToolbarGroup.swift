//
//  GlassToolbarGroup.swift
//  BasiliskUI
//
//  Created by Ferdinand Reichart on 10.10.2026.
//


//
//  GlassToolbarGroup.swift
//  BasiliskUI
//

import SwiftUI

/// Gruppiert Toolbar-Buttons in einer Liquid-Glass-Capsule.
/// Mehrere Gruppen erscheinen nebeneinander als eigene Capsules.
public struct GlassToolbarGroup<Content: View>: View {

    @ViewBuilder public let content: Content

    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    public var body: some View {
        HStack(spacing: 2) {
            content
        }
        .padding(.horizontal, 4)
        .padding(.vertical, 3)
        .background(
            Capsule(style: .continuous)
                .fill(.ultraThinMaterial)
        )
        .overlay(
            Capsule(style: .continuous)
                .stroke(.white.opacity(0.20), lineWidth: 1)
        )
    }
}

/// Vertikaler Trennstrich innerhalb einer Toolbar-Gruppe.
public struct ToolbarDivider: View {
    public init() {}

    public var body: some View {
        Rectangle()
            .fill(Color.primary.opacity(0.15))
            .frame(width: 1, height: 16)
            .padding(.horizontal, 2)
    }
}

#Preview("GlassToolbarGroup") {
    ZStack {
        BasiliskColor.background.ignoresSafeArea()
        HStack(spacing: 12) {
            GlassToolbarGroup {
                NavIconButton(icon: "chevron.left", style: .plain, isDisabled: true) { }
                ToolbarDivider()
                NavIconButton(icon: "chevron.right", style: .plain, isDisabled: true) { }
            }

            GlassToolbarGroup {
                NavIconButton(icon: "pencil", style: .plain) { }
            }

            BrandButton(title: "Per Aspera ad Astra", icon: "star.fill") { }
        }
        .padding(40)
    }
}