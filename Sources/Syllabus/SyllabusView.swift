//
//  SyllabusView.swift
//  BasiliskUI
//

import SwiftUI
import BasiliskCore

public struct SyllabusView: View {

    // MARK: - Inputs

    public let courses: [Course]
    public let parts: [Part]
    public let chapters: [Chapter]
    public let subchapters: [Subchapter]
    public let steps: [Step]

    public let progressByCourseID: [UUID: Double]

    @Binding public var selectedCourseIDs: Set<UUID>
    @Binding public var selectedChapterIDs: Set<UUID>
    @Binding public var selectedPartIDs: Set<UUID>

    public let isEditMode: Bool

    public var onAddCourse: (String) -> Void
    
    public var onPickUniversityRoot: () -> Void
    
    public var onAddChapter: (String, UUID) -> Void
    public var onAddPart: (UUID) -> Void
    public var onAddSubchapter: (String, UUID) -> Void

    public var onEditAction: (EditAction) -> Void
    public var onRevealInFinder: (Course) -> Void
    public var onToggleStep: (Step) -> Void
    public var onToggleSubchapter: (Subchapter) -> Void
    
    public var onAddStep: (String, UUID) -> Void
    public var onPickCourseFolder: (Course) -> Void
    public var onRevealChapterInFinder: (Chapter, Course) -> Void
    
    public var onDeleteStep: (Step) -> Void
    public var onUpdateStepNotes: (Step, String) -> Void
    
    public var onAddFileLink: (String, URL, UUID) -> Void
    public var onDeleteFileLink: (FileLinkItem) -> Void
    
    

    // MARK: - Layout State

    @State private var courseWidth: CGFloat = 240
    @State private var chapterWidth: CGFloat = 300
    @State private var didInitialize = false

    // MARK: - Init

    public init(
        courses: [Course],
        parts: [Part],
        chapters: [Chapter],
        subchapters: [Subchapter],
        steps: [Step],
        progressByCourseID: [UUID: Double] = [:],
        selectedCourseIDs: Binding<Set<UUID>>,
        selectedChapterIDs: Binding<Set<UUID>>,
        selectedPartIDs: Binding<Set<UUID>>,
        isEditMode: Bool = false,
        onAddCourse: @escaping (String) -> Void,
        onPickUniversityRoot: @escaping () -> Void,
        onAddChapter: @escaping (String, UUID) -> Void,
        onAddPart: @escaping (UUID) -> Void,
        onAddSubchapter: @escaping (String, UUID) -> Void,
        onEditAction: @escaping (EditAction) -> Void = { _ in },
        onRevealInFinder: @escaping (Course) -> Void,
        onToggleStep: @escaping (Step) -> Void,
        onToggleSubchapter: @escaping (Subchapter) -> Void,
        onAddStep: @escaping (String, UUID) -> Void,
        onPickCourseFolder: @escaping (Course) -> Void,
        onRevealChapterInFinder: @escaping (Chapter, Course) -> Void,
        onDeleteStep: @escaping (Step) -> Void,
        onUpdateStepNotes: @escaping (Step, String) -> Void,
        onAddFileLink: @escaping (String, URL, UUID) -> Void,
        onDeleteFileLink: @escaping (FileLinkItem) -> Void,
    ) {
        self.courses = courses
        self.parts = parts
        self.chapters = chapters
        self.subchapters = subchapters
        self.steps = steps
        self.progressByCourseID = progressByCourseID
        self._selectedCourseIDs = selectedCourseIDs
        self._selectedChapterIDs = selectedChapterIDs
        self._selectedPartIDs = selectedPartIDs
        self.isEditMode = isEditMode
        self.onAddCourse = onAddCourse
        self.onPickUniversityRoot = onPickUniversityRoot
        self.onAddChapter = onAddChapter
        self.onAddPart = onAddPart
        self.onAddSubchapter = onAddSubchapter
        self.onEditAction = onEditAction
        self.onRevealInFinder = onRevealInFinder
        self.onToggleStep = onToggleStep
        self.onToggleSubchapter = onToggleSubchapter
        self.onAddStep = onAddStep
        self.onPickCourseFolder = onPickCourseFolder
        self.onRevealChapterInFinder = onRevealChapterInFinder
        self.onDeleteStep = onDeleteStep
        self.onUpdateStepNotes = onUpdateStepNotes
        self.onAddFileLink = onAddFileLink
        self.onDeleteFileLink = onDeleteFileLink
    }

