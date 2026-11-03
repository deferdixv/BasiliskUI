//
//  FileTypeIcon.swift
//  BasiliskDesign
//
//  Created by Ferdinand Reichart on 26.09.2026.
//


//
//  FileTypeIcon.swift
//  BasiliskDesign
//
//  Icon-Repräsentation für Dateitypen im Syllabus.
//  Ordner, Video, Dokument, Link, unbekannt.
//

import SwiftUI

enum FileTypeIcon: Hashable {
    case folder
    case video
    case document
    case link
    case unknown

    var systemName: String {
        switch self {
        case .folder:   return "folder.fill"
        case .video:    return "play.rectangle.fill"
        case .document: return "doc.text.fill"
        case .link:     return "link"
        case .unknown:  return "questionmark.folder.fill"
        }
    }

    var color: Color {
        switch self {
        case .folder:   return BasiliskColor.brand
        case .video:    return Color(red: 0x3B / 255.0, green: 0x82 / 255.0, blue: 0xC4 / 255.0)
        case .document: return Color(red: 0xE6 / 255.0, green: 0x9A / 255.0, blue: 0x2E / 255.0)
        case .link:     return Color(red: 0x3B / 255.0, green: 0x82 / 255.0, blue: 0xC4 / 255.0)
        case .unknown:  return BasiliskColor.brand.opacity(0.5)
        }
    }
}

/// Das fertige Icon als View — quadratisch, optional mit Hintergrund.
struct FileTypeIconView: View {
    let type: FileTypeIcon
    var size: CGFloat = 20
    var style: Style = .plain

    enum Style {
        case plain          // nur das Symbol
        case tinted         // Symbol auf farbigem Hintergrund, weiß
    }

    var body: some View {
        switch style {
        case .plain:
            Image(systemName: type.systemName)
                .font(.system(size: size, weight: .semibold))
                .foregroundStyle(type.color)
                .frame(width: size * 1.4, height: size * 1.4)

        case .tinted:
            ZStack {
                RoundedRectangle(cornerRadius: size * 0.28, style: .continuous)
                    .fill(type.color)
                Image(systemName: type.systemName)
                    .font(.system(size: size * 0.6, weight: .semibold))
                    .foregroundStyle(.white)
            }
            .frame(width: size * 1.4, height: size * 1.4)
        }
    }
}

#Preview("FileTypeIcon") {
    ZStack {
        BasiliskColor.background.ignoresSafeArea()
        VStack(spacing: 24) {
            HStack(spacing: 16) {
                FileTypeIconView(type: .folder,   size: 24, style: .tinted)
                FileTypeIconView(type: .video,    size: 24, style: .tinted)
                FileTypeIconView(type: .document, size: 24, style: .tinted)
                FileTypeIconView(type: .link,     size: 24, style: .tinted)
                FileTypeIconView(type: .unknown,  size: 24, style: .tinted)
            }
            HStack(spacing: 16) {
                FileTypeIconView(type: .folder,   size: 24, style: .plain)
                FileTypeIconView(type: .video,    size: 24, style: .plain)
                FileTypeIconView(type: .document, size: 24, style: .plain)
                FileTypeIconView(type: .link,     size: 24, style: .plain)
                FileTypeIconView(type: .unknown,  size: 24, style: .plain)
            }
        }
        .padding(40)
    }
}
