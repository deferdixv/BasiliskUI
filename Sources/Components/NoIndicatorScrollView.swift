//
//  NoIndicatorScrollView.swift
//  BasiliskDesign
//
//  Created by Ferdinand Reichart on 29.09.2026.
//

import SwiftUI
import AppKit

struct NoIndicatorScrollView<Content: View>: View {
    @ViewBuilder let content: Content

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            content
        }
        .background(
            ScrollViewConfigurator()
                .frame(width: 0, height: 0)
        )
    }
}

private struct ScrollViewConfigurator: NSViewRepresentable {
    func makeNSView(context: Context) -> NSView {
        let view = NSView()
        DispatchQueue.main.async { configure(view) }
        return view
    }

    func updateNSView(_ nsView: NSView, context: Context) {
        DispatchQueue.main.async { configure(nsView) }
    }

    private func configure(_ view: NSView) {
        // Gehe den View-Tree nach oben und finde den nächsten NSScrollView
        var current: NSView? = view
        while let v = current {
            if let scrollView = v as? NSScrollView {
                scrollView.hasVerticalScroller = false
                scrollView.hasHorizontalScroller = false
                scrollView.autohidesScrollers = true
                return
            }
            current = v.superview
        }
    }
}
