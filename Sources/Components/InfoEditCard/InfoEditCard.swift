//
//  InfoEditCard.swift
//  BasiliskDesign
//

import SwiftUI

struct InfoEditCard<Content: View, Footer: View>: View {
    @Environment(\.effectiveContentWidth) private var effectiveContentWidth

    let title: String
    var subtitle: String? = nil
    @ViewBuilder let content: Content
    @ViewBuilder let footer: Footer

    /// Die Breite ist die effektive Content-Breite abzüglich des linken Paddings,
    /// das die Content-Views durch `PlanSkeleton` bekommen. Damit ist die Karte
    /// links bündig mit dem Content und rechts bündig mit dem Panel-Divider.
    private var cardWidth: CGFloat {
        let leftInset = CGFloat(4)
        return max(320, effectiveContentWidth - leftInset)
    }

    init(
        title: String,
        subtitle: String? = nil,
        @ViewBuilder content: () -> Content,
        @ViewBuilder footer: () -> Footer
    ) {
        self.title = title
        self.subtitle = subtitle
        self.content = content()
        self.footer = footer()
    }

    var body: some View {
        LiquidGlassView(tint: Color.gray.opacity(0.05), padding: BasiliskSpacing.lg, tintOpacity: 0.02) {
            VStack(alignment: .leading, spacing: BasiliskSpacing.md) {
                header
                Divider().opacity(0.2)

                ScrollView(.vertical, showsIndicators: false) {
                    content
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .frame(maxHeight: 460)

                Divider().opacity(0.2)

                HStack(spacing: BasiliskSpacing.sm) {
                    Spacer()
                    footer
                }
            }
        }
        .frame(width: cardWidth - 12)
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(title)
                .font(BasiliskFont.serif(28, weight: .black))
                .foregroundStyle(BasiliskColor.text)
            if let subtitle {
                Text(subtitle)
                    .font(BasiliskFont.caption)
                    .foregroundStyle(BasiliskColor.textMuted)
            }
        }
    }
}
