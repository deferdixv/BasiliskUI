//
//  SecondaryButton.swift
//  BasiliskDesign
//
//  Sekundärer Button — neutral, für Abbrechen, Zurück, Alternativen.
//

import SwiftUI

struct SecondaryButton: View {
    let title: String
    let icon: String?
    let action: () -> Void
    var isDisabled: Bool = false

    init(_ title: String, icon: String? = nil, isDisabled: Bool = false, action: @escaping () -> Void) {
        self.title = title
        self.icon = icon
        self.isDisabled = isDisabled
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            HStack(spacing: BasiliskSpacing.sm) {
                if let icon {
                    Image(systemName: icon)
                }
                Text(title)
                    .font(BasiliskFont.standard(13, weight: .medium))
            }
            .padding(.horizontal, BasiliskSpacing.lg)
            .padding(.vertical, BasiliskSpacing.sm)
            .frame(minHeight: 30)
            .foregroundStyle(BasiliskColor.text)
            .background(
                RoundedRectangle(cornerRadius: BasiliskRadius.md, style: .continuous)
                    .fill(BasiliskColor.surface)
            )
            .overlay(
                RoundedRectangle(cornerRadius: BasiliskRadius.md, style: .continuous)
                    .stroke(BasiliskColor.border, lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
        .opacity(isDisabled ? 0.5 : 1)
        .disabled(isDisabled)
    }
}

#Preview("SecondaryButton") {
    ZStack {
        BasiliskColor.background.ignoresSafeArea()
        VStack(spacing: 16) {
            SecondaryButton("Abbrechen") { }
            SecondaryButton("Bearbeiten", icon: "pencil") { }
            SecondaryButton("Deaktiviert", isDisabled: true) { }
        }
        .padding(40)
    }
}
