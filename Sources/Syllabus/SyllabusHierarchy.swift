//
//  SyllabusHierarchy.swift
//  BasiliskUI
//

import Foundation
import BasiliskCore

public struct SyllabusHierarchy {

    public let course: Course
    public let parts: [Part]
    public let chapters: [Chapter]
    public let subchapters: [Subchapter]
    public let steps: [Step]

    public init(
        course: Course,
        parts: [Part],
        chapters: [Chapter],
        subchapters: [Subchapter] = [],
        steps: [Step] = []
    ) {
        self.course = course
        self.parts = parts.sorted { $0.order < $1.order }
        self.chapters = chapters.sorted { $0.order < $1.order }
        self.subchapters = subchapters.sorted { $0.order < $1.order }
        self.steps = steps.sorted { $0.order < $1.order }
    }

    // MARK: - Chapters

    public func chapters(in part: Part) -> [Chapter] {
        chapters
            .filter { $0.partID == part.id }
            .sorted { $0.order < $1.order }
    }

    /// Chapters, die weder unter einem Part hängen noch verwaist sind.
    public var looseChapters: [Chapter] {
        chapters.filter { $0.partID == nil }.sorted { $0.order < $1.order }
    }

    /// Alle Chapters — sowohl direkt als auch unter Parts.
    public var allChapters: [Chapter] {
        looseChapters + parts.flatMap { chapters(in: $0) }
    }

    // MARK: - Subchapters / Steps

    public func subchapters(in chapterID: UUID) -> [Subchapter] {
        subchapters
            .filter { $0.chapterID == chapterID }
            .sorted { $0.order < $1.order }
    }

    public func steps(in subchapterID: UUID) -> [Step] {
        steps
            .filter { $0.subchapterID == subchapterID }
            .sorted { $0.order < $1.order }
    }

    // MARK: - Progress

    /// Millarium-Regeln:
    /// - Schublade ("Nächste Schritte…"): immer erledigt (kein Lernziel)
    /// - Blatt (keine Steps): eigener isCompleted-Status
    /// - Container (mit Steps): Durchschnitt der Steps
    public func progress(for subchapter: Subchapter) -> Double {
        // 1. Schublade ist immer "erledigt"
        if isDrawer(subchapter) {
                let siblings = subchapters(in: subchapter.chapterID ?? UUID())
                    .filter { !isDrawer($0) }
                return siblings.isEmpty ? 0.0 : 1.0
            }

        let own = steps(in: subchapter.id)

        // 2. Blatt: eigener Status
        if own.isEmpty {
            return subchapter.isCompleted ? 1.0 : 0.0
        }

        // 3. Container: Durchschnitt der Steps
        let done = own.filter { $0.isCompleted }.count
        return Double(done) / Double(own.count)
    }

    /// Ist dieses Subchapter die "Nächste Schritte…"-Schublade?
    public func isDrawer(_ subchapter: Subchapter) -> Bool {
        subchapter.title.hasPrefix("Nächste Schritte")
    }

    /// Fortschritt eines Kapitels: Durchschnitt seiner Subchapters.
    public func progress(for chapter: Chapter) -> Double {
        let subs = subchapters(in: chapter.id)
        guard !subs.isEmpty else { return 0 }
        let sum = subs.map { progress(for: $0) }.reduce(0, +)
        return sum / Double(subs.count)
    }

    /// Fortschritt des Kurses: Durchschnitt aller Kapitel.
    public var courseProgress: Double {
        let all = allChapters
        guard !all.isEmpty else { return 0 }
        let sum = all.map { progress(for: $0) }.reduce(0, +)
        return sum / Double(all.count)
    }
}
