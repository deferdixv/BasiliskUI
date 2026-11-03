//
//  NotesField.swift
//  BasiliskDesign
//
//  Created by Ferdinand Reichart on 26.09.2026.
//


//
//  NotesField.swift
//  BasiliskDesign
//
//  Beschriftetes Freitextfeld mit Header — z. B. für "Kapitel Notizen".
//

import SwiftUI

struct NotesField: View {
    let label: String
    @Binding var text: String
    var placeholder: String = "Notizen…"
    var minHeight: CGFloat = 80
    var isEditable: Bool = true

    var body: some View {
        VStack(alignment: .leading, spacing: BasiliskSpacing.sm) {
            Text(label)
                .font(BasiliskFont.sectionTitle)
                .foregroundStyle(BasiliskColor.text)

            ZStack(alignment: .topLeading) {
                if text.isEmpty {
                    Text(placeholder)
                        .font(BasiliskFont.body)
                        .foregroundStyle(BasiliskColor.textMuted)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 8)
                        .allowsHitTesting(false)
                }

                TextEditor(text: $text)
                    .scrollContentBackground(.hidden)
                    .scrollIndicators(.never)
                    .font(BasiliskFont.body)
                    .foregroundStyle(BasiliskColor.text)
                    .scrollContentBackground(.hidden)
                    .padding(4)
                    .disabled(!isEditable)
            }
            .frame(minHeight: minHeight)
            .background(
                RoundedRectangle(cornerRadius: BasiliskRadius.md, style: .continuous)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: BasiliskRadius.md, style: .continuous)
                            .fill(BasiliskColor.parchment.opacity(0.25))
                    )
            )
            .overlay(
                RoundedRectangle(cornerRadius: BasiliskRadius.md, style: .continuous)
                    .stroke(BasiliskColor.border, lineWidth: 1)
            )
        }
    }
}

#Preview("NotesField") {
    struct PreviewWrapper: View {
        @State private var empty = ""
        @State private var filled = "Gampfus trollige Bätschel seimeln plongwöpfig vopffiks krauer Zwöftras."
        var body: some View {
            ZStack {
                BasiliskColor.background.ignoresSafeArea()
                VStack(spacing: 24) {
                    NotesField(label: "Kapitel Notizen", text: $empty)
                    NotesField(label: "Kapitel Notizen", text: $filled)
                }
                .padding(40)
                .frame(maxWidth: 480)
            }
        }
    }
    return PreviewWrapper()
}
