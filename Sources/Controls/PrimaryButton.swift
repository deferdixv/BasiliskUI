//
//  PrimaryButton.swift
//  BasiliskDesign
//
//  Primärer Aktionsbutton — Brand-Farbe, weiße Schrift.
//

import SwiftUI

struct PrimaryButton: View {
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
                    .font(BasiliskFont.standard(13, weight: .semibold))
            }
            .padding(.horizontal, BasiliskSpacing.lg)
            .padding(.vertical, BasiliskSpacing.sm)
            .frame(minHeight: 30)
            .foregroundStyle(.white)
            .background(
                RoundedRectangle(cornerRadius: BasiliskRadius.md, style: .continuous)
                    .fill(BasiliskColor.brand)
            )
        }
        .buttonStyle(.plain)
        .opacity(isDisabled ? 0.5 : 1)
        .disabled(isDisabled)
    }
}

#Preview("PrimaryButton") {
    ZStack {
        BasiliskColor.background.ignoresSafeArea()
        VStack(spacing: 16) {
            PrimaryButton("Session starten", icon: "play.fill") { }
            PrimaryButton("Speichern") { }
            PrimaryButton("Deaktiviert", isDisabled: true) { }
        }
        .padding(40)
    }
}
