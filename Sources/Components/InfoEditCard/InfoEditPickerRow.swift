//
//  InfoEditPickerRow.swift
//  BasiliskDesign
//
//  Created by Ferdinand Reichart on 30.09.2026.
//


//
//  InfoEditPickerRow.swift
//  BasiliskDesign
//

import SwiftUI

/// Zeile mit Label und Picker.
/// Generisch über einen Wert-Typ, der Hashable ist.
struct InfoEditPickerRow<T: Hashable>: View {
    let label: String
    @Binding var selection: T
    let options: [(value: T, label: String)]
    var showsDivider: Bool = true

    var body: some View {
        InfoEditRow(label, showsDivider: showsDivider) {
            Picker("", selection: $selection) {
                ForEach(Array(options.enumerated()), id: \.offset) { _, option in
                    Text(option.label).tag(option.value)
                }
            }
            .pickerStyle(.menu)
            .labelsHidden()
        }
    }
}

#Preview("InfoEditPickerRow") {
    struct Wrapper: View {
        @State private var course: String? = nil

        var body: some View {
            ZStack {
                BasiliskColor.background.ignoresSafeArea()
                InfoEditPickerRow(
                    label: "Kurs",
                    selection: $course,
                    options: [
                        (value: nil as String?, label: "Kein Kurs"),
                        (value: "math" as String?, label: "Mathematik I"),
                        (value: "chem" as String?, label: "Organische Chemie"),
                    ],
                    showsDivider: false
                )
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