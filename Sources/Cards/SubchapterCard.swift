//
//  SubchapterCard.swift
//  BasiliskUI
//

import SwiftUI

/// Millarium-Status-Kreis für eine SubchapterCard.
/// Nicht generisch — nutzbar in jedem Kontext.
enum SubchapterCardStatus {
    /// Kein Kreis (Schublade, Container mit Steps).
    case none
    /// Kreis als reiner Indikator — nicht klickbar.
    case indicator(isCompleted: Bool)
    /// Kreis als Toggle in Brand-Farbe — klickbar.
    case toggle(isCompleted: Bool, action: () -> Void)
}

struct SubchapterCard<Content: View>: View {

    let title: String
    var statusStyle: SubchapterCardStatus = .none
    var onAdd: (() -> Void)? = nil
    @ViewBuilder let content: Content

    init(
        title: String,
        statusStyle: SubchapterCardStatus = .none,
        onAdd: (() -> Void)? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.title = title
        self.statusStyle = statusStyle
        self.onAdd = onAdd
        self.content = content()
    }

    var body: some View {
        SectionCard(
            title: title,
            trailing: {
                HStack(spacing: BasiliskSpacing.sm) {
                    statusView

                    if let onAdd {
                        Button(action: onAdd) {
                            ZStack {
                                Circle()
                                    .fill(BasiliskColor.brand.opacity(0.15))
                                Image(systemName: "plus")
                                    .font(.system(size: 13, weight: .semibold))
                                    .foregroundStyle(BasiliskColor.brand)
                            }
                            .frame(width: 26, height: 26)
                        }
                        .buttonStyle(.plain)
                        .help("Schritt hinzufügen")
                    }
                }
            }
        ) {
            content
        }
    }

    @ViewBuilder
    private var statusView: some View {
        switch statusStyle {
        case .none:
            EmptyView()

        case .indicator(let isCompleted):
            circle(isCompleted: isCompleted, isInteractive: false)

        case .toggle(let isCompleted, let action):
            Button(action: action) {
                circle(isCompleted: isCompleted, isInteractive: true)
            }
            .buttonStyle(.plain)
            .help(isCompleted ? "Als unerledigt markieren" : "Als erledigt markieren")
        }
    }

    private func circle(isCompleted: Bool, isInteractive: Bool) -> some View {
        ZStack {
            Circle()
                .fill(fillColor(isCompleted: isCompleted, isInteractive: isInteractive))
                .frame(width: 22, height: 22)

            if isCompleted {
                Image(systemName: "checkmark")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundStyle(.white)
            }
        }
    }

    private func fillColor(isCompleted: Bool, isInteractive: Bool) -> Color {
        if isCompleted {
            return BasiliskColor.brand
        }
        return isInteractive
            ? BasiliskColor.brand.opacity(0.25)
            : Color.gray.opacity(0.25)
    }
}

#Preview("SubchapterCard") {
    ZStack {
        BasiliskColor.background.ignoresSafeArea()
        VStack(spacing: 20) {
            SubchapterCard(
                title: "Nächste Schritte…",
                statusStyle: .none,
                onAdd: { }
            ) {
                Text("Kein Toggle — Schublade ist immer erledigt.")
                    .font(BasiliskFont.body)
                    .foregroundStyle(BasiliskColor.textMuted)
            }

            SubchapterCard(
                title: "01 Erste Schritte",
                statusStyle: .indicator(isCompleted: true),
                onAdd: { }
            ) {
                Text("Container mit Steps — Häkchen erscheint automatisch.")
                    .font(BasiliskFont.body)
                    .foregroundStyle(BasiliskColor.textMuted)
            }

            SubchapterCard(
                title: "01 Ableitungen",
                statusStyle: .toggle(isCompleted: false, action: { }),
                onAdd: { }
            ) {
                Text("Blatt ohne Steps — Toggle in Brand-Farbe.")
                    .font(BasiliskFont.body)
                    .foregroundStyle(BasiliskColor.textMuted)
            }
        }
        .padding(40)
        .frame(maxWidth: 480)
    }
}
