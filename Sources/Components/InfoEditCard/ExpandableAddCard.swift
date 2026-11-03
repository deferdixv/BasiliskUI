//
//  ExpandableAddCard.swift
//  BasiliskDesign
//
//  Created by Ferdinand Reichart on 30.09.2026.
//


//
//  ExpandableAddCard.swift
//  BasiliskDesign
//
//  Floating-Plus-Button, der sich zur InfoEditCard ausfährt.
//

import SwiftUI

struct ExpandableAddCard<Card: View>: View {
    @Binding var isExpanded: Bool
    @ViewBuilder let card: Card

    @Namespace private var ns

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            if isExpanded {
                // Backdrop — Klick außerhalb schließt
                Color.black.opacity(0.00)
                    .ignoresSafeArea()
                    .onTapGesture { withAnimation { isExpanded = false } }
                    .transition(.opacity)
            }

            Group {
                if isExpanded {
                    card
                        .matchedGeometryEffect(id: "addCard", in: ns)
                        .transition(.opacity.combined(with: .scale(scale: 0.95, anchor: .bottomLeading)))
                } else {
                    FloatingActionButton {
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                            isExpanded = true
                        }
                    }
                    .matchedGeometryEffect(id: "addCard", in: ns)
                }
            }
            .padding(.leading, BasiliskLayout.planOuterPadding + BasiliskSpacing.sm)
            .padding(.bottom, BasiliskLayout.planOuterPadding + BasiliskSpacing.sm)
        }
        .animation(.spring(response: 0.35, dampingFraction: 0.85), value: isExpanded)
    }
}

#Preview("ExpandableAddCard") {
    struct Wrapper: View {
        @State private var isExpanded = false
        @State private var title = ""
        @State private var notes = ""
        @State private var date = Date()
        @State private var duration: SessionDuration = .medium

        var body: some View {
            ZStack {
                BasiliskColor.background.ignoresSafeArea()

                ExpandableAddCard(isExpanded: $isExpanded) {
                    InfoEditCard(
                        title: "Session planen",
                        subtitle: "Neue Session"
                    ) {
                        VStack(spacing: 0) {
                            InfoEditTextRow(label: "Titel", placeholder: "Session Titel (optional)", text: $title)
                            InfoEditTextRow(label: "Notizen", placeholder: "Notizen", text: $notes, isMultiline: true)
                            InfoEditDateRow(label: "Datum & Zeit", date: $date)
                            InfoEditRow("Dauer", showsDivider: false) {
                                DurationPicker(selection: $duration)
                            }
                        }
                    } footer: {
                        Button("Abbrechen") { isExpanded = false }
                            .buttonStyle(.borderless)
                        Button("Starten") { isExpanded = false }
                            .buttonStyle(.borderedProminent)
                            .tint(BasiliskColor.brand)
                    }
                }
            }
        }
    }
    return Wrapper()
}
