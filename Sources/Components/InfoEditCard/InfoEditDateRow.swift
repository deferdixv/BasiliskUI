//
//  InfoEditDateRow.swift
//  BasiliskDesign
//
//  Created by Ferdinand Reichart on 30.09.2026.
//


//
//  InfoEditDateRow.swift
//  BasiliskDesign
//

import SwiftUI

/// Zeile mit Label und DatePicker (Datum, optional Uhrzeit).
struct InfoEditDateRow: View {
    let label: String
    @Binding var date: Date
    var showsTime: Bool = true
    var showsDivider: Bool = true

    private var components: DatePicker.Components {
        showsTime ? [.date, .hourAndMinute] : [.date]
    }

    var body: some View {
        InfoEditRow(label, showsDivider: showsDivider) {
            DatePicker("", selection: $date, displayedComponents: components)
                .datePickerStyle(.compact)
                .labelsHidden()
        }
    }
}

#Preview("InfoEditDateRow") {
    struct Wrapper: View {
        @State private var date = Date()

        var body: some View {
            ZStack {
                BasiliskColor.background.ignoresSafeArea()
                VStack(spacing: 0) {
                    InfoEditDateRow(label: "Datum & Zeit", date: $date)
                    InfoEditDateRow(label: "Datum", date: $date, showsTime: false, showsDivider: false)
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