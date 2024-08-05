import Foundation
import ApplicationServices

class Simulator {
    
    let keyCodeMapping = EventMasks.keyCodeMapping
    
    // Function to simulate a key press event
    func simulateKeyPress(keyCode: CGKeyCode, keyDown: Bool) {
        if let event = CGEvent(keyboardEventSource: nil, virtualKey: keyCode, keyDown: keyDown) {
            event.post(tap: .cghidEventTap)
        }
    }
    
    // Function to press a keyboard event with a given Unicode string
    func pressKeyboardEvent(unicodeString: String) {
        // Ensure the string is not empty
        guard !unicodeString.isEmpty else { return }

        // Convert the string to an array of UniChar
        let characters = Array(unicodeString.utf16)
        let stringLength = characters.count

        // Create a keyboard event (key down)
        if let event = CGEvent(keyboardEventSource: nil, virtualKey: 0, keyDown: true) {
            // Set the Unicode string for the event
            event.keyboardSetUnicodeString(stringLength: stringLength, unicodeString: characters)

            // Post the event (key down)
            event.post(tap: .cghidEventTap)

            // Create a keyboard event (key up)
            if let keyUpEvent = CGEvent(keyboardEventSource: nil, virtualKey: 0, keyDown: false) {
                // Set the Unicode string for the event
                keyUpEvent.keyboardSetUnicodeString(stringLength: stringLength, unicodeString: characters)

                // Post the event (key up)
                keyUpEvent.post(tap: .cghidEventTap)
            }
        }
    }
    
    // Function to send a keyboard down event with a given Unicode string
    func sendKeyboardDownEvent(unicodeString: String) {
        // Ensure the string is not empty
        guard !unicodeString.isEmpty else { return }

        // Convert the string to an array of UniChar
        let characters = Array(unicodeString.utf16)
        let stringLength = characters.count

        // Create and post the key down event
        if let event = CGEvent(keyboardEventSource: nil, virtualKey: 0, keyDown: true) {
            event.keyboardSetUnicodeString(stringLength: stringLength, unicodeString: characters)
            event.post(tap: .cghidEventTap)
        }
    }
    
    // Function to send a keyboard up event with a given Unicode string
    func sendKeyboardUpEvent(unicodeString: String) {
        // Ensure the string is not empty
        guard !unicodeString.isEmpty else { return }

        // Convert the string to an array of UniChar
        let characters = Array(unicodeString.utf16)
        let stringLength = characters.count

        // Create and post the key up event
        if let event = CGEvent(keyboardEventSource: nil, virtualKey: 0, keyDown: false) {
            event.keyboardSetUnicodeString(stringLength: stringLength, unicodeString: characters)
            event.post(tap: .cghidEventTap)
        }
    }

    // Function to type a given string
    func typeString(_ string: String) {
        for character in string {
            print(character)
            pressKeyboardEvent(unicodeString: String(character))
        }
    }

    // Function to handle commands in the format "action:argument"
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
                    } else {
                        sendKeyboardDownEvent(unicodeString: argument)
                    }
                } else {
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
                    } else {
                        sendKeyboardUpEvent(unicodeString: argument)
                    }
                } else {
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
                    } else {
                        pressKeyboardEvent(unicodeString: argument)
                    }
                } else {
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

// Extension to check if a character is a punctuation mark
extension Character {
    var isPunctuation: Bool {
        return "!@#$%^&*()_+{}|:\"<>?[]\\;',./`~".contains(self)
    }
}
