//
//  SectionCard.swift
//  BasiliskDesign
//
//  Einheitlicher Card-Container für alle Bereiche.
//  Optionaler Titel + optionale Trailing-Action + Inhalt.
//

import SwiftUI

struct SectionCard<Content: View, Trailing: View>: View {
    let title: String?
    let subtitle: String?
    var tint: Color? = nil
    var tintOpacity: Double = 0.55
    @ViewBuilder let trailing: Trailing
    @ViewBuilder let content: Content

    init(
        title: String? = nil,
        subtitle: String? = nil,
        tint: Color? = nil,
        tintOpacity: Double = 0.55,
        @ViewBuilder trailing: () -> Trailing = { EmptyView() },
        @ViewBuilder content: () -> Content
    ) {
        self.title = title
        self.subtitle = subtitle
        self.tint = tint
        self.tintOpacity = tintOpacity
        self.trailing = trailing()
        self.content = content()
    }

    var body: some View {
        LiquidGlassView(tint: tint, padding: BasiliskSpacing.lg, tintOpacity: tintOpacity) {
            VStack(alignment: .leading, spacing: BasiliskSpacing.md) {
                if title != nil || subtitle != nil {
                    header
                }
                content
            }
        }
    
    }

    @ViewBuilder
    private var header: some View {
        HStack(alignment: .firstTextBaseline, spacing: BasiliskSpacing.sm) {
            VStack(alignment: .leading, spacing: 2) {
                if let title {
                    Text(title)
                        .font(BasiliskFont.sectionTitle)
                        .foregroundStyle(BasiliskColor.text)
                }
                if let subtitle {
                    Text(subtitle)
                        .font(BasiliskFont.caption)
                        .foregroundStyle(BasiliskColor.textMuted)
                }
            }
            Spacer()
            trailing
        }
    }
}
