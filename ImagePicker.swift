//
//  ImagePicker.swift
//  CountDown
//
//  Created by Ersin Hasanbas on 08/08/2025.
//

import SwiftUI
import AppKit

struct ImagePicker: NSViewControllerRepresentable {
    @Binding var selectedImage: NSImage?

    func makeNSViewController(context: Context) -> NSViewController {
        let viewController = NSViewController()
        DispatchQueue.main.async {
            let panel = NSOpenPanel()
            panel.allowedContentTypes = [.png, .jpeg, .heic, .bmp, .gif, .tiff]
            panel.allowsMultipleSelection = false
            panel.canChooseDirectories = false

            if panel.runModal() == .OK, let url = panel.url, let img = NSImage(contentsOf: url) {
                selectedImage = img
            }
            viewController.dismiss(nil)
        }
        return viewController
    }

    func updateNSViewController(_ nsViewController: NSViewController, context: Context) {
        // no update needed here
    }
}
