//
//  NavigationBar.swift
//  BasiliskDesign
//
//  Created by Ferdinand Reichart on 28.09.2026.
//


//
//  NavigationBar.swift
//  BasiliskDesign
//
//  Die Liquid-Glass-Navigationsleiste.
//  Layout: [Leading] [Titel] … [Tabs] … [Trailing]
//

import SwiftUI

public struct NavigationBar<Leading: View, Tabs: View, Trailing: View>: View {
    public let title: String
    @ViewBuilder let leading: Leading
    @ViewBuilder let tabs: Tabs
    @ViewBuilder let trailing: Trailing

    public init(
        title: String,
        @ViewBuilder leading: () -> Leading,
        @ViewBuilder tabs: () -> Tabs = { EmptyView() },
        @ViewBuilder trailing: () -> Trailing
    ) {
        self.title = title
        self.leading = leading()
        self.tabs = tabs()
        self.trailing = trailing()
    }

    public var body: some View {
        HStack(spacing: BasiliskSpacing.md) {
            // Links: Sidebar, Zurück, Vor
            HStack(spacing: BasiliskSpacing.sm) {
                leading
            }

            // Titel
            Text(title)
                .font(BasiliskFont.standard(13, weight: .medium))
                .foregroundStyle(BasiliskColor.text)
                .lineLimit(1)
                .truncationMode(.tail)

            Spacer(minLength: BasiliskSpacing.md)

            // Optional: Tabs in der Mitte
            tabs

            // Rechts: EditMode, Per Aspera
            HStack(spacing: BasiliskSpacing.sm) {
                trailing
            }
        }
        .padding(.horizontal, BasiliskSpacing.md)
        .padding(.vertical, BasiliskSpacing.sm)
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

// MARK: - Convenience Init ohne Tabs

extension NavigationBar where Tabs == EmptyView {
    public init(
        title: String,
        @ViewBuilder leading: () -> Leading,
        @ViewBuilder trailing: () -> Trailing
    ) {
        self.init(
            title: title,
            leading: leading,
            tabs: { EmptyView() },
            trailing: trailing
        )
    }
}
