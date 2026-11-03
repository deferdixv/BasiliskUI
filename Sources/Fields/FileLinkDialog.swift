//
//  FileLinkDialog.swift
//  BasiliskDesign
//
//  Created by Ferdinand Reichart on 26.09.2026.
//


//
//  FileLinkDialog.swift
//  BasiliskUI
//

import SwiftUI
import AppKit

public struct FileLinkDialog: View {

    @Binding public var isPresented: Bool

    @State private var title: String
    @State private var path: String
    @State private var icon: FileTypeIcon

    public var onSave: (_ title: String, _ path: String, _ icon: FileTypeIcon) -> Void

    public init(
        isPresented: Binding<Bool>,
        initialTitle: String = "",
        initialPath: String = "",
        initialIcon: FileTypeIcon = .link,
        onSave: @escaping (String, String, FileTypeIcon) -> Void
    ) {
        self._isPresented = isPresented
        self.onSave = onSave
        _title = State(initialValue: initialTitle)
        _path = State(initialValue: initialPath)
        _icon = State(initialValue: initialIcon)
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: BasiliskSpacing.lg) {
            Text("Datei verknüpfen")
                .font(BasiliskFont.sectionTitle)
                .foregroundStyle(BasiliskColor.text)

            row("Beschreibung") {
                TextField("z. B. Vorlesung 04", text: $title)
                    .textFieldStyle(.roundedBorder)
            }

            row("Pfad/Link") {
                HStack(spacing: BasiliskSpacing.sm) {
                    TextField("/Pfad/oder/https://…", text: $path)
                        .textFieldStyle(.roundedBorder)
                        .onChange(of: path) { _, newValue in
                            autoDetectIcon(for: newValue)
                        }

                    Button {
                        pickFile()
                    } label: {
                        Image(systemName: "folder")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundStyle(BasiliskColor.text)
                            .frame(width: 32, height: 26)
                            .background(
                                RoundedRectangle(cornerRadius: BasiliskRadius.sm)
                                    .fill(BasiliskColor.surface)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: BasiliskRadius.sm)
                                    .stroke(BasiliskColor.border, lineWidth: 1)
                            )
                    }
                    .buttonStyle(.plain)
                    .help("Datei auswählen")
                }
            }

            row("Icon") {
                iconPicker
            }

            HStack {
                Spacer()
                SecondaryButton("Abbrechen") { isPresented = false }
                PrimaryButton("Verknüpfen", icon: "link") {
                    onSave(title, path, icon)
                    isPresented = false
                }
                .disabled(title.isEmpty || path.isEmpty)
            }
        }
        .padding(BasiliskSpacing.xl)
        .frame(width: 520)
        .background(BasiliskColor.background)
    }

    private func row<Content: View>(_ label: String, @ViewBuilder content: () -> Content) -> some View {
        HStack(alignment: .firstTextBaseline, spacing: BasiliskSpacing.md) {
            Text(label)
                .font(BasiliskFont.body)
                .foregroundStyle(BasiliskColor.textMuted)
                .frame(width: 100, alignment: .leading)
            content()
        }
    }

    private var iconPicker: some View {
        HStack(spacing: BasiliskSpacing.md) {
            ForEach(iconChoices, id: \.self) { choice in
                Button { icon = choice } label: {
                    FileTypeIconView(
                        type: choice, size: 22,
                        style: choice == icon ? .tinted : .plain
                    )
                    .opacity(choice == icon ? 1.0 : 0.45)
                }
                .buttonStyle(.plain)
            }
            Spacer()
        }
    }

    private var iconChoices: [FileTypeIcon] {
        [.video, .document, .folder, .link]
    }

    private func autoDetectIcon(for raw: String) {
        guard !raw.isEmpty else { return }
        let lower = raw.lowercased()
        if lower.hasPrefix("http://") || lower.hasPrefix("https://") {
            icon = .link
        } else if lower.hasSuffix(".pdf") {
            icon = .document
        } else if [".doc", ".docx", ".txt", ".md", ".rtf", ".pages"].contains(where: { lower.hasSuffix($0) }) {
            icon = .document
        } else if [".mp4", ".mov", ".m4v", ".mkv", ".avi"].contains(where: { lower.hasSuffix($0) }) {
            icon = .video
        } else if FileManager.default.fileExists(atPath: raw) {
            var isDir: ObjCBool = false
            FileManager.default.fileExists(atPath: raw, isDirectory: &isDir)
            icon = isDir.boolValue ? .folder : .unknown
        } else {
            icon = .link
        }
    }

    private func pickFile() {
        let panel = NSOpenPanel()
        panel.canChooseFiles = true
        panel.canChooseDirectories = true
        panel.allowsMultipleSelection = false
        if panel.runModal() == .OK, let url = panel.url {
            path = url.path
            if title.isEmpty {
                title = url.deletingPathExtension().lastPathComponent
            }
        }
    }
}

// MARK: - Sheet-Wrapper

public struct FileLinkDialogSheet: View {
    @Binding public var isPresented: Bool
    public var initialTitle: String
    public var initialPath: String
    public var onSave: (String, String, FileTypeIcon) -> Void

    public init(
        isPresented: Binding<Bool>,
        initialTitle: String = "",
        initialPath: String = "",
        onSave: @escaping (String, String, FileTypeIcon) -> Void
    ) {
        self._isPresented = isPresented
        self.initialTitle = initialTitle
        self.initialPath = initialPath
        self.onSave = onSave
    }

    public var body: some View {
        FileLinkDialog(
            isPresented: $isPresented,
            initialTitle: initialTitle,
            initialPath: initialPath,
            onSave: onSave
        )
    }
}
