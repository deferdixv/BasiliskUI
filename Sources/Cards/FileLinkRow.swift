//
//  FileLinkRow.swift
//  BasiliskDesign
//

import SwiftUI

struct FileLinkRow: View {
    let title: String
    let type: FileTypeIcon
    var trailingIcon: String? = nil

    var body: some View {
        HStack(spacing: BasiliskSpacing.sm) {
            FileTypeIconView(type: type, size: 14, style: .tinted)
            Text(title)
                .font(BasiliskFont.body)
                .foregroundStyle(BasiliskColor.text)
            Spacer()
            if let trailingIcon {
                Image(systemName: trailingIcon)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(BasiliskColor.brand)
            }
        }
    }
}
