//
//  FloatingActionButton.swift
//  BasiliskDesign
//
//  Created by Ferdinand Reichart on 30.09.2026.
//


//
//  FloatingActionButton.swift
//  BasiliskDesign
//

import SwiftUI

struct FloatingActionButton: View {
    var icon: String = "plus"
    var help: String? = nil
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(.white)
                .frame(width: 44, height: 44)
                .background(
                    Circle().fill(BasiliskColor.brand)
                )
                .shadow(color: .black.opacity(0.15), radius: 6, x: 0, y: 3)
        }
        .buttonStyle(.plain)
        .help(help ?? "")
    }
}

#Preview("FloatingActionButton") {
    ZStack {
        BasiliskColor.background.ignoresSafeArea()
        FloatingActionButton { }
    }
    .frame(width: 300, height: 300)
}