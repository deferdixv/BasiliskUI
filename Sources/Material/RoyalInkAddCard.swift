//
//  RoyalInkAddCard.swift
//  BasiliskUI
//
//  Created by Ferdinand Reichart on 12.10.2026.
//
import SwiftUI
import Foundation

/// Horizontale Königsblau-Glass-Karte mit Inline-Eingabe.
/// Radius und Padding sind so gewählt, dass sie mit einer
/// SubchapterCard bzw. einer List-Selection bündig sind.
public struct RoyalInkAddCard: View {

    public var placeholder: String
    public var icon: String
    public var cornerRadius: CGFloat
    public var onSubmit: (String) -> Void

    @State private var text: String = ""
    @FocusState private var isFocused: Bool

    public init(
        placeholder: String,
        icon: String = "plus",
        cornerRadius: CGFloat = BasiliskRadius.md,   // 10 — passt zu List-Selection
        onSubmit: @escaping (String) -> Void
    ) {
        self.placeholder = placeholder
        self.icon = icon
        self.cornerRadius = cornerRadius
        self.onSubmit = onSubmit
    }

    public var body: some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(BasiliskColor.royalBlue)
                .frame(width: 22, height: 22)
                .background(Circle().fill(.white.opacity(0.55)))

            TextField(placeholder, text: $text)
                .textFieldStyle(.plain)
                .font(BasiliskFont.standard(13, weight: .medium))
                .foregroundStyle(BasiliskColor.text)
                .focused($isFocused)
                .onSubmit {
                    let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
                    guard !trimmed.isEmpty else { return }
                    onSubmit(trimmed)
                    text = ""
                    isFocused = true
                }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .frame(maxWidth: .infinity, alignment: .leading)   // ← volle Breite
        .background { glassBase }
        .overlay { rimLight.allowsHitTesting(false) }
        .clipShape(
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
        )
        .shadow(color: .black.opacity(0.08), radius: 10, y: 4)
        .onTapGesture { isFocused = true }
    }

    @ViewBuilder
    private var glassBase: some View {
        if #available(macOS 26.0, *) {
            Color.clear
                .glassEffect(
                    .regular.tint(BasiliskColor.royalBlue.opacity(0.55)).interactive(),
                    in: .rect(cornerRadius: cornerRadius)
                )
        } else {
            ZStack {
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .fill(.ultraThinMaterial)
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .fill(BasiliskColor.royalBlue.opacity(0.15))
            }
        }
    }

    private var rimLight: some View {
        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
            .strokeBorder(
                LinearGradient(
                    colors: [.white.opacity(0.45), .white.opacity(0.08)],
                    startPoint: .top,
                    endPoint: .bottom
                ),
                lineWidth: 0.8
            )
    }
}
