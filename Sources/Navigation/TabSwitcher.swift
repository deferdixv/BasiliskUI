//
//  TabSwitcher.swift
//  BasiliskUI
//

import SwiftUI

public struct TabSwitcher<T>: View
where T: Hashable & CaseIterable & RawRepresentable,
      T.RawValue == String,
      T.AllCases: RandomAccessCollection {

    @Binding public var selection: T
    public var compact: Bool

    public init(selection: Binding<T>, compact: Bool = false) {
        self._selection = selection
        self.compact = compact
    }

    public var body: some View {
        HStack(spacing: 2) {
            ForEach(Array(T.allCases), id: \.self) { tab in
                tabButton(for: tab)
            }
        }
        .padding(3)
        .background(
            Capsule(style: .continuous)
                .fill(.ultraThinMaterial)
        )
        .overlay(
            Capsule(style: .continuous)
                .stroke(.white.opacity(0.20), lineWidth: 1)
        )
    }

    @ViewBuilder
    private func tabButton(for tab: T) -> some View {
        let isSelected = tab == selection

        Button {
            withAnimation(.easeInOut(duration: 0.15)) {
                selection = tab
            }
        } label: {
            Text(tab.rawValue)
                .font(BasiliskFont.standard(
                    compact ? 11 : 12,
                    weight: isSelected ? .semibold : .medium
                ))
                .foregroundStyle(isSelected ? Color.white : BasiliskColor.text)
                .padding(.horizontal, compact ? 10 : 14)
                .padding(.vertical, compact ? 5 : 6)
                .background(
                    Capsule(style: .continuous)
                        .fill(isSelected ? BasiliskColor.brand : Color.clear)
                )
                .contentShape(Capsule())
        }
        .buttonStyle(.plain)
    }
}
