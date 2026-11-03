//
//  MainSidebar.swift
//  BasiliskUI
//

import SwiftUI

public struct MainSidebar: View {

    @Binding public var selection: AppSection

    public init(selection: Binding<AppSection>) {
        self._selection = selection
    }

    public var body: some View {
        List(selection: $selection) {
            Section {
                ForEach(AppSection.allCases) { section in
                    Label(section.rawValue, systemImage: section.icon)
                        .tag(section)
                }
            } header: {
                HStack(alignment: .top) {
                    Image("logo")
                        .resizable()
                        .frame(width: 100, height: 100)
                    Spacer()
                }
                .padding(.vertical, 4)
                .textCase(nil)
            }
        }
        .listStyle(.sidebar)
        .safeAreaInset(edge: .bottom, spacing: 0) {
            VStack(spacing: 0) {
                Divider()
                HStack(spacing: 8) {
                    Image(systemName: "person.circle.fill")
                        .font(.system(size: 18))
                        .foregroundStyle(BasiliskColor.textMuted)
                    Text("Student")
                        .font(BasiliskFont.standard(12, weight: .medium))
                        .foregroundStyle(BasiliskColor.text)
                    Spacer()
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 10)
            }
            .background(.bar)
        }
        .padding(.leading, 8)
    }
}
