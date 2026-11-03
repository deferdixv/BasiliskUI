//
//  ProgressBar.swift
//  BasiliskDesign
//
//  Created by Ferdinand Reichart on 26.09.2026.
//


//
//  ProgressBar.swift
//  BasiliskDesign
//
//  Schlanker Fortschrittsbalken als Ersatz für ProgressView.
//  Track grau, Fill brand-grün, 6 px hoch, abgerundet.
//

import SwiftUI

struct ProgressBar: View {
    /// 0…1
    let value: Double
    var tint: Color = BasiliskColor.brand
    var track: Color = Color.gray.opacity(0.25)
    var height: CGFloat = 6

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(track)

                Capsule()
                    .fill(tint)
                    .frame(width: geo.size.width * max(0, min(value, 1)))
            }
        }
        .frame(height: height)
    }
}

#Preview("ProgressBar") {
    ZStack {
        BasiliskColor.background.ignoresSafeArea()
        VStack(spacing: 20) {
            ProgressBar(value: 0.00)
            ProgressBar(value: 0.25)
            ProgressBar(value: 0.50)
            ProgressBar(value: 0.85)
            ProgressBar(value: 1.00)
        }
        .padding(40)
        .frame(maxWidth: 480)
    }
}