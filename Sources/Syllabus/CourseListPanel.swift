//
//  CourseListPanel.swift
//  BasiliskUI
//

import SwiftUI
import BasiliskCore

public struct CourseListPanel: View {

    public let courses: [Course]
    public let progressByCourseID: [UUID: Double]
    @Binding public var selection: Set<UUID>      // ← war: UUID?
    public var isEditMode: Bool
    public var onAdd: (String) -> Void
    public var onEditAction: (EditAction) -> Void

    public init(
        courses: [Course],
        progressByCourseID: [UUID: Double] = [:],
        selection: Binding<Set<UUID>>,             // ← war: Binding<UUID?>
        isEditMode: Bool = false,
        onAdd: @escaping (String) -> Void,
        onEditAction: @escaping (EditAction) -> Void = { _ in },
    ) {
        self.courses = courses
        self.progressByCourseID = progressByCourseID
        self._selection = selection
        self.isEditMode = isEditMode
        self.onAdd = onAdd
        self.onEditAction = onEditAction
    }

    public var body: some View {
        VStack(spacing: 0) {
            Group {
                if courses.isEmpty {
                    EmptyStateView(
                        icon: "books.vertical",
                        title: "Keine Kurse",
                        message: "Lege deinen ersten Kurs an."
                    )
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    List(selection: $selection) {
                        ForEach(courses) { course in
                            CourseRow(
                                course: course,
                                progress: progressByCourseID[course.id] ?? 0
                            )
                            .tag(course.id)
                            .listRowSeparator(.hidden)
                            .contextMenu {
                                Button("Umbenennen") {
                                    onEditAction(.renameCourse(course))
                                }
                                Divider()
                                Button("Löschen", role: .destructive) {
                                    onEditAction(.deleteCourse(course))
                                }
                            }
                        }
                    }
                    .listStyle(.sidebar)
                    .scrollContentBackground(.hidden)
                    .scrollIndicators(.never)
                    .tint(isEditMode ? BasiliskColor.royalBlue : BasiliskColor.textMuted)
                    .editModeFade(isActive: isEditMode)
                }
            }

            // Edit-Mode Add-Card unten
            if isEditMode {
                RoyalInkAddCard(placeholder: "Neues Kurs", icon: "plus") { title in
                    onAdd(title)                              // ← Titel durchreichen
                }
                .padding(.horizontal, BasiliskSpacing.md)
                .padding(.bottom, BasiliskSpacing.md)
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .background(BasiliskColor.background)
        .animation(.easeInOut(duration: 0.2), value: isEditMode)
    }

    
}

// MARK: - Row

private struct CourseRow: View {
    let course: Course
    let progress: Double

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(course.name)
                .font(BasiliskFont.standard(13, weight: .medium))
                .foregroundStyle(BasiliskColor.text)

            Text(course.courseNumber)
                .font(BasiliskFont.caption)
                .foregroundStyle(BasiliskColor.textMuted)

            if progress > 0 {
                ProgressBar(value: progress, height: 4)
            }
        }
        .padding(.vertical, 2)
    }
}
