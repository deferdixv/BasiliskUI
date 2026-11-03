//
//  ChapterDetailPanel.swift
//  BasiliskUI
//

import SwiftUI
import BasiliskCore

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
    public var onDeleteStep: (Step) -> Void
    public var onUpdateStepNotes: (Step, String) -> Void

    @State private var addingToSubchapterID: UUID?
    @State private var newStepTitle: String = ""
    @State private var editingNotesStepID: UUID?
    @State private var notesDraft: String = ""
    @FocusState private var isStepFieldFocused: Bool

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
        onDeleteStep: @escaping (Step) -> Void = { _ in },
        onUpdateStepNotes: @escaping (Step, String) -> Void = { _, _ in }
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
        self.onDeleteStep = onDeleteStep
        self.onUpdateStepNotes = onUpdateStepNotes
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
        }
        .animation(.easeInOut(duration: 0.2), value: isEditMode)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
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

    // MARK: - Progress

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
                if isAddingHere {
                    cancelAddStep()
                } else {
                    beginAddStep(in: sub.id)
                }
            }
        ) {
            VStack(alignment: .leading, spacing: BasiliskSpacing.lg) {
                if subSteps.isEmpty && !isAddingHere {
                    if isDrawer {
                        Text("Gibt wohl nichts zu tun? ;-)")
                            .font(BasiliskFont.body)
                            .foregroundStyle(BasiliskColor.textMuted)
                    } else {
                        Text("Noch keine Schritte — hake das Unterkapitel ab, wenn es fertig ist.")
                            .font(BasiliskFont.body)
                            .foregroundStyle(BasiliskColor.textMuted)
                    }
                } else {
                    ForEach(Array(subSteps.enumerated()), id: \.element.id) { idx, step in
                        if idx > 0 {
                            Divider().opacity(0.3)
                        }
                        stepRow(for: step)
                    }
                }

                if isAddingHere {
                    if !subSteps.isEmpty {
                        Divider().opacity(0.3)
                    }
                    newStepField
                }
            }
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

            Button {
                cancelAddStep()
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 14))
                    .foregroundStyle(BasiliskColor.textMuted)
            }
            .buttonStyle(.plain)
            .help("Abbrechen")
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
        guard !title.isEmpty else {
            cancelAddStep()
            return
        }
        onAddStep(title, id)
        newStepTitle = ""
        // Fokus behalten — der User kann direkt den nächsten Step tippen.
        isStepFieldFocused = true
    }

    private func cancelAddStep() {
        addingToSubchapterID = nil
        newStepTitle = ""
        isStepFieldFocused = false
    }

    /// Millarium-Regeln für den Status-Kreis.
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

    // MARK: - Step

    private func stepRow(for step: Step) -> some View {
        let isEditingNotes = editingNotesStepID == step.id

        return VStack(alignment: .leading, spacing: BasiliskSpacing.sm) {
            HStack(alignment: .top, spacing: BasiliskSpacing.md) {
                // Status-Kreis + Titel als Toggle
                Button {
                    onToggleStep(step)
                } label: {
                    HStack(alignment: .top, spacing: BasiliskSpacing.md) {
                        statusCircle(for: step)
                        VStack(alignment: .leading, spacing: 2) {
                            Text(step.title)
                                .font(BasiliskFont.standard(14, weight: .semibold))
                                .foregroundStyle(BasiliskColor.text)
                                .strikethrough(step.isCompleted, color: BasiliskColor.textMuted)
                                .multilineTextAlignment(.leading)

                            if let notes = step.notes, !notes.isEmpty, !isEditingNotes {
                                Text(notes)
                                    .font(BasiliskFont.body)
                                    .foregroundStyle(BasiliskColor.textMuted)
                                    .multilineTextAlignment(.leading)
                            }
                        }
                    }
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)

                Spacer()

                // Edit-Mode: Mülltonne
                if isEditMode {
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
            }

            // Inline Notes-Editor
            if isEditingNotes {
                stepNotesEditor(for: step)
            } else if isEditMode {
                // Edit-Mode: dezenter Link "Notiz bearbeiten"
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
        }
        .contextMenu {
            Button("Notiz bearbeiten") { beginEditNotes(for: step) }
            if isEditMode {
                Divider()
                Button("Löschen", role: .destructive) { onDeleteStep(step) }
            }
        }
    }

    private func statusCircle(for step: Step) -> some View {
        ZStack {
            Circle()
                .fill(step.isCompleted ? BasiliskColor.success : Color.gray.opacity(0.25))
                .frame(width: 20, height: 20)
            if step.isCompleted {
                Image(systemName: "checkmark")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundStyle(.white)
            }
        }
    }

    private func stepNotesEditor(for step: Step) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            TextEditor(text: $notesDraft)
                .font(BasiliskFont.body)
                .scrollContentBackground(.hidden)
                .frame(minHeight: 50)
                .padding(6)
                .background(
                    RoundedRectangle(cornerRadius: BasiliskRadius.sm, style: .continuous)
                        .fill(BasiliskColor.parchment.opacity(0.35))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: BasiliskRadius.sm, style: .continuous)
                        .stroke(BasiliskColor.border, lineWidth: 1)
                )

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
        .padding(.leading, 32)
    }

    private func beginEditNotes(for step: Step) {
        editingNotesStepID = step.id
        notesDraft = step.notes ?? ""
    }

    private func cancelEditNotes() {
        editingNotesStepID = nil
        notesDraft = ""
    }
}
