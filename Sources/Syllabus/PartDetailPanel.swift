//
//  PartDetailPanel.swift
//  BasiliskUI
//
//  Created by Ferdinand Reichart on 07.10.2026.
//


import SwiftUI
import BasiliskCore

public struct PartDetailPanel: View {
    public let part: Part
    
    public var isEditMode: Bool

    public init(part: Part, isEditMode: Bool = false,) {
        self.part = part
        self.isEditMode = isEditMode
    }

    public var body: some View {
        NoIndicatorScrollView {
            VStack(alignment: .leading, spacing: BasiliskSpacing.lg) {
                SerifTitle(text: part.title, size: 34)
                SectionCard(title: "Kapitel") {
                    Text("Kapitel-Übersicht folgt in der nächsten Iteration.")
                        .font(BasiliskFont.body)
                        .foregroundStyle(BasiliskColor.textMuted)
                }
                Color.clear.frame(height: 60)
            }
            .padding(.horizontal, BasiliskLayout.detailOuterPadding)
            .padding(.vertical, BasiliskSpacing.lg)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .scrollIndicators(.never)
        .editModeFade(isActive: isEditMode)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }
}
