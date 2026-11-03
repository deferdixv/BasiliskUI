//
//  ProgressRing.swift
//  BasiliskDesign
//
//  Created by Ferdinand Reichart on 26.09.2026.
//


//
//  ProgressRing.swift
//  BasiliskDesign
//
//  Kreisförmige Fortschrittsanzeige mit Prozentzahl in der Mitte.
//

import SwiftUI

struct ProgressRing: View {
    /// 0…1
    let progress: Double
    var size: CGFloat = 96
    var lineWidth: CGFloat = 8
    var tint: Color = BasiliskColor.brand
    var showsPercentage: Bool = true

    var body: some View {
        ZStack {
            Circle()
                .stroke(tint.opacity(0.15), lineWidth: lineWidth)

            Circle()
                .trim(from: 0, to: max(0, min(progress, 1)))
                .stroke(
                    tint,
                    style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut(duration: 0.35), value: progress)

            if showsPercentage {
                Text("\(Int((max(0, min(progress, 1))) * 100))%")
                    .font(BasiliskFont.serif(size * 0.22, weight: .semibold))
                    .foregroundStyle(BasiliskColor.text)
            }
        }
        .frame(width: size, height: size)
    }
}

#Preview("ProgressRing") {
    ZStack {
        BasiliskColor.background.ignoresSafeArea()
        HStack(spacing: 32) {
            ProgressRing(progress: 0.00, size: 72)
            ProgressRing(progress: 0.25, size: 72)
            ProgressRing(progress: 0.50, size: 72)
            ProgressRing(progress: 0.75, size: 72)
            ProgressRing(progress: 1.00, size: 72)
        }
        .padding(40)
    }
}
