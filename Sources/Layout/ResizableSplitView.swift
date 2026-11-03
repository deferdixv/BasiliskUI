//
//  ResizableSplitView.swift
//  BasiliskDesign
//

import SwiftUI

public struct ResizableSplitView<Left: View, Middle: View, Right: View>: View {
    @Binding var leftWidth: CGFloat
    @Binding var middleWidth: CGFloat

    public var minLeft: CGFloat = 140
    public var maxLeft: CGFloat = 400
    public var minMiddle: CGFloat = 160
    public var maxMiddle: CGFloat = 500
    public var minRight: CGFloat = 400

    @ViewBuilder let left: Left
    @ViewBuilder let middle: Middle
    @ViewBuilder let right: Right

    private let handleWidth: CGFloat = 6

    public var body: some View {
        GeometryReader { geo in
            let totalWidth = geo.size.width
            let handlesTotal = handleWidth * 2
            let availableForColumns = totalWidth - handlesTotal

            // Linke Spalte: geclampt auf minLeft … (available - minMiddle - minRight)
            let leftUpperBound = availableForColumns - minMiddle - minRight
            let effectiveLeft = min(max(leftWidth, minLeft), max(minLeft, leftUpperBound))

            // Mittlere Spalte: geclampt auf minMiddle … (available - effectiveLeft - minRight)
            let middleUpperBound = availableForColumns - effectiveLeft - minRight
            let effectiveMiddle = min(max(middleWidth, minMiddle), max(minMiddle, middleUpperBound))

            // Rechte Spalte: exakt der Rest, NIE kleiner als 0.
            let effectiveRight = max(0, availableForColumns - effectiveLeft - effectiveMiddle)

            HStack(spacing: 0) {
                left
                    .frame(width: effectiveLeft)
                    .clipped()

                SplitHandle { delta in
                    let upper = availableForColumns - middleWidth - minRight
                    leftWidth = min(max(minLeft, leftWidth + delta), min(maxLeft, upper))
                }

                middle
                    .frame(width: effectiveMiddle)
                    .clipped()

                SplitHandle { delta in
                    let upper = availableForColumns - effectiveLeft - minRight
                    middleWidth = min(max(minMiddle, middleWidth + delta), min(maxMiddle, upper))
                }

                right
                    .frame(width: effectiveRight)
                    .clipped()
            }
            .frame(width: totalWidth, alignment: .leading)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - SplitHandle

private struct SplitHandle: View {
    public var onDrag: (CGFloat) -> Void

    @State private var isHovering = false

    public var body: some View {
        Rectangle()
            .fill(Color.clear)
            .frame(width: 6)
            .frame(maxWidth: .infinity, alignment: .topLeading)
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
