//
//  screencaptureViewModel.swift
//  Mac OS screenshot demo
//
//  Created by 孟贤泽 on 2024/7/23.
//

import SwiftUI

class ScreencaptureViewModel: ObservableObject {

    // enum是Swift 编程语言中的枚举类型。枚举类型允许你定义一组相关的值，这些值被称为枚举的成员（cases）
    // 在这个例子中，ScreenshotTypes 枚举定义了三种截图类型：full、window 和 area


    enum ScreenshotTypes {
        case full
        case window
        case area
        
        
        // processArguments 是一个计算属性，它根据当前的枚举成员动态返回相应的命令行参数数组。

        var processArguments: [String] {
            switch self {
            case .full:
                ["-c"]
            case .window:
                ["-cw"]
            case .area:
                ["-cs"]
            }
        }
    }
    
    
    // 定义了一个 images 属性，它是一个 NSImage 对象的数组，并使用 @Published 属性包装器修饰。
    
    //@Published 是 SwiftUI 提供的属性包装器，它用于标记 ObservableObject 类中的属性。当这些属性发生变化时，会触发视图的自动刷新
    @Published var images = [NSImage]()
    
    // 接受一个参数 type，它是一个 ScreenshotTypes 枚举类型的值。这个参数指定了截图的类型（全屏、窗口或区域截图）
    func takeScreenshot(for type: ScreenshotTypes) {
        
        // 创建Process对象，Process 对象是 Swift 和 Objective-C 中用于在应用程序中执行外部命令或脚本的类。它允许你创建和管理子进程，并与之进行交互
        let task = Process()
        
        // 并设置其可执行文件路径为 /usr/sbin/screencapture
        task.executableURL = URL(fileURLWithPath: "/usr/sbin/screencapture")
        task.arguments = type.processArguments
        
        do {
            
            // run() 方法启动子进程（这里是 screencapture 命令）。因为 run() 方法可能抛出错误，所以使用 try 关键字并放在 do 块中
            try task.run()
            
            // waitUntilExit() 方法阻塞当前线程，直到子进程执行完毕。这确保在截图操作完成之前不会继续执行后续代码
            task.waitUntilExit()
            getImageFromPasteboard()
        } catch {
            print("could not make a screenshot : \(error)")
        }
    }
    
    // 将NSImage 对象转换成PNG图片
    private func convertImageToPNGData(image: NSImage) -> Data? {
        
        // 从 NSImage 创建一个位图表示
        guard let tiffData = image.tiffRepresentation,
              let bitmapImageRep = NSBitmapImageRep(data: tiffData) else {
            return nil
        }
        
        // 使用位图生成 PNG数据
        let pngData = bitmapImageRep.representation(using: .png, properties: [:])
        return pngData
    }
    
   private func getImageFromPasteboard() {
       
       // 检查剪贴板里有没有符合指定类型的数据，这里是符合NSImage类支持的所有图像，如果没有就退出
        guard NSPasteboard.general.canReadItem(withDataConformingToTypes: NSImage.imageTypes) else { return }
       
       // 如果从粘贴板成功获取到图像，则 image 被赋值为该图像对象；否则，方法直接返回，不继续执行后续代码
        guard let image = NSImage(pasteboard: NSPasteboard.general) else { return }
        
        if let pngData = convertImageToPNGData(image: image) {
           
           // 获取用户文档目录路径
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

        self.images.append(image)
    }
    
    
}
