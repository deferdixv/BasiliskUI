//
//  StepRow.swift
//  BasiliskDesign
//
//  Created by Ferdinand Reichart on 28.09.2026.
//


//
//  StepRow.swift
//  BasiliskDesign
//

import SwiftUI

struct StepRow<Content: View>: View {
    let title: String
    var subtitle: String? = nil
    var isCompleted: Bool = false
    @ViewBuilder let content: Content

    init(
        title: String,
        subtitle: String? = nil,
        isCompleted: Bool = false,
        @ViewBuilder content: () -> Content
    ) {
        self.title = title
        self.subtitle = subtitle
        self.isCompleted = isCompleted
        self.content = content()
    }

    init(
        title: String,
        subtitle: String? = nil,
        isCompleted: Bool = false
    ) where Content == EmptyView {
        self.title = title
        self.subtitle = subtitle
        self.isCompleted = isCompleted
        self.content = EmptyView()
    }

    var body: some View {
        HStack(alignment: .top, spacing: BasiliskSpacing.md) {
            statusCircle.padding(.top, 2)

            VStack(alignment: .leading, spacing: BasiliskSpacing.sm) {
                Text(title)
                    .font(BasiliskFont.standard(14, weight: .semibold))
                    .foregroundStyle(BasiliskColor.text)
                    .strikethrough(isCompleted, color: BasiliskColor.textMuted)

                if let subtitle, !subtitle.isEmpty {
                    Text(subtitle)
                        .font(BasiliskFont.body)
                        .foregroundStyle(BasiliskColor.textMuted)
                }

                content
            }
        }
    }

    private var statusCircle: some View {
        ZStack {
            Circle()
                .fill(isCompleted ? BasiliskColor.success : Color.gray.opacity(0.25))
                .frame(width: 20, height: 20)

            if isCompleted {
                Image(systemName: "checkmark")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundStyle(.white)
            }
        }
    }
}