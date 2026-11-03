//
//  BasiliskLayout.swift
//  BasiliskDesign
//

import SwiftUI

public enum BasiliskLayout {

    // MARK: Fenster
    public static let windowMinHeight: CGFloat = 620

    // MARK: Detailbereich (Syllabus)
    public static let detailOuterPadding: CGFloat = 6

    // MARK: PlanView
    /// Abstand vom Divider zur Content-Spalte
    public static let planContentInnerPadding: CGFloat = 6
    /// Abstand vom Divider zur Panel-Spalte
    public static let planPanelInnerPadding: CGFloat = 6
    /// Äußerer Rand der PlanView zum Fensterrand
    public static let planOuterPadding: CGFloat = 6

    // MARK: Spalten-Verhältnis (Syllabus)
    public static let columnRatio: (course: CGFloat, chapter: CGFloat, detail: CGFloat) = (1.0, 1.3, 2.4)

    public static func initialColumnWidths(
        totalWidth: CGFloat,
        dividerWidth: CGFloat = 12
    ) -> (course: CGFloat, chapter: CGFloat, detail: CGFloat) {
        let available = totalWidth - dividerWidth
        let sum = columnRatio.course + columnRatio.chapter + columnRatio.detail
        return (
            course:  available * (columnRatio.course / sum),
            chapter: available * (columnRatio.chapter / sum),
            detail:  available * (columnRatio.detail / sum)
        )
    }

    // MARK: Syllabus-Spalten Min/Max
    public static let courseMinWidth: CGFloat = 140
    public static let courseMaxWidth: CGFloat = 400
    public static let chapterMinWidth: CGFloat = 160
    public static let chapterMaxWidth: CGFloat = 500
    public static let detailMinWidth: CGFloat = 400
}
