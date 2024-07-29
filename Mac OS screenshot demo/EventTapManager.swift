import Foundation
import CoreGraphics
import Quartz
import Carbon
import Combine

class EventTapManager: ObservableObject {
    var eventTap: CFMachPort?
    
    // 存储鼠标的位置
    @Published var mouseStartPosition: CGPoint?
    @Published var mouseEndPosition: CGPoint?
    
    let eventTypeNames: [CGEventType: String] = EventMasks.eventTypeNames
    
    init() {
        let eventOfInterest = EventMasks.allEventsMask
        
        let eventTap = CGEvent.tapCreate(
            tap: .cgSessionEventTap,
            place: .headInsertEventTap,
            options: .defaultTap,
            eventsOfInterest: CGEventMask(eventOfInterest),
            callback: EventTapManager.eventTapCallback,
            userInfo: Unmanaged.passUnretained(self).toOpaque()
        )

        if let eventTap = eventTap {
            let runLoopSource = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, eventTap, 0)
            CFRunLoopAddSource(CFRunLoopGetCurrent(), runLoopSource, .commonModes)
            CGEvent.tapEnable(tap: eventTap, enable: true)
            self.eventTap = eventTap
        } else {
            print("Failed to create event tap")
        }
    }
    
    deinit {
        if let eventTap = eventTap {
            CFMachPortInvalidate(eventTap)
        }
    }
    
    private static let eventTapCallback: CGEventTapCallBack = { (proxy, type, event, refcon) -> Unmanaged<CGEvent>? in
        let manager = Unmanaged<EventTapManager>.fromOpaque(refcon!).takeUnretainedValue()
        
        // 打印事件类型名称
        if let eventName = manager.eventTypeNames[type] {
            print("Event type: \(eventName)")
        } else {
            print("Event type: \(type.rawValue)")
        }
        
        // 打印键盘按键代码并获取 Unicode 字符串
        if type == .keyDown  {
            let keyCode = event.getIntegerValueField(.keyboardEventKeycode)
            print("Key code: \(keyCode)")
            
            let maxStringLength = 4
            var actualStringLength = 0
            var unicodeString = [UniChar](repeating: 0, count: maxStringLength)
            
            event.keyboardGetUnicodeString(maxStringLength: maxStringLength, actualStringLength: &actualStringLength, unicodeString: &unicodeString)
            
            let characters = String(utf16CodeUnits: unicodeString, count: actualStringLength)
            print("Characters: \(characters)")
            
        }
        

        
        // 打印鼠标按键情况
        if type == .leftMouseDown || type == .rightMouseDown {
            let mouseCode = event.getIntegerValueField(.mouseEventClickState)
            print("Mouse state: \(mouseCode)")
        }
        
        // 查看鼠标位置的移动情况
        if type == .mouseMoved {
            let mouseLocation = event.location
            
            if manager.mouseStartPosition == nil {
                manager.mouseStartPosition = mouseLocation
            } else {
                manager.mouseEndPosition = mouseLocation
                // 打印鼠标的起始和终止位置
                print("Mouse moved from: \(manager.mouseStartPosition!) to \(manager.mouseEndPosition!)")
                // 更新起始位置为当前终止位置
                manager.mouseStartPosition = mouseLocation
            }
        }
        
        // 返回事件（传递事件）
        return Unmanaged.passUnretained(event)
    }
}
