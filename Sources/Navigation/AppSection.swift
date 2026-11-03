//
//  AppSection.swift
//  BasiliskDesign
//
//  Created by Ferdinand Reichart on 28.09.2026.
//


//
//  AppSection.swift
//  BasiliskDesign
//
//  Die Hauptbereiche der App.
//

import Foundation

public enum AppSection: String, CaseIterable, Identifiable {
    case dashboard = "Überblick"
    case syllabus = "Syllabus"
    case plan = "Planen"
    case session = "Session"
    case statistics = "Statistik"
    case settings = "Einstellungen"

    public var id: String { rawValue }

    public var icon: String {
        switch self {
        case .dashboard:  return "square.grid.2x2"
        case .syllabus:   return "book"
        case .plan:       return "calendar"
        case .session:    return "studentdesk"
        case .statistics: return "chart.bar"
        case .settings:   return "gear"
        }
    }
}
