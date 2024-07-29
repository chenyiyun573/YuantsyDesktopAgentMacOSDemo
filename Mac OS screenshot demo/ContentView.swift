//
//  ContentView.swift
//  Mac OS screenshot demo
//
//  Created by 孟贤泽 on 2024/7/23.
//

import SwiftUI

struct ContentView: View {
    // @StateObject 属性包装器在 SwiftUI 中的作用是管理和维护一个 ObservableObject 的生命周期。它确保在 SwiftUI 视图中创建的对象在视图生命周期内保持一致，并在对象的状态发生变化时触发视图更新。
    @StateObject var vm = ScreencaptureViewModel()
    @StateObject var eventTapManager = EventTapManager()
    
    
    var body: some View {
        VStack {
            
            ForEach(vm.images, id: \.self) { image in
                Image(nsImage: image)
                    .resizable()
                    .scaledToFit()
                
                    // 定义了拖动操作的行为，提供了一个闭包，该闭包返回一个 NSItemProvider 对象，封装了要拖动的图像数据
                    .onDrag({ NSItemProvider(object: image) })
                
                    // 使视图可以被拖动，使用图像数据作为拖动的数据
                    .draggable(image)
                
            }
            
            HStack {
                
                // 按钮的点击时间会调用ScreencaptureViewModel的takeScreenshot(for:) 方法，并传入并传入截图类型 作为参数
                Button("Make a area screenshot") {
                    vm.takeScreenshot(for: .area)
                }
                
                Button("Make a window screenshot") {
                    vm.takeScreenshot(for: .window)
                }
                
                Button("Make a full screenshot") {
                    vm.takeScreenshot(for: .full)
                }
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
