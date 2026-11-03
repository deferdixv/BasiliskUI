//
//  BrandButton.swift
//  BasiliskUI
//

import SwiftUI

public struct BrandButton: View {

    public let title: String
    public let icon: String
    public var showsTitle: Bool
    public let action: () -> Void

    public init(
        title: String,
        icon: String,
        showsTitle: Bool = true,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.icon = icon
        self.showsTitle = showsTitle
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.system(size: 12, weight: .semibold))
                if showsTitle {
                    Text(title)
                        .font(BasiliskFont.standard(12, weight: .semibold))
                }
            }
            .foregroundStyle(.white)
            .padding(.horizontal, showsTitle ? 14 : 10)
            .padding(.vertical, 7)
            .background(
                Capsule(style: .continuous)
                    .fill(BasiliskColor.brand)
            )
        }
        .buttonStyle(.plain)
    }
}
