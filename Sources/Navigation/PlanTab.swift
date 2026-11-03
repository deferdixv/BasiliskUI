//
//  PlanTab.swift
//  BasiliskUI
//
//  Created by Ferdinand Reichart on 10.10.2026.
//


//
//  PlanTab.swift
//  BasiliskUI
//

import Foundation

public enum PlanTab: String, CaseIterable, Identifiable {
    case sessions = "Sessionen"
    case reminders = "Erinnerungen"
    case notes = "Notizen"

    public var id: String { rawValue }
}