//
//  screencaptureViewModel.swift
//  Mac OS screenshot demo
//
//  Created by 孟贤泽 on 2024/7/23.
//

import SwiftUI

class ScreencaptureViewModel: ObservableObject {

    // Enum is a type in the Swift programming language. It allows you to define a group of related values, which are called cases.
    // In this example, the ScreenshotTypes enum defines three types of screenshots: full, window, and area.
    enum ScreenshotTypes {
        case full
        case window
        case area
        
        // processArguments is a computed property that returns an array of command line arguments based on the current enum case.
        var processArguments: [String] {
            switch self {
            case .full:
                return ["-c"]
            case .window:
                return ["-cw"]
            case .area:
                return ["-cs"]
            }
        }
    }
    
    // Defines an `images` property, which is an array of NSImage objects, and uses the @Published property wrapper.
    // @Published is a property wrapper provided by SwiftUI to mark properties inside an ObservableObject class.
    // When these properties change, it triggers an automatic refresh of the view.
    @Published var images = [NSImage]()
    
    // Takes a parameter `type`, which is a value of the ScreenshotTypes enum. This parameter specifies the type of screenshot (full, window, or area).
    func takeScreenshot(for type: ScreenshotTypes) {
        // Creates a Process object. The Process object is a class used in Swift and Objective-C to execute external commands or scripts within an application.
        // It allows you to create and manage subprocesses and interact with them.
        let task = Process()
        
        // Sets the executable file path to /usr/sbin/screencapture
        task.executableURL = URL(fileURLWithPath: "/usr/sbin/screencapture")
        task.arguments = type.processArguments
        
        do {
            // The run() method starts the subprocess (in this case, the screencapture command).
            // Because the run() method can throw an error, it uses the try keyword and is placed within a do block.
            try task.run()
            
            // The waitUntilExit() method blocks the current thread until the subprocess completes.
            // This ensures that subsequent code does not execute until the screenshot operation is finished.
            task.waitUntilExit()
            getImageFromPasteboard()
        } catch {
            print("Could not make a screenshot: \(error)")
        }
    }
    
    // Converts an NSImage object to PNG data
    private func convertImageToPNGData(image: NSImage) -> Data? {
        // Creates a bitmap representation from the NSImage
        guard let tiffData = image.tiffRepresentation,
              let bitmapImageRep = NSBitmapImageRep(data: tiffData) else {
            return nil
        }
        
        // Uses the bitmap to generate PNG data
        let pngData = bitmapImageRep.representation(using: .png, properties: [:])
        return pngData
    }
    
    // Retrieves an image from the clipboard
    private func getImageFromPasteboard() {
        // Checks if there is data conforming to the specified types (all image types supported by NSImage) in the clipboard. If not, it exits.
        guard NSPasteboard.general.canReadItem(withDataConformingToTypes: NSImage.imageTypes) else { return }
        
        // If an image is successfully retrieved from the clipboard, it is assigned to the `image` variable; otherwise, the method returns without executing further code.
        guard let image = NSImage(pasteboard: NSPasteboard.general) else { return }
        
        if let pngData = convertImageToPNGData(image: image) {
            // Gets the path to the user's documents directory
            let fileManager = FileManager.default
            
            if let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
                let filePath = documentsDirectory.appendingPathComponent("image.png")
                
                do {
                    try pngData.write(to: filePath)
                    print("Image saved successfully at \(filePath)")
                } catch {
                    print("Error saving image: \(error)")
                }
            }
        }

        // Adds the image to the images array
        self.images.append(image)
    }
}
