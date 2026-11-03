//
//  SerifTitle.swift
//  BasiliskDesign
//
//  Serif-Titel mit automatischer Silbentrennung.
//  Kapselt NSFont / NSParagraphStyle, damit Views nicht mit AppKit hantieren müssen.
//

import SwiftUI
import AppKit

struct SerifTitle: View {
    let text: String
    let size: CGFloat
    var color: Color = BasiliskColor.text
    var hyphenate: Bool = true

    var body: some View {
        if hyphenate {
            Text(attributed)
                .foregroundStyle(color)
                .fixedSize(horizontal: false, vertical: true)
        } else {
            Text(text)
                .font(BasiliskFont.serif(size, weight: .black))
                .foregroundStyle(color)
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    // MARK: - Attributed String mit Silbentrennung

    private var attributed: AttributedString {
        let style = NSMutableParagraphStyle()
        style.hyphenationFactor = 0.9          // 0 = aus, 1 = maximal aggressiv
        style.lineBreakMode = .byWordWrapping
        style.alignment = .left

        let nsFont = NSFont(name: BasiliskFont.serifPostScriptName, size: size)
            ?? .systemFont(ofSize: size, weight: .black)

        let attrs: [NSAttributedString.Key: Any] = [
            .font: nsFont,
            .paragraphStyle: style
        ]

        let nsAttr = NSAttributedString(string: text, attributes: attrs)

        // NSAttributedString → AttributedString
        // `including: \.appKit` ist auf macOS verfügbar und erlaubt den Zugriff
        // auf AppKit-spezifische Attribute.
        return (try? AttributedString(nsAttr, including: \.appKit)) ?? AttributedString(text)
    }
}

#Preview("SerifTitle") {
    ZStack {
        BasiliskColor.background.ignoresSafeArea()
        VStack(alignment: .leading, spacing: 20) {
            SerifTitle(text: "Kapitel 4", size: 34)
            SerifTitle(text: "Taylor-Reihe", size: 34)
            SerifTitle(text: "Eigenwertzerlegung linearer Abbildungen", size: 28)
            SerifTitle(text: "Ohne Silbentrennung", size: 34, hyphenate: false)
        }
        .padding(40)
        .frame(width: 480, alignment: .leading)
    }
}
