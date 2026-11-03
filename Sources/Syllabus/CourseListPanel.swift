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
    public var onPickUniversityRoot: () -> Void
    public var onEditAction: (EditAction) -> Void
   

    public init(
        courses: [Course],
        progressByCourseID: [UUID: Double] = [:],
        selection: Binding<Set<UUID>>,             // ← war: Binding<UUID?>
        isEditMode: Bool = false,
        onAdd: @escaping (String) -> Void,
        onPickUniversityRoot: @escaping () -> Void = { },
        onEditAction: @escaping (EditAction) -> Void = { _ in },
    ) {
        self.courses = courses
        self.progressByCourseID = progressByCourseID
        self._selection = selection
        self.isEditMode = isEditMode
        self.onAdd = onAdd
        self.onPickUniversityRoot = onPickUniversityRoot
        self.onEditAction = onEditAction
    }

    public var body: some View {
        VStack(spacing: 0) {
            Group {
                if courses.isEmpty {
                    emptyState
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
    private var emptyState: some View {
        VStack(spacing: BasiliskSpacing.lg) {
            Spacer()

            Image(systemName: "books.vertical")
                .font(.system(size: 42, weight: .light))
                .foregroundStyle(BasiliskColor.textMuted)

            Text("Keine Kurse")
                .font(BasiliskFont.sectionTitle)
                .foregroundStyle(BasiliskColor.text)

            Text("Wähle einen Ordner für deine aktuellen Kurse aus.")
                .font(BasiliskFont.body)
                .foregroundStyle(BasiliskColor.textMuted)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.horizontal, BasiliskSpacing.lg)

            PrimaryButton("Ordner wählen", icon: "folder") {
                onPickUniversityRoot()
            }
            .padding(.top, BasiliskSpacing.sm)

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
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
