//
//  ChapterListPanel.swift
//  BasiliskUI
//

import SwiftUI
import BasiliskCore

public struct ChapterListPanel: View {

    public let hierarchy: SyllabusHierarchy?
    @Binding public var selectedChapterID: Set<UUID>     // ← war UUID?
    @Binding public var selectedPartID: Set<UUID>        // ← war UUID?

    public var onAddChapter: (String) -> Void
    public var isEditMode: Bool
    
    public var onEditAction: (EditAction) -> Void

    @State private var expandedParts: Set<UUID> = []
    

    public init(
        hierarchy: SyllabusHierarchy?,
        selectedChapterID: Binding<Set<UUID>>,            // ← war Binding<UUID?>
        selectedPartID: Binding<Set<UUID>>,               // ← war Binding<UUID?>
        onAddChapter: @escaping (String) -> Void,
        isEditMode: Bool = false,
        onEditAction: @escaping (EditAction) -> Void = { _ in }
    ) {
        self.hierarchy = hierarchy
        self._selectedChapterID = selectedChapterID
        self._selectedPartID = selectedPartID
        self.onAddChapter = onAddChapter
        self.isEditMode = isEditMode
        self.onEditAction = onEditAction
    }

    public var body: some View {
        VStack(spacing: 0) {
            Group {
                content   // die bestehende content-Property
            }
            if isEditMode {
                RoyalInkAddCard(placeholder: "Neues Kapitel", icon: "plus") { title in
                    onAddChapter(title)
                }
                .padding(.horizontal, BasiliskSpacing.md)
                .padding(.bottom, BasiliskSpacing.md)
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .background(BasiliskColor.background)
        .animation(.easeInOut(duration: 0.2), value: isEditMode)
        .onChange(of: hierarchy?.course.id) { _, _ in expandAllParts() }
        .onAppear { expandAllParts() }
    }

    @ViewBuilder
    private var content: some View {
        if let hierarchy {
            if hierarchy.allChapters.isEmpty {
                EmptyStateView(
                    icon: "doc.text",
                    title: "Keine Kapitel",
                    message: "Dieser Kurs hat noch keine Kapitel."
                )
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                List(selection: $selectedChapterID) {
                    // Loose Chapters direkt am Kurs
                    ForEach(hierarchy.looseChapters) { chapter in
                        ChapterRow(
                            chapter: chapter,
                            progress: hierarchy.progress(for: chapter)
                        )
                        .tag(chapter.id)
                        .listRowSeparator(.hidden)
                        .contextMenu {
                            chapterContextMenu(for: chapter, in: hierarchy)
                        }
                    }

                    // Parts als aufklappbare Sektionen
                    ForEach(hierarchy.parts) { part in
                        partSection(part: part, hierarchy: hierarchy)
                    }
                }
                .scrollContentBackground(.hidden)
                .scrollIndicators(.never)
                .tint(isEditMode ? BasiliskColor.royalBlue : BasiliskColor.textMuted)
                .editModeFade(isActive: isEditMode)
            }
        } else {
            EmptyStateView(
                icon: "arrow.left",
                title: "Kein Kurs gewählt",
                message: "Wähle links einen Kurs aus."
            )
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }

    // MARK: - Part-Section

    @ViewBuilder
    private func partSection(part: Part, hierarchy: SyllabusHierarchy) -> some View {
        let partChapters = hierarchy.chapters(in: part)
        if !partChapters.isEmpty {
            DisclosureGroup(
                isExpanded: Binding(
                    get: { expandedParts.contains(part.id) },
                    set: { isOpen in
                        if isOpen {
                            expandedParts.insert(part.id)
                        } else {
                            expandedParts.remove(part.id)
                        }
                    }
                )
            ) {
                ForEach(partChapters) { chapter in
                    ChapterRow(
                        chapter: chapter,
                        progress: hierarchy.progress(for: chapter)
                    )
                    .tag(chapter.id)
                    .listRowSeparator(.hidden)
                    .contextMenu {
                        chapterContextMenu(for: chapter, in: hierarchy)
                    }
                }
            } label: {
                Text(part.title)
                    .font(BasiliskFont.standard(12, weight: .semibold))
                    .foregroundStyle(BasiliskColor.textMuted)
                    .contextMenu {
                        Button("Umbenennen") { onEditAction(.renamePart(part)) }
                        Divider()
                        Button("Löschen", role: .destructive) {
                            onEditAction(.deletePart(part))
                        }
                    }
            }
        }
    }
    
    // MARK: - Helpers
    
    /// Kontextmenü für ein Kapitel. Wenn das Kapitel Teil einer
    /// Multi-Selection ist, erscheinen Bulk-Aktionen.
    @ViewBuilder
    private func chapterContextMenu(
        for chapter: Chapter,
        in hierarchy: SyllabusHierarchy
    ) -> some View {
        let isBulk = selectedChapterID.contains(chapter.id) && selectedChapterID.count > 1

        if isBulk {
            let selected = hierarchy.allChapters.filter {
                selectedChapterID.contains($0.id)
            }

            Button("\(selected.count) Kapitel zu Teil zusammenfassen") {
                onEditAction(.groupChapters(selected, hierarchy.course.id))
            }
            Divider()
            Button("\(selected.count) Kapitel löschen", role: .destructive) {
                onEditAction(.deleteChaptersBulk(selected))
            }
        } else {
            Button("Umbenennen") {
                onEditAction(.renameChapter(chapter))
            }
            Divider()
            Button("Löschen", role: .destructive) {
                onEditAction(.deleteChapter(chapter))
            }
        }
    }

    private func expandAllParts() {
        guard let hierarchy else { return }
        expandedParts = Set(hierarchy.parts.map { $0.id })
    }
}

// MARK: - Row

private struct ChapterRow: View {
    let chapter: Chapter
    let progress: Double

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(chapter.title)
                .font(BasiliskFont.standard(13, weight: .medium))
                .foregroundStyle(BasiliskColor.text)

            if progress > 0 {
                ProgressBar(value: progress, height: 3)
            }
        }
        .padding(.vertical, 2)
    }
    
    
}
