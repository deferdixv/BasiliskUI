//
//  DurationPicker.swift
//  BasiliskDesign
//
//  Created by Ferdinand Reichart on 30.09.2026.
//


//
//  DurationPicker.swift
//  BasiliskDesign
//

import SwiftUI

/// Segment-Control für die vier Session-Dauern.
struct DurationPicker: View {
    @Binding var selection: SessionDuration

    var body: some View {
        HStack(spacing: 0) {
            ForEach(SessionDuration.allCases, id: \.self) { duration in
                durationButton(for: duration)
            }
        }
        .background(
            RoundedRectangle(cornerRadius: BasiliskRadius.sm, style: .continuous)
                .fill(BasiliskColor.parchment.opacity(0.35))
        )
        .overlay(
            RoundedRectangle(cornerRadius: BasiliskRadius.sm, style: .continuous)
                .stroke(BasiliskColor.border, lineWidth: 1)
        )
    }

    private func durationButton(for duration: SessionDuration) -> some View {
        let isSelected = duration == selection

        return Button {
            selection = duration
        } label: {
            Text("\(duration.rawValue) min")
                .font(BasiliskFont.standard(12, weight: isSelected ? .semibold : .regular))
                .foregroundStyle(isSelected ? .white : BasiliskColor.text)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 6)
                .background(
                    RoundedRectangle(cornerRadius: BasiliskRadius.sm, style: .continuous)
                        .fill(isSelected ? BasiliskColor.brand : .clear)
                )
                .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

// MARK: - SessionDuration (Mock für Preview)

enum SessionDuration: Int16, CaseIterable, Hashable {
    case short = 35
    case medium = 70
    case long = 100
    case extended = 225
}

#Preview("DurationPicker") {
    struct Wrapper: View {
        @State private var selection: SessionDuration = .medium

        var body: some View {
            ZStack {
                BasiliskColor.background.ignoresSafeArea()
                DurationPicker(selection: $selection)
                    .padding(40)
                    .frame(maxWidth: 480)
            }
        }
    }
    return Wrapper()
}