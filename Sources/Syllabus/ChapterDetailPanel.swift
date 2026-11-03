//
//  ChapterDetailPanel.swift
//  BasiliskUI
//

import SwiftUI
import BasiliskCore
import AppKit

public struct ChapterDetailPanel: View {

    public let chapter: Chapter
    public let hierarchy: SyllabusHierarchy
    public var onToggleStep: (Step) -> Void
    public var onToggleSubchapter: (Subchapter) -> Void
    public var isEditMode: Bool
    public var onAddSubchapter: (String) -> Void
    public var onAddStep: (String, UUID) -> Void
    public var onEditAction: (EditAction) -> Void
    public var onRevealInFinder: () -> Void
    public var onAddFileLink: (String, URL, UUID) -> Void
    public var onDeleteStep: (Step) -> Void
    public var onUpdateStepNotes: (Step, String) -> Void
    public var onDeleteFileLink: (FileLinkItem) -> Void

    @State private var addingToSubchapterID: UUID?
    @State private var newStepTitle: String = ""
    @FocusState private var isStepFieldFocused: Bool

    @State private var editingNotesStepID: UUID?
    @State private var notesDraft: String = ""

    @State private var pendingDrop: PendingDrop?
    @State private var hoveredStepID: UUID?

    public struct PendingDrop: Identifiable {
        public let id = UUID()
        public let stepID: UUID
        public let url: URL
    }

    public init(
        chapter: Chapter,
        hierarchy: SyllabusHierarchy,
        onToggleStep: @escaping (Step) -> Void,
        onToggleSubchapter: @escaping (Subchapter) -> Void,
        isEditMode: Bool = false,
        onAddSubchapter: @escaping (String) -> Void = { _ in },
        onAddStep: @escaping (String, UUID) -> Void = { _, _ in },
        onEditAction: @escaping (EditAction) -> Void = { _ in },
        onRevealInFinder: @escaping () -> Void = { },
        onAddFileLink: @escaping (String, URL, UUID) -> Void = { _, _, _ in },
        onDeleteStep: @escaping (Step) -> Void = { _ in },
        onUpdateStepNotes: @escaping (Step, String) -> Void = { _, _ in },
        onDeleteFileLink: @escaping (FileLinkItem) -> Void = { _ in }
    ) {
        self.chapter = chapter
        self.hierarchy = hierarchy
        self.onToggleStep = onToggleStep
        self.onToggleSubchapter = onToggleSubchapter
        self.isEditMode = isEditMode
        self.onAddSubchapter = onAddSubchapter
        self.onAddStep = onAddStep
        self.onEditAction = onEditAction
        self.onRevealInFinder = onRevealInFinder
        self.onAddFileLink = onAddFileLink
        self.onDeleteStep = onDeleteStep
        self.onUpdateStepNotes = onUpdateStepNotes
        self.onDeleteFileLink = onDeleteFileLink
    }

