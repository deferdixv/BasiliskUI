
//  EmptyStateView.swift
//  BasiliskDesign
//
//  Einheitlicher Leerer-Zustand für Listen, Cards und Tabs.
//

import SwiftUI

public struct EmptyStateView: View {
    public let icon: String
    public let title: String
    public let message: String
    public var action: (title: String, handler: () -> Void)? = nil

    public var body: some View {
        VStack(spacing: BasiliskSpacing.lg) {
            Image(systemName: icon)
                .font(.system(size: 56, weight: .light))
                .foregroundStyle(BasiliskColor.brand.opacity(0.6))

            VStack(spacing: BasiliskSpacing.xs) {
                Text(title)
                    .font(BasiliskFont.sectionTitle)
                    .foregroundStyle(BasiliskColor.text)
                Text(message)
                    .font(BasiliskFont.body)
                    .foregroundStyle(BasiliskColor.textMuted)
                    .multilineTextAlignment(.center)
            }

            if let action {
                PrimaryButton(action.title, action: action.handler)
                    .padding(.top, BasiliskSpacing.sm)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, BasiliskSpacing.xxl)
    }
}

#Preview("EmptyStateView") {
    ZStack {
        BasiliskColor.background.ignoresSafeArea()
        VStack(spacing: 40) {
            EmptyStateView(
                icon: "book.closed",
                title: "Keine Kurse",
                message: "Füge deinen ersten Kurs hinzu, um loszulegen."
            )
            EmptyStateView(
                icon: "checkmark.circle",
                title: "Alles erledigt",
                message: "Keine offenen Aufgaben in dieser Woche.",
                action: ("Neue Aufgabe", { })
            )
        }
        .padding(40)
    }
}
