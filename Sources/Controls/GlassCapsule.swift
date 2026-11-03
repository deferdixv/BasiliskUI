//
//  GlassCapsule.swift
//  BasiliskDesign
//
//  Created by Ferdinand Reichart on 28.09.2026.
//


//
//  GlassCapsule.swift
//  BasiliskDesign
//
//  Liquid-Glass-Pille ohne Tönung — halbrunde Kanten.
//

import SwiftUI

struct GlassCapsule<Content: View>: View {
    var horizontalPadding: CGFloat = BasiliskSpacing.md
    var verticalPadding: CGFloat = BasiliskSpacing.sm
    @ViewBuilder let content: Content

    init(
        horizontalPadding: CGFloat = BasiliskSpacing.md,
        verticalPadding: CGFloat = BasiliskSpacing.sm,
        @ViewBuilder content: () -> Content
    ) {
        self.horizontalPadding = horizontalPadding
        self.verticalPadding = verticalPadding
        self.content = content()
    }

    var body: some View {
        content
            .padding(.horizontal, horizontalPadding)
            .padding(.vertical, verticalPadding)
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

#Preview("GlassCapsule") {
    ZStack {
        BasiliskColor.background.ignoresSafeArea()
        VStack(spacing: 20) {
            GlassCapsule {
                Text("Sessionen").font(BasiliskFont.body)
            }
            GlassCapsule {
                HStack(spacing: 6) {
                    Image(systemName: "star.fill")
                    Text("Per Aspera ad Astra")
                }
                .font(BasiliskFont.body)
            }
        }
        .padding(40)
    }
}