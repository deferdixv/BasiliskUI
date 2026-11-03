////
//  LiquidGlassView.swift
//  BasiliskDesign
//
//  "Liquid Glass" — das Material für alle Basilisk-Container.
//  Standard-Tint ist das kräftige Pergament aus dem Theme.
//  Ohne Argumente sieht jede Card genauso aus wie die Referenz.
//

import SwiftUI

struct LiquidGlassView<Content: View>: View {
    /// Optionaler Tint. `nil` = kräftiges Pergament (Standard).
    var tint: Color? = nil
    var radius: CGFloat = BasiliskRadius.lg
    var padding: CGFloat = 0
    var tintOpacity: Double = 0.40
    @ViewBuilder let content: Content

    init(
        tint: Color? = nil,
        radius: CGFloat = BasiliskRadius.lg,
        padding: CGFloat = 0,
        tintOpacity: Double = 0.40,
        @ViewBuilder content: () -> Content
    ) {
        self.tint = tint
        self.radius = radius
        self.padding = padding
        self.tintOpacity = tintOpacity
        self.content = content()
    }

    private var resolvedTint: Color {
        tint ?? BasiliskColor.parchment
    }

    var body: some View {
        content
            .padding(padding)
            .background(
                RoundedRectangle(cornerRadius: radius, style: .continuous)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: radius, style: .continuous)
                            .fill(resolvedTint.opacity(tintOpacity))
                    )
            )
            .overlay(
                RoundedRectangle(cornerRadius: radius, style: .continuous)
                    .stroke(
                        LinearGradient(
                            colors: [.white.opacity(0.30), .clear, .white.opacity(0.10)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
            )
            .basiliskShadow()
    }
}

// MARK: - Previews

#Preview("LiquidGlassView — Opacity-Stufen") {
    ZStack {
        BasiliskColor.background.ignoresSafeArea()
        VStack(spacing: 16) {
            LiquidGlassView(padding: 16) {
                Text("Standard (0.40)").font(BasiliskFont.body)
            }
        }
        .padding(40)
    }
}


