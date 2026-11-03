//
//  NavIconButton.swift
//  BasiliskUI
//

import SwiftUI

public struct NavIconButton: View {

    public let icon: String
    public var style: Style
    public var help: String?
    public var isDisabled: Bool
    public let action: () -> Void

    public enum Style {
        case plain
        case glass
    }

    public init(
        icon: String,
        style: Style = .glass,
        help: String? = nil,
        isDisabled: Bool = false,
        action: @escaping () -> Void
    ) {
        self.icon = icon
        self.style = style
        self.help = help
        self.isDisabled = isDisabled
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            content
        }
        .buttonStyle(.plain)
        .disabled(isDisabled)
        .opacity(isDisabled ? 0.35 : 1.0)
        .help(help ?? "")
    }

    @ViewBuilder
    private var content: some View {
        switch style {
        case .plain:
            Image(systemName: icon)
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(BasiliskColor.text)
                .frame(width: 28, height: 28)

        case .glass:
            Image(systemName: icon)
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(BasiliskColor.text)
                .frame(width: 30, height: 30)
                .background(
                    RoundedRectangle(cornerRadius: BasiliskRadius.sm, style: .continuous)
                        .fill(.ultraThinMaterial)
                        .overlay(
                            RoundedRectangle(cornerRadius: BasiliskRadius.sm, style: .continuous)
                                .fill(BasiliskColor.parchment.opacity(0.35))
                        )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: BasiliskRadius.sm, style: .continuous)
                        .stroke(.white.opacity(0.15), lineWidth: 1)
                )
        }
    }
}
