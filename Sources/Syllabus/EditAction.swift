//
//  EditAction.swift
//  BasiliskUI
//
//  Created by Ferdinand Reichart on 13.10.2026.
//


//
//  EditAction.swift
//  BasiliskUI
//

import Foundation
import BasiliskCore

/// Sammelt alle Aktionen, die aus Kontextmenüs kommen können.
/// Eine einzige Callback-Kette — sauberer als acht separate onXyz-Handler.
public enum EditAction {
    case renameCourse(Course)
    case deleteCourse(Course)

    case renameChapter(Chapter)
    case deleteChapter(Chapter)

    case renameSubchapter(Subchapter)
    case deleteSubchapter(Subchapter)
    case deleteChaptersBulk([Chapter])            // ← NEU
    case groupChapters([Chapter], UUID)

    case renamePart(Part)
    case deletePart(Part)
}

public extension EditAction {
    var targetTitle: String {
        switch self {
        case .renameCourse(let c), .deleteCourse(let c): return c.name
        case .renameChapter(let c), .deleteChapter(let c): return c.title
        case .deleteChaptersBulk(let chapters): return "\(chapters.count) Kapitel"
        case .groupChapters(let chapters, _): return "\(chapters.count) Kapitel"
        case .renameSubchapter(let s), .deleteSubchapter(let s): return s.title
        case .renamePart(let p), .deletePart(let p): return p.title
        }
    }

    var currentValue: String { targetTitle }

    var isDelete: Bool {
        switch self {
        case .deleteCourse, .deleteChapter, .deleteSubchapter, .deletePart,
             .deleteChaptersBulk:
            return true
        case .groupChapters:
            return false
        default:
            return false
        }
    }
}
extension EditAction: Identifiable {
    public var id: String {
        switch self {
        case .renameCourse(let c), .deleteCourse(let c): return "course-\(c.id)-\(isDelete)"
        case .renameChapter(let c), .deleteChapter(let c): return "chapter-\(c.id)-\(isDelete)"
        case .deleteChaptersBulk(let chapters):
            return "bulk-chapters-\(chapters.map(\.id).hashValue)"
        case .groupChapters(let chapters, _):
            return "group-chapters-\(chapters.map(\.id).hashValue)"
        case .renameSubchapter(let s), .deleteSubchapter(let s): return "sub-\(s.id)-\(isDelete)"
        case .renamePart(let p), .deletePart(let p): return "part-\(p.id)-\(isDelete)"
        }
    }
}
