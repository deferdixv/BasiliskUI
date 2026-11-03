//
//  ResizableTwoColumnView.swift
//  BasiliskDesign
//

import SwiftUI

private struct EffectiveContentWidthKey: EnvironmentKey {
    public static let defaultValue: CGFloat = 0
}

extension EnvironmentValues {
    /// Die aktuell wirksame Breite der Content-Spalte (in Punkten).
    /// Wird von `ResizableTwoColumnView` gesetzt.
    public var effectiveContentWidth: CGFloat {
        get { self[EffectiveContentWidthKey.self] }
        set { self[EffectiveContentWidthKey.self] = newValue }
    }
}

public struct ResizableTwoColumnView<Content: View, Panel: View>: View {
    @Binding var contentWidth: CGFloat

    public var minContent: CGFloat = 400
    public var maxContent: CGFloat = 2000
    public var minSidebar: CGFloat = 280   // bleibt intern "sidebar", weil es die rechte Spalte meint

    @ViewBuilder let content: Content
    @ViewBuilder let panel: Panel

    private let handleWidth: CGFloat = 6

    public var body: some View {
        GeometryReader { geo in
            let totalWidth = geo.size.width
            let availableForColumns = totalWidth - handleWidth

            let effectiveContent = min(
                max(contentWidth, minContent),
                availableForColumns - minSidebar
            )
            let effectivePanel = availableForColumns - effectiveContent

            HStack(spacing: 0) {
                content
                    .frame(width: effectiveContent, alignment: .topLeading)
                    .environment(\.effectiveContentWidth, effectiveContent)

                SplitHandle { delta in
                    let upper = availableForColumns - minSidebar
                    contentWidth = min(max(minContent, contentWidth + delta), min(maxContent, upper))
                }

                panel
                    .frame(width: effectivePanel, alignment: .topLeading)
            }
            .frame(width: totalWidth, alignment: .topLeading)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - Handle

private struct SplitHandle: View {
    public var onDrag: (CGFloat) -> Void

    @State private var isHovering = false

    public var body: some View {
        Rectangle()
            .fill(Color.clear)
            .frame(width: 6)
            .overlay(
                Rectangle()
                    .fill(isHovering ? BasiliskColor.brand.opacity(0.4) : BasiliskColor.border)
                    .frame(width: 1)
            )
            .contentShape(Rectangle())
            .onHover { hovering in
                isHovering = hovering
                if hovering {
                    NSCursor.resizeLeftRight.push()
                } else {
                    NSCursor.pop()
                }
            }
            .gesture(
                DragGesture(minimumDistance: 1)
                    .onChanged { value in
                        onDrag(value.translation.width)
                    }
            )
    }
}
