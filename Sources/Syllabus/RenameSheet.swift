//
//  RenameSheet.swift
//  BasiliskUI
//
//  Created by Ferdinand Reichart on 13.10.2026.
//


//
//  RenameSheet.swift
//  BasiliskUI
//

import SwiftUI

public struct RenameSheet: View {

    public let title: String
    public let placeholder: String
    @Binding public var isPresented: Bool
    public let onSave: (String) -> Void

    @State private var text: String = ""
    @FocusState private var isFocused: Bool

    public init(
        title: String,
        placeholder: String,
        initialValue: String,
        isPresented: Binding<Bool>,
        onSave: @escaping (String) -> Void
    ) {
        self.title = title
        self.placeholder = placeholder
        self._isPresented = isPresented
        self.onSave = onSave
        _text = State(initialValue: initialValue)
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: BasiliskSpacing.lg) {
            Text(title)
                .font(BasiliskFont.sectionTitle)
                .foregroundStyle(BasiliskColor.text)

            TextField(placeholder, text: $text)
                .textFieldStyle(.roundedBorder)
                .font(BasiliskFont.body)
                .focused($isFocused)
                .onSubmit { submit() }

            HStack {
                Spacer()
                SecondaryButton("Abbrechen") {
                    isPresented = false
                }
                PrimaryButton("Speichern", icon: "checkmark") {
                    submit()
                }
                .disabled(text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
        }
        .padding(BasiliskSpacing.xl)
        .frame(width: 400)
        .background(BasiliskColor.background)
        .onAppear {
            isFocused = true
        }
    }

    private func submit() {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        onSave(trimmed)
        isPresented = false
    }
}