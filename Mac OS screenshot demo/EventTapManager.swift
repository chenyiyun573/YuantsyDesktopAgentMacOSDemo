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
    
    // 用于记录修饰键的状态
    var shiftKeyDown = false
    var controlKeyDown = false
    var optionKeyDown = false
    var commandKeyDown = false
    var capslockKeyDown = false
    var helpKeyDown = false
    var fnKeyDown = false
    
    let eventTypeNames: [CGEventType: String] = EventMasks.eventTypeNames
    let reversedKeyCodeMapping: [Int64: String] = EventMasks.reversedKeyCodeMapping
    
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
            //print("Event type: \(eventName)")
        } else {
            print("Event type: \(type.rawValue)")
        }
        let keyCode = event.getIntegerValueField(.keyboardEventKeycode)
        let flags = event.flags
        if type == .keyDown && keyCode <= 50 {
            
            // 输出原始字符
            let maxStringLength = 4
            var actualStringLength = 0
            var unicodeString = [UniChar](repeating: 0, count: maxStringLength)
            
            event.keyboardGetUnicodeString(maxStringLength: maxStringLength, actualStringLength: &actualStringLength, unicodeString: &unicodeString)
            
            let characters = String(utf16CodeUnits: unicodeString, count: actualStringLength)
            
            
            if characters == "\u{9}" {
                print("key-down: tab")
            }
            else if characters == "\u{D}" {
                print("key-down: return")
            }
            else if characters == "\u{20}" {
                print("key-down: space")
            }
            else {
                print("key-down: \(characters)")
            }
            
        }
        
        if type == .keyUp && keyCode <= 50 {
            
            // 可以检测到大写还是小写字符
            let maxStringLength = 4
            var actualStringLength = 0
            var unicodeString = [UniChar](repeating: 0, count: maxStringLength)
            
            event.keyboardGetUnicodeString(maxStringLength: maxStringLength, actualStringLength: &actualStringLength, unicodeString: &unicodeString)
            
            let characters = String(utf16CodeUnits: unicodeString, count: actualStringLength)
            if characters == "\u{9}" {
                print("key-up: tab")
            }
            else if characters == "\u{D}" {
                print("key-up: return")
            }
            else if characters == "\u{20}" {
                print("key-up: space")
            }
            else {
                print("key-up: \(characters)")
            }
        }
            
        // 对于keycode大于50的情况
        if type == .keyUp && keyCode > 50 {
            
            if let characters = manager.reversedKeyCodeMapping[keyCode] {
                print("key-up: \(characters)")
            } else {
                print("key-up: 无效的keyCode")
            }
        }

        if type == .keyDown && keyCode > 50 {
            
            if let characters = manager.reversedKeyCodeMapping[keyCode] {
                print("key-down: \(characters)")
            } else {
                print("key-down: 无效的keyCode")
            }
        }
        
        if type == .flagsChanged {
            let shiftDown = flags.contains(.maskShift)
            let controlDown = flags.contains(.maskControl)
            let optionDown = flags.contains(.maskAlternate)
            let commandDown = flags.contains(.maskCommand)
            let capslockDown = flags.contains(.maskAlphaShift)
            let helpDown = flags.contains(.maskHelp)
            let fnDown = flags.contains(.maskSecondaryFn)
            
            if shiftDown != manager.shiftKeyDown {
                manager.shiftKeyDown = shiftDown
                print("key-\(shiftDown ?"down" :"up"): shift")

            }
            
            if controlDown != manager.controlKeyDown {
                manager.controlKeyDown = controlDown
                print("key-\(controlDown ?"down" :"up"): ctrl")
            }
            
            if optionDown != manager.optionKeyDown {
                manager.optionKeyDown = optionDown
                print("key-\(optionDown ?"down" :"up"): option")
            }
            
            if commandDown != manager.commandKeyDown {
                manager.commandKeyDown = commandDown
                print("key-\(commandDown ?"down" :"up"): command")
            }
            
            if capslockDown != manager.capslockKeyDown {
                manager.commandKeyDown = commandDown
                print("key-\(capslockDown ?"down" :"up"): caps lock")
            }
            
            if helpDown != manager.helpKeyDown {
                manager.commandKeyDown = commandDown
                print("key-\(helpDown ?"down" :"up"): help")
            }
            
            if fnDown != manager.fnKeyDown {
                manager.commandKeyDown = commandDown
                print("key-\(fnDown ?"down" :"up"): fn")
            }
            
        }
            
            // 返回事件（传递事件）
            return Unmanaged.passUnretained(event)
        }
    }
