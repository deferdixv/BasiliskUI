//
//  InfoEditRow.swift
//  BasiliskDesign
//
//  Created by Ferdinand Reichart on 30.09.2026.
//


//
//  InfoEditRow.swift
//  BasiliskDesign
//

import SwiftUI

/// Gemeinsame Zeile für InfoEditCard: Label links, Control rechts.
/// Alle konkreten Zeilen (Text, Date, Picker) bauen darauf auf.
struct InfoEditRow<Control: View>: View {
    let label: String
    var showsDivider: Bool = true
    @ViewBuilder let control: Control

    init(
        _ label: String,
        showsDivider: Bool = true,
        @ViewBuilder control: () -> Control
    ) {
        self.label = label
        self.showsDivider = showsDivider
        self.control = control()
    }

    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .firstTextBaseline, spacing: BasiliskSpacing.md) {
                Text(label)
                    .font(BasiliskFont.body)
                    .foregroundStyle(BasiliskColor.textMuted)
                    .frame(width: 110, alignment: .leading)

                control
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.vertical, BasiliskSpacing.sm)

            if showsDivider {
                Divider().opacity(0.15)
            }
        }
    }
}

#Preview("InfoEditRow") {
    ZStack {
        BasiliskColor.background.ignoresSafeArea()
        VStack(spacing: 0) {
            InfoEditRow("Titel") {
                TextField("Session Titel (optional)", text: .constant(""))
                    .textFieldStyle(.plain)
            }
            InfoEditRow("Notizen") {
                TextField("Notizen", text: .constant(""))
                    .textFieldStyle(.plain)
            }
            InfoEditRow("URL", showsDivider: false) {
                TextField("URL", text: .constant(""))
                    .textFieldStyle(.plain)
            }
        }
        .padding(24)
        .background(Color.gray.opacity(0.3))
        .cornerRadius(BasiliskRadius.lg)
        .padding(40)
        .frame(maxWidth: 480)
    }
}
