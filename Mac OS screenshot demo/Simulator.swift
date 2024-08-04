import Foundation
import ApplicationServices

class Simulator {
    
    let keyCodeMapping = EventMasks.keyCodeMapping
    
    func simulateKeyPress(keyCode: CGKeyCode, keyDown: Bool) {
        if let event = CGEvent(keyboardEventSource: nil, virtualKey: keyCode, keyDown: keyDown) {
            event.post(tap: .cghidEventTap)
        }
    }
    
    func pressKeyboardEvent(unicodeString: String) {
        // 确保字符串不空
        guard !unicodeString.isEmpty else { return }

        // 将字符串转换为 UniChar 数组
        let characters = Array(unicodeString.utf16)
        let stringLength = characters.count

        // 创建一个键盘事件(key down)
        if let event = CGEvent(keyboardEventSource: nil, virtualKey: 0, keyDown: true) {
            // Set the Unicode string for the event
            event.keyboardSetUnicodeString(stringLength: stringLength, unicodeString: characters)

            // Post 事件(key down)
            event.post(tap: .cghidEventTap)

            // 创建一个键盘事件(key up)
            if let keyUpEvent = CGEvent(keyboardEventSource: nil, virtualKey: 0, keyDown: false) {
                // 设置事件的 Unicode 字符串
                keyUpEvent.keyboardSetUnicodeString(stringLength: stringLength, unicodeString: characters)

                // Post 事件 (key up)
                keyUpEvent.post(tap: .cghidEventTap)
            }
        }
    }
    
    func sendKeyboardDownEvent(unicodeString: String) {
 
        guard !unicodeString.isEmpty else { return }

   
        let characters = Array(unicodeString.utf16)
        let stringLength = characters.count


        if let event = CGEvent(keyboardEventSource: nil, virtualKey: 0, keyDown: true) {
      
            event.keyboardSetUnicodeString(stringLength: stringLength, unicodeString: characters)

            event.post(tap: .cghidEventTap)
        }
    }
    
    func sendKeyboardUpEvent(unicodeString: String) {
  
        guard !unicodeString.isEmpty else { return }


        let characters = Array(unicodeString.utf16)
        let stringLength = characters.count


        if let event = CGEvent(keyboardEventSource: nil, virtualKey: 0, keyDown: false) {
     
            event.keyboardSetUnicodeString(stringLength: stringLength, unicodeString: characters)

            event.post(tap: .cghidEventTap)
        }
    }


    func typeString(_ string: String) {
        for character in string {
            print(character)
            pressKeyboardEvent(unicodeString: String(character))
        }
    }

    func handleCommand(_ command: String) {
        let components = command.split(separator: ":")
        guard components.count == 2 else {
            print("Invalid command format")
            return
        }

        let action = components[0]
        let argument = String(components[1])
        
        switch action {
        case "key-down":
            if let keyCode = keyCodeMapping[argument.lowercased()] {
                if keyCode <= 50 {
                    if argument == argument.uppercased() {
                        sendKeyboardDownEvent(unicodeString: argument.uppercased())
                    }
                    else {
                        sendKeyboardDownEvent(unicodeString: argument)
                    }
                }
                else {
                    simulateKeyPress(keyCode: keyCode, keyDown: true)
                }
            } else {
                print("Key not found for command: \(argument)")
            }
        case "key-up":
            if let keyCode = keyCodeMapping[argument.lowercased()] {
                if keyCode <= 50 {
                    if argument == argument.uppercased() {
                        sendKeyboardUpEvent(unicodeString: argument.uppercased())
                    }
                    else {
                        sendKeyboardUpEvent(unicodeString: argument)
                    }
                }
                else {
                    simulateKeyPress(keyCode: keyCode, keyDown: false)
                }
            } else {
                print("Key not found for command: \(argument)")
            }
        case "press":
            if let keyCode = keyCodeMapping[argument.lowercased()] {
                if keyCode <= 50 {
                    if argument == argument.uppercased() {
                        pressKeyboardEvent(unicodeString: argument.uppercased())
                    }
                    else {
                        pressKeyboardEvent(unicodeString: argument)
                    }
                }
                
                else {
                    simulateKeyPress(keyCode: keyCode, keyDown: true)
                    simulateKeyPress(keyCode: keyCode, keyDown: false)
                }
            } else {
                print("Key not found for command: \(argument)")
            }
        case "type":
            typeString(argument)
        case "sequence":
            let keys = argument.split(separator: "+")
            print(keys)
            for key in keys {
                if let keyCode = keyCodeMapping[String(key)] {
                    simulateKeyPress(keyCode: keyCode, keyDown: true)
                    simulateKeyPress(keyCode: keyCode, keyDown: false)
                } else {
                    print("Key not found for command: \(key)")
                }
            }
        default:
            print("Unknown action: \(action)")
        }
    }
}

extension Character {
    var isPunctuation: Bool {
        return "!@#$%^&*()_+{}|:\"<>?[]\\;',./`~".contains(self)
    }
}
