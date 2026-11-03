//
//  InfoEditTextRow.swift
//  BasiliskDesign
//
//  Created by Ferdinand Reichart on 30.09.2026.
//


//
//  InfoEditTextRow.swift
//  BasiliskDesign
//

import SwiftUI

/// Zeile mit Label und Textfeld.
struct InfoEditTextRow: View {
    let label: String
    let placeholder: String
    @Binding var text: String
    var isMultiline: Bool = false
    var showsDivider: Bool = true

    var body: some View {
        InfoEditRow(label, showsDivider: showsDivider) {
            if isMultiline {
                TextField(placeholder, text: $text, axis: .vertical)
                    .textFieldStyle(.plain)
                    .lineLimit(2...6)
            } else {
                TextField(placeholder, text: $text)
                    .textFieldStyle(.plain)
            }
        }
    }
}

#Preview("InfoEditTextRow") {
    struct Wrapper: View {
        @State private var title = ""
        @State private var notes = ""
        @State private var url = ""

        var body: some View {
            ZStack {
                BasiliskColor.background.ignoresSafeArea()
                VStack(spacing: 0) {
                    InfoEditTextRow(label: "Titel", placeholder: "Session Titel (optional)", text: $title)
                    InfoEditTextRow(label: "Notizen", placeholder: "Notizen", text: $notes, isMultiline: true)
                    InfoEditTextRow(label: "URL", placeholder: "URL", text: $url, showsDivider: false)
                }
                .padding(24)
                .background(BasiliskColor.parchment.opacity(0.4))
                .cornerRadius(BasiliskRadius.lg)
                .padding(40)
                .frame(maxWidth: 480)
            }
        }
    }
    return Wrapper()
}