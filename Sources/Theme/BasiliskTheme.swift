//
//  BasiliskTheme.swift
//  BasiliskDesign
//
//  Zentrale Design-Konstanten für Basilisk.
//  Einzige Quelle der Wahrheit für Farben, Spacing, Radii und Typografie.
//

import SwiftUI



// MARK: - Farben

public enum BasiliskColor {
    // MARK: Marke
    /// Türkisgrün aus dem Logo — Primärakzent.
    public static let brand = Color(red: 86 / 255.0,
                             green: 181 / 255.0,
                             blue: 154 / 255.0)

    /// Pergament — Hintergrund für Cards und Material.
    // MARK: Pergament — drei abgestimmte Stufen
    //

    /// Kräftig und warm — **Standard für alle Cards und Material**.
    public static let parchment = Color(red: 0xE8 / 255.0,
                                 green: 0xD4 / 255.0,
                                 blue: 0xB8 / 255.0)
    /// Gold-Akzent aus dem Logo — für Highlights, Badges, ausgewählte Icons.
    public static let gold = Color(red: 0xD4 / 255.0,
                            green: 0xA8 / 255.0,
                            blue: 0x4A / 255.0)
    /// Königsblau für Edit-Mode-Akzente (Auswahl, Pencil-Icon).
    // MARK: Königsblau — Tinte im Glas
    public static let royalBlueDeep  = Color(red: 0x1E / 255.0, green: 0x2E / 255.0, blue: 0x8A / 255.0)
    public static let royalBlue      = Color(red: 0x2B / 255.0, green: 0x40 / 255.0, blue: 0xB0 / 255.0)
    public static let royalBlueLight = Color(red: 0x6E / 255.0, green: 0x86 / 255.0, blue: 0xE2 / 255.0)
    public static let royalBlueGlow  = Color(red: 0xB6 / 255.0, green: 0xC2 / 255.0, blue: 0xF5 / 255.0)

    // MARK: Semantik
    public static let background = Color(nsColor: .windowBackgroundColor)
    public static let surface    = Color(nsColor: .controlBackgroundColor)
    public static let border     = Color.primary.opacity(0.08)

    // MARK: Text

    /// Haupttext — etwas weicher als reines Schwarz, wirkt auf Pergament ruhiger.
    public static let text = Color(red: 0.20, green: 0.18, blue: 0.15)

    /// Sekundärtext — Labels, Fließtext in Cards.
    public static let textMuted = Color(red: 0.38, green: 0.34, blue: 0.29)

    /// Tertiärtext — Captions, Hinweise.
    public static let textSubtle = Color(red: 0.52, green: 0.47, blue: 0.40)


    // MARK: Status
    public static let success = Color.green
    public static let warning = Color.orange
    public static let danger  = Color.red

    // MARK: Dateitypen (Syllabus)
    public static let fileFolder  = brand
    public static let fileVideo   = Color(red: 0x3B / 255.0, green: 0x82 / 255.0, blue: 0xC4 / 255.0)
    public static let fileDocument = Color(red: 0xE6 / 255.0, green: 0x9A / 255.0, blue: 0x2E / 255.0)
    public static let fileLink    = Color(nsColor: .tertiaryLabelColor)
    public static let fileUnknown = brand.opacity(0.4)
    
}

// MARK: - Spacing

public enum BasiliskSpacing {
    public static let xs: CGFloat  = 4
    public static let sm: CGFloat  = 8
    public static let md: CGFloat  = 12
    public static let lg: CGFloat  = 16
    public static let xl: CGFloat  = 24
    public static let xxl: CGFloat = 32
}

// MARK: - Radii

public enum BasiliskRadius {
    public static let sm: CGFloat  = 6
    public static let md: CGFloat  = 10
    public static let lg: CGFloat  = 16
    public static let xl: CGFloat  = 22
}

// MARK: - Typografie

public enum BasiliskFont {
    
    public static let serifPostScriptName = "SwiftNeueLTPro-BlackCond"
    /// Serifenschrift für Überschriften (Wortmarke, Seitentitel, Karten-Header).
    public static func serif(_ size: CGFloat, weight: Font.Weight = .regular) -> Font {
        .custom(serifPostScriptName, size: size)
            .weight(weight)
    }

    /// Systemschrift für Fließtext, Labels, Buttons.
    public static func standard(_ size: CGFloat, weight: Font.Weight = .regular) -> Font {
        .system(size: size, weight: weight, design: .default)
    }

    /// Kurzschreibweise für die häufigsten Größen.
    public static let cardTitle    = standard(15, weight: .semibold)
    public static let sectionTitle = serif(18, weight: .bold)
    public static let pageTitle    = serif(28, weight: .bold)
    public static let body         = standard(13)
    public static let caption      = standard(11)
}


// MARK: - Schatten

extension View {
    /// Standard-Schatten für Cards und Material.
    public func basiliskShadow() -> some View {
        self.shadow(color: .black.opacity(0.06), radius: 6, x: 0, y: 2)
    }
}