    // MARK: - Derived

    /// Primärer Kurs — das erste Element der Multi-Selection.
    private var selectedCourseID: UUID? {
        selectedCourseIDs.first
    }

    private var selectedCourse: Course? {
        guard let id = selectedCourseID else { return nil }
        return courses.first { $0.id == id }
    }

    private var selectedChapter: Chapter? {
        guard let id = selectedChapterIDs.first else { return nil }
        return chapters.first { $0.id == id }
    }

    private var selectedPart: Part? {
        guard let id = selectedPartIDs.first else { return nil }
        return parts.first { $0.id == id }
    }

    private var hierarchy: SyllabusHierarchy? {
        guard let course = selectedCourse else { return nil }
        return SyllabusHierarchy(
            course: course,
            parts: parts,
            chapters: chapters,
            subchapters: subchapters,
            steps: steps
        )
    }

    // MARK: - Body

    public var body: some View {
        GeometryReader { geo in
            ResizableSplitView(
                leftWidth: $courseWidth,
                middleWidth: $chapterWidth,
                minLeft: BasiliskLayout.courseMinWidth,
                maxLeft: BasiliskLayout.courseMaxWidth,
                minMiddle: BasiliskLayout.chapterMinWidth,
                maxMiddle: BasiliskLayout.chapterMaxWidth,
                minRight: BasiliskLayout.detailMinWidth,
                left: {
                    CourseListPanel(
                        courses: courses,
                        progressByCourseID: progressByCourseID,
                        selection: $selectedCourseIDs,
                        isEditMode: isEditMode,
                        onAdd: { title in onAddCourse(title) },
                        onPickUniversityRoot: onPickUniversityRoot,
                        onEditAction: onEditAction,
                        
                    )
                },
                middle: {
                    ChapterListPanel(
                        hierarchy: hierarchy,
                        selectedChapterID: $selectedChapterIDs,
                        selectedPartID: $selectedPartIDs,
                        onAddChapter: { title in
                            if let id = selectedCourseID {
                                onAddChapter(title, id)
                            }
                        },
                        isEditMode: isEditMode,
                        onEditAction: onEditAction
                    )
                },
                right: {
                    detailPanel
                }
            )
            .onAppear {
                if !didInitialize {
                    let widths = BasiliskLayout.initialColumnWidths(totalWidth: geo.size.width)
                    courseWidth = widths.course
                    chapterWidth = widths.chapter
                    didInitialize = true
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    // MARK: - Detail

    @ViewBuilder
    private var detailPanel: some View {
        if let chapter = selectedChapter, let hierarchy {
            ChapterDetailPanel(
                chapter: chapter,
                hierarchy: hierarchy,
                onToggleStep: onToggleStep,
                onToggleSubchapter: onToggleSubchapter,
                isEditMode: isEditMode,
                onAddSubchapter: { title in onAddSubchapter(title, chapter.id) },
                onAddStep: onAddStep,
                onEditAction: onEditAction,
                onRevealInFinder: {
                    if let course = selectedCourse {
                        onRevealChapterInFinder(chapter, course)
                    }
                },
                onAddFileLink: onAddFileLink,
                onDeleteStep: onDeleteStep,
                onUpdateStepNotes: onUpdateStepNotes,
                onDeleteFileLink: onDeleteFileLink
            )
        } else if let part = selectedPart {
            PartDetailPanel(part: part, isEditMode: isEditMode)
        } else if let course = selectedCourse, let hierarchy {
            CourseDetailPanel(
                course: course,
                hierarchy: hierarchy,
                onRevealInFinder: { onRevealInFinder(course) },
                isEditMode: isEditMode,
                onAddChapter: { title in
                    onAddChapter(title, course.id);
                },
                onEditAction: onEditAction,
                onPickFolder: { onPickCourseFolder(course) }
            )
        } else {
            EmptyStateView(
                icon: "book.closed",
                title: "Kein Kurs ausgewählt",
                message: "Wähle links einen Kurs, um zu starten."
            )
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}
