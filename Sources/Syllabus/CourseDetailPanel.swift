//
//  CourseDetailPanel.swift
//  BasiliskUI
//

import SwiftUI
import BasiliskCore

public struct CourseDetailPanel: View {

    public let course: Course
    public let hierarchy: SyllabusHierarchy
    public var onRevealInFinder: () -> Void
    public var isEditMode: Bool
    public var onAddChapter: (String) -> Void
    public var onEditAction: (EditAction) -> Void
    public var onPickFolder: () -> Void

    public init(
        course: Course,
        hierarchy: SyllabusHierarchy,
        onRevealInFinder: @escaping () -> Void,
        isEditMode: Bool = false,
        onAddChapter: @escaping (String) -> Void = { _ in },
        onEditAction: @escaping (EditAction) -> Void = { _ in },
        onPickFolder: @escaping () -> Void = { }
    ) {
        self.course = course
        self.hierarchy = hierarchy
        self.onRevealInFinder = onRevealInFinder
        self.isEditMode = isEditMode
        self.onAddChapter = onAddChapter
        self.onEditAction = onEditAction
        self.onPickFolder = onPickFolder
    }

    public var body: some View {
        VStack(spacing: 0) {
            NoIndicatorScrollView {
                VStack(alignment: .leading, spacing: BasiliskSpacing.lg) {
                    header
                    progressCard
                    chaptersOverview

                    Color.clear.frame(height: 60)
                }
                .padding(.horizontal, BasiliskLayout.detailOuterPadding)
                .padding(.vertical, BasiliskSpacing.lg)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .scrollIndicators(.never)
            .editModeFade(isActive: isEditMode)

            if isEditMode {
                RoyalInkAddCard(
                    placeholder: "Neues Kapitel",
                    icon: "plus",
                    cornerRadius: BasiliskRadius.lg
                ) { title in
                    onAddChapter(title)
                }
                .padding(.horizontal, BasiliskLayout.detailOuterPadding)
                .padding(.bottom, BasiliskSpacing.md)
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .animation(.easeInOut(duration: 0.2), value: isEditMode)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }

    // MARK: - Header

    private var header: some View {
        HStack(alignment: .firstTextBaseline, spacing: BasiliskSpacing.md) {
            VStack(alignment: .leading, spacing: 2) {
                SerifTitle(text: course.name, size: 34)
                Text(course.courseNumber)
                    .font(BasiliskFont.standard(13))
                    .foregroundStyle(BasiliskColor.textMuted)
            }
            Spacer()

            // Zwei Zustände:
            // - Root-Folder gesetzt → Klick zeigt im Finder
            // - Root-Folder nil    → Klick öffnet Picker
            Button {
                if course.rootFolderPath == nil {
                    onPickFolder()
                } else {
                    onRevealInFinder()
                }
            } label: {
                FileTypeIconView(type: .folder, size: 22, style: .tinted)
                    .opacity(course.rootFolderPath == nil ? 0.45 : 1.0)
            }
            .buttonStyle(.plain)
            .help(course.rootFolderPath == nil ? "Kursordner wählen" : "Im Finder öffnen")
        }
    }

    // MARK: - Progress

    private var progressCard: some View {
        SectionCard(
            title: "Fortschritt",
            trailing: {
                Text("\(Int(hierarchy.courseProgress * 100)) %")
                    .font(BasiliskFont.serif(20, weight: .bold))
                    .foregroundStyle(BasiliskColor.text)
                    .monospacedDigit()
            }
        ) {
            if hierarchy.courseProgress > 0 {
                ProgressBar(value: hierarchy.courseProgress)
            }
            Text("Der Fortschritt berechnet sich aus den abgehakten Schritten aller Kapitel.")
                .font(BasiliskFont.body)
                .foregroundStyle(BasiliskColor.textMuted)
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    // MARK: - Chapters

    private var chaptersOverview: some View {
        SectionCard(title: "Kapitel") {
            VStack(alignment: .leading, spacing: BasiliskSpacing.md) {
                if hierarchy.allChapters.isEmpty {
                    Text("Noch keine Kapitel.")
                        .font(BasiliskFont.body)
                        .foregroundStyle(BasiliskColor.textMuted)
                } else {
                    ForEach(hierarchy.allChapters) { chapter in
                        chapterRow(chapter)
                    }
                }
            }
        }
    }

    private func chapterRow(_ chapter: Chapter) -> some View {
        HStack(spacing: BasiliskSpacing.md) {
            Text(chapter.title)
                .font(BasiliskFont.body)
                .foregroundStyle(BasiliskColor.text)
            Spacer()
            let p = hierarchy.progress(for: chapter)
            if p > 0 {
                Text("\(Int(p * 100)) %")
                    .font(BasiliskFont.serif(13, weight: .bold))
                    .foregroundStyle(BasiliskColor.textMuted)
                    .monospacedDigit()
            }
        }
        .contentShape(Rectangle())
        .contextMenu {
            Button("Umbenennen") { onEditAction(.renameChapter(chapter)) }
            Divider()
            Button("Löschen", role: .destructive) {
                onEditAction(.deleteChapter(chapter))
            }
        }
    }
}
