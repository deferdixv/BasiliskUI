//
//  FileLinkRow.swift
//  BasiliskUI
//

import SwiftUI

public struct FileLinkRow: View {
    public let title: String
    public let type: FileTypeIcon
    public var trailingIcon: String?
    public var onTap: (() -> Void)?

    public init(
        title: String,
        type: FileTypeIcon,
        trailingIcon: String? = nil,
        onTap: (() -> Void)? = nil
    ) {
        self.title = title
        self.type = type
        self.trailingIcon = trailingIcon
        self.onTap = onTap
    }

    public var body: some View {
        HStack(spacing: BasiliskSpacing.sm) {
            FileTypeIconView(type: type, size: 14, style: .tinted)
            Text(title)
                .font(BasiliskFont.body)
                .foregroundStyle(BasiliskColor.text)
                .lineLimit(1)
                .truncationMode(.middle)
            Spacer()
            if let trailingIcon {
                Image(systemName: trailingIcon)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(BasiliskColor.brand)
            }
        }
        .contentShape(Rectangle())
        .onTapGesture { onTap?() }
    }
}