    public var body: some View {
        VStack(spacing: 0) {
            NoIndicatorScrollView {
                VStack(alignment: .leading, spacing: BasiliskSpacing.lg) {
                    header
                    progressCard

                    ForEach(hierarchy.subchapters(in: chapter.id)) { sub in
                        subchapterCard(for: sub)
                    }

                    Color.clear.frame(height: 60)
                }
                .padding(.horizontal, BasiliskLayout.detailOuterPadding)
                .padding(.vertical, BasiliskSpacing.lg)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .scrollIndicators(.never)
            .editModeFade(isActive: isEditMode)

            if isEditMode {
                addSubchapterBar
            }
        }
        .animation(.easeInOut(duration: 0.2), value: isEditMode)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .sheet(item: $pendingDrop) { drop in
            pendingDropSheet(for: drop)
        }
    }

    // MARK: - Sub-Bausteine (Body)

    private var addSubchapterBar: some View {
        RoyalInkAddCard(
            placeholder: "Neues Unterkapitel",
            icon: "plus",
            cornerRadius: BasiliskRadius.lg
        ) { title in
            onAddSubchapter(title)
        }
        .padding(.horizontal, BasiliskLayout.detailOuterPadding)
        .padding(.bottom, BasiliskSpacing.md)
        .transition(.move(edge: .bottom).combined(with: .opacity))
    }

    @ViewBuilder
    private func pendingDropSheet(for drop: PendingDrop) -> some View {
        let initialTitle = drop.url.deletingPathExtension().lastPathComponent
        let initialPath = drop.url.isFileURL
            ? drop.url.path
            : drop.url.absoluteString

        FileLinkDialog(
            isPresented: Binding(
                get: { pendingDrop != nil },
                set: { if !$0 { pendingDrop = nil } }
            ),
            initialTitle: initialTitle,
            initialPath: initialPath
        ) { title, pathString, _ in
            let resolved: URL
            if let url = URL(string: pathString), url.scheme != nil {
                resolved = url
            } else {
                resolved = URL(fileURLWithPath: pathString)
            }
            onAddFileLink(title, resolved, drop.stepID)
            pendingDrop = nil
        }
    }

    // MARK: - Header

    private var header: some View {
        HStack(alignment: .firstTextBaseline, spacing: BasiliskSpacing.md) {
            SerifTitle(text: chapter.title, size: 34)
            Spacer()
            Button(action: onRevealInFinder) {
                FileTypeIconView(type: .folder, size: 22, style: .tinted)
            }
            .buttonStyle(.plain)
            .help("Im Finder öffnen")
        }
    }

    private var progressCard: some View {
        SectionCard(
            title: "Fortschritt",
            trailing: {
                Text("\(Int(hierarchy.progress(for: chapter) * 100)) %")
                    .font(BasiliskFont.serif(20, weight: .bold))
                    .foregroundStyle(BasiliskColor.text)
                    .monospacedDigit()
            }
        ) {
            if hierarchy.progress(for: chapter) > 0 {
                ProgressBar(value: hierarchy.progress(for: chapter))
            }
            Text("Hake Schritte ab, um den Fortschritt zu erhöhen.")
                .font(BasiliskFont.body)
                .foregroundStyle(BasiliskColor.textMuted)
        }
    }

    // MARK: - Subchapter

    private func subchapterCard(for sub: Subchapter) -> some View {
        let subSteps = hierarchy.steps(in: sub.id)
        let isDrawer = hierarchy.isDrawer(sub)
        let style = statusStyle(for: sub, steps: subSteps, isDrawer: isDrawer)
        let isAddingHere = addingToSubchapterID == sub.id

        return SubchapterCard(
            title: sub.title,
            statusStyle: style,
            onAdd: {
                if isAddingHere { cancelAddStep() }
                else { beginAddStep(in: sub.id) }
            }
        ) {
            subchapterContent(
                for: sub,
                subSteps: subSteps,
                isDrawer: isDrawer,
                isAddingHere: isAddingHere
            )
        }
        .contentShape(Rectangle())
        .contextMenu {
            Button("Umbenennen") { onEditAction(.renameSubchapter(sub)) }
            Divider()
            Button("Löschen", role: .destructive) {
                onEditAction(.deleteSubchapter(sub))
            }
        }
    }

    @ViewBuilder
    private func subchapterContent(
        for sub: Subchapter,
        subSteps: [Step],
        isDrawer: Bool,
        isAddingHere: Bool
    ) -> some View {
        VStack(alignment: .leading, spacing: BasiliskSpacing.lg) {
            if subSteps.isEmpty && !isAddingHere {
                emptySubchapterPlaceholder(isDrawer: isDrawer)
            } else {
                stepsList(subSteps)
            }

            if isAddingHere {
                if !subSteps.isEmpty { Divider().opacity(0.3) }
                newStepField
            }
        }
    }

    @ViewBuilder
    private func emptySubchapterPlaceholder(isDrawer: Bool) -> some View {
        if isDrawer {
            Text("Gibt wohl nichts zu tun? ;-)")
                .font(BasiliskFont.body)
                .foregroundStyle(BasiliskColor.textMuted)
        } else {
            Text("Noch keine Schritte — hake das Unterkapitel ab, wenn es fertig ist.")
                .font(BasiliskFont.body)
                .foregroundStyle(BasiliskColor.textMuted)
        }
    }

    @ViewBuilder
    private func stepsList(_ steps: [Step]) -> some View {
        ForEach(Array(steps.enumerated()), id: \.element.id) { idx, step in
            if idx > 0 {
                Divider().opacity(0.3)
            }
            stepRow(for: step)
        }
    }

    // MARK: - Step Row (mit Drop + FileLinks)

    private func stepRow(for step: Step) -> some View {
        let isEditingNotes = editingNotesStepID == step.id
        let isHovered = hoveredStepID == step.id

        return VStack(alignment: .leading, spacing: BasiliskSpacing.sm) {
            stepHeader(for: step, isEditingNotes: isEditingNotes)
            stepFileLinks(for: step)
            stepNotesFooter(for: step, isEditingNotes: isEditingNotes)
        }
        .padding(8)
        .background(rowBackground(isHovered: isHovered))
        .overlay(rowBorder(isHovered: isHovered))
        .contentShape(Rectangle())
        .dropDestination(for: URL.self) { urls, _ in
            handleDrop(urls: urls, step: step)
        } isTargeted: { targeted in
            hoveredStepID = targeted ? step.id : nil
        }
        .contextMenu {
            Button("Notiz bearbeiten") { beginEditNotes(for: step) }
            if isEditMode {
                Divider()
                Button("Löschen", role: .destructive) { onDeleteStep(step) }
            }
        }
    }

    @ViewBuilder
    private func stepHeader(for step: Step, isEditingNotes: Bool) -> some View {
        HStack(alignment: .top, spacing: BasiliskSpacing.md) {
            stepToggleButton(for: step, isEditingNotes: isEditingNotes)
            Spacer()
            if isEditMode {
                stepTrashButton(for: step)
            }
        }
    }

    private func stepToggleButton(for step: Step, isEditingNotes: Bool) -> some View {
        Button {
            onToggleStep(step)
        } label: {
            stepToggleLabel(for: step, isEditingNotes: isEditingNotes)
        }
        .buttonStyle(.plain)
    }

    private func stepToggleLabel(for step: Step, isEditingNotes: Bool) -> some View {
        HStack(alignment: .top, spacing: BasiliskSpacing.md) {
            statusCircle(for: step)
            stepTitleStack(for: step, isEditingNotes: isEditingNotes)
        }
        .contentShape(Rectangle())
    }

    @ViewBuilder
    private func stepTitleStack(for step: Step, isEditingNotes: Bool) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            stepTitleText(step)
            if let notes = step.notes, !notes.isEmpty, !isEditingNotes {
                stepNotesPreview(notes)
            }
        }
    }

    private func stepTitleText(_ step: Step) -> some View {
        Text(step.title)
            .font(BasiliskFont.standard(14, weight: .semibold))
            .foregroundStyle(BasiliskColor.text)
            .strikethrough(step.isCompleted, color: BasiliskColor.textMuted)
            .multilineTextAlignment(.leading)
    }

    private func stepNotesPreview(_ notes: String) -> some View {
        Text(notes)
            .font(BasiliskFont.body)
            .foregroundStyle(BasiliskColor.textMuted)
            .multilineTextAlignment(.leading)
    }

    private func stepTrashButton(for step: Step) -> some View {
        Button {
            onDeleteStep(step)
        } label: {
            Image(systemName: "trash")
                .font(.system(size: 12, weight: .medium))
                .foregroundStyle(BasiliskColor.danger)
                .frame(width: 22, height: 22)
        }
        .buttonStyle(.plain)
        .help("Schritt löschen")
    }

    private func statusCircle(for step: Step) -> some View {
        let fill = step.isCompleted ? BasiliskColor.success : Color.gray.opacity(0.25)
        return ZStack {
            Circle()
                .fill(fill)
                .frame(width: 20, height: 20)
            if step.isCompleted {
                Image(systemName: "checkmark")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundStyle(.white)
            }
        }
    }

    // MARK: - FileLinks

    @ViewBuilder
    private func stepFileLinks(for step: Step) -> some View {
        if !step.fileLinks.isEmpty {
            VStack(alignment: .leading, spacing: 4) {
                ForEach(step.fileLinks) { link in
                    fileLinkRow(link: link)
                }
            }
        }
    }

    private func fileLinkRow(link: FileLinkItem) -> some View {
        let icon = FileTypeIcon(rawValue: link.iconRaw) ?? .unknown
        let trailing = isEditMode ? "xmark.circle.fill" : "arrow.up.right.square"

        return FileLinkRow(
            title: link.title,
            type: icon,
            trailingIcon: trailing,
            onTap: { handleFileLinkTap(link: link) }
        )
        .padding(.leading, 32)
    }

    private func handleFileLinkTap(link: FileLinkItem) {
        if isEditMode {
            onDeleteFileLink(link)
            return
        }
        if let url = URL(string: link.urlString), url.scheme != nil {
            NSWorkspace.shared.open(url)
        } else {
            NSWorkspace.shared.open(URL(fileURLWithPath: link.urlString))
        }
    }

    // MARK: - Notes Editor

    @ViewBuilder
    private func stepNotesFooter(for step: Step, isEditingNotes: Bool) -> some View {
        if isEditingNotes {
            stepNotesEditor(for: step)
        } else if isEditMode {
            stepEditNotesButton(for: step)
        }
    }

    private func stepEditNotesButton(for step: Step) -> some View {
        Button {
            beginEditNotes(for: step)
        } label: {
            HStack(spacing: 4) {
                Image(systemName: "square.and.pencil")
                    .font(.system(size: 10))
                Text(step.notes == nil ? "Notiz hinzufügen" : "Notiz bearbeiten")
                    .font(BasiliskFont.caption)
            }
            .foregroundStyle(BasiliskColor.textMuted)
        }
        .buttonStyle(.plain)
        .padding(.leading, 32)
    }

    private func stepNotesEditor(for step: Step) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            TextEditor(text: $notesDraft)
                .font(BasiliskFont.body)
                .scrollContentBackground(.hidden)
                .frame(minHeight: 50)
                .padding(6)
                .background(notesEditorBackground)
                .overlay(notesEditorBorder)

            notesEditorActions(for: step)
        }
        .padding(.leading, 32)
    }

    private var notesEditorBackground: some View {
        RoundedRectangle(cornerRadius: BasiliskRadius.sm, style: .continuous)
            .fill(BasiliskColor.parchment.opacity(0.35))
    }

    private var notesEditorBorder: some View {
        RoundedRectangle(cornerRadius: BasiliskRadius.sm, style: .continuous)
            .stroke(BasiliskColor.border, lineWidth: 1)
    }

    private func notesEditorActions(for step: Step) -> some View {
        HStack {
            Button("Abbrechen") { cancelEditNotes() }
                .buttonStyle(.plain)
                .foregroundStyle(BasiliskColor.textMuted)
                .font(BasiliskFont.caption)
            Spacer()
            Button("Speichern") {
                onUpdateStepNotes(step, notesDraft)
                cancelEditNotes()
            }
            .buttonStyle(.plain)
            .foregroundStyle(BasiliskColor.brand)
            .font(BasiliskFont.caption.weight(.semibold))
        }
    }

    // MARK: - Row-Decoration

    private func rowBackground(isHovered: Bool) -> some View {
        let fill = isHovered ? BasiliskColor.brand.opacity(0.08) : Color.clear
        return RoundedRectangle(cornerRadius: BasiliskRadius.sm, style: .continuous)
            .fill(fill)
    }

    private func rowBorder(isHovered: Bool) -> some View {
        let stroke = isHovered ? BasiliskColor.brand : Color.clear
        return RoundedRectangle(cornerRadius: BasiliskRadius.sm, style: .continuous)
            .stroke(stroke, lineWidth: 1.5)
    }

    // MARK: - Drop Handling

    private func handleDrop(urls: [URL], step: Step) -> Bool {
        guard let url = urls.first else { return false }
        pendingDrop = PendingDrop(stepID: step.id, url: url)
        hoveredStepID = nil
        return true
    }

    // MARK: - New Step Field

    private var newStepField: some View {
        HStack(spacing: BasiliskSpacing.md) {
            Image(systemName: "plus.circle.fill")
                .font(.system(size: 15))
                .foregroundStyle(BasiliskColor.brand)

            TextField("Neuer Schritt…", text: $newStepTitle)
                .textFieldStyle(.plain)
                .font(BasiliskFont.standard(14))
                .foregroundStyle(BasiliskColor.text)
                .focused($isStepFieldFocused)
                .onSubmit { commitNewStep() }

            Button { cancelAddStep() } label: {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 14))
                    .foregroundStyle(BasiliskColor.textMuted)
            }
            .buttonStyle(.plain)
        }
        .padding(.vertical, 4)
    }

    private func beginAddStep(in subchapterID: UUID) {
        addingToSubchapterID = subchapterID
        newStepTitle = ""
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            isStepFieldFocused = true
        }
    }

    private func commitNewStep() {
        guard let id = addingToSubchapterID else { return }
        let title = newStepTitle.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !title.isEmpty else { cancelAddStep(); return }
        onAddStep(title, id)
        newStepTitle = ""
        isStepFieldFocused = true
    }

    private func cancelAddStep() {
        addingToSubchapterID = nil
        newStepTitle = ""
        isStepFieldFocused = false
    }

    // MARK: - Notes State

    private func beginEditNotes(for step: Step) {
        editingNotesStepID = step.id
        notesDraft = step.notes ?? ""
    }

    private func cancelEditNotes() {
        editingNotesStepID = nil
        notesDraft = ""
    }

    // MARK: - Status

    private func statusStyle(
        for sub: Subchapter,
        steps: [Step],
        isDrawer: Bool
    ) -> SubchapterCardStatus {
        if isDrawer { return .none }
        if !steps.isEmpty {
            let allDone = steps.allSatisfy { $0.isCompleted }
            return .indicator(isCompleted: allDone)
        }
        return .toggle(isCompleted: sub.isCompleted) {
            onToggleSubchapter(sub)
        }
    }
}
