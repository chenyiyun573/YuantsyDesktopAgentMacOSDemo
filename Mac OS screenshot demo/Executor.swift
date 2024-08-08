import Foundation
import AppKit

class Executor {
    static let keyCodeMapping = [
        "a": CGKeyCode(0),
        "s": CGKeyCode(1),
        // Add other key mappings here...
    ]

    static func executeCommand(_ command: String) {
        let components = command.split(separator: ":", maxSplits: 1, omittingEmptySubsequences: false)
        guard components.count == 2 else {
            print("Invalid command format")
            return
        }
        let action = String(components[0])
        let argument = String(components[1])
        
        switch action {
        case "move":
            executeMove(params: argument)
        case "click":
            executeClick(params: argument)
        case "double-click":
            executeDoubleClick(params: argument)
        case "right-click":
            executeRightClick(params: argument)
        case "scroll":
            executeScroll(params: argument)
        case "key-down":
            executeKeyDown(params: argument)
        case "key-up":
            executeKeyUp(params: argument)
        case "press":
            executePress(params: argument)
        case "type":
            executeType(params: argument)
        case "sequence":
            executeSequence(params: argument)
        case "hold-click":
            executeHoldClick(params: argument)
        case "multi-click":
            executeMultiClick(params: argument)
        case "drag":
            executeDrag(params: argument)
        case "scroll-to":
            executeScrollTo(params: argument)
        case "autocomplete-text":
            executeAutocompleteText(params: argument)
        case "batch":
            executeBatch(params: argument)
        case "shortcut":
            executeShortcut(params: argument)
        case "special_gesture_mac":
            executeSpecialGestureMac(params: argument)
        default:
            print("Action type '\(action)' not recognized.")
        }
    }

    static func executeMove(params: String) {
        if let position = parseClickPosition(params) {
            simulateMoveMouse(to: position)
        }
    }

    static func executeClick(params: String) {
        if let position = parseClickPosition(params) {
            simulateMouseClick(at: position, button: .left)
        }
    }

    static func executeDoubleClick(params: String) {
        if let position = parseClickPosition(params) {
            simulateMouseClick(at: position, button: .left, clickCount: 2)
        }
    }

    static func executeRightClick(params: String) {
        if let position = parseClickPosition(params) {
            simulateMouseClick(at: position, button: .right)
        }
    }

    static func executeScroll(params: String) {
        if let amount = Double(params) {
            simulateMouseScroll(amount: amount)
        }
    }

    static func executeKeyDown(params: String) {
        if let keyCode = keyCodeMapping[params.lowercased()] {
            simulateKeyPress(keyCode: keyCode, keyDown: true)
        }
    }

    static func executeKeyUp(params: String) {
        if let keyCode = keyCodeMapping[params.lowercased()] {
            simulateKeyPress(keyCode: keyCode, keyDown: false)
        }
    }

    static func executePress(params: String) {
        // Placeholder: Simulate a key press
    }

    static func executeType(params: String) {
        // Placeholder: Simulate typing a string
    }

    static func executeSequence(params: String) {
        // Placeholder: Simulate a sequence of key presses
    }

    static func executeHoldClick(params: String) {
        // Placeholder: Simulate holding a click
    }

    static func executeMultiClick(params: String) {
        // Placeholder: Simulate multiple clicks
    }

    static func executeDrag(params: String) {
        // Placeholder: Simulate dragging
    }

    static func executeScrollTo(params: String) {
        // Placeholder: Simulate scrolling to a specific position
    }

    static func executeAutocompleteText(params: String) {
        // Placeholder: Autocomplete text entry
    }

    static func executeBatch(params: String) {
        let commands = params.split(separator: ";")
        for command in commands {
            executeCommand(String(command))
        }
    }

    static func executeShortcut(params: String) {
        // Placeholder: Execute a keyboard shortcut
    }

    static func executeSpecialGestureMac(params: String) {
        // Placeholder: Execute special Mac gestures like minimize, close, etc.
    }

    static func parseClickPosition(_ argument: String) -> CGPoint? {
        let components = argument.split(separator: ",")
        guard components.count == 2,
              let x = Double(components[0]),
              let y = Double(components[1]) else {
            return nil
        }
        return CGPoint(x: x, y: y)
    }

    static func simulateMouseClick(at position: CGPoint, button: CGMouseButton, clickCount: Int = 1) {
        let eventSource = CGEventSource(stateID: .hidSystemState)
        let mouseDownType: CGEventType = (button == .left) ? .leftMouseDown : .rightMouseDown
        let mouseUpType: CGEventType = (button == .left) ? .leftMouseUp : .rightMouseUp
        let mouseDown = CGEvent(mouseEventSource: eventSource, mouseType: mouseDownType, mouseCursorPosition: position, mouseButton: button)
        let mouseUp = CGEvent(mouseEventSource: eventSource, mouseType: mouseUpType, mouseCursorPosition: position, mouseButton: button)
        mouseDown?.post(tap: .cghidEventTap)
        mouseUp?.post(tap: .cghidEventTap)
    }

    static func simulateMouseScroll(amount: Double) {
        let location = NSEvent.mouseLocation
        let scrollEvent = CGEvent(scrollWheelEvent2Source: nil, units: .pixel, wheelCount: 1, wheel1: Int32(amount), wheel2: 0, wheel3: 0)
        scrollEvent?.location = location
        scrollEvent?.post(tap: .cghidEventTap)
    }

    static func simulateKeyPress(keyCode: CGKeyCode, keyDown: Bool) {
        let event = CGEvent(keyboardEventSource: nil, virtualKey: keyCode, keyDown: keyDown)
        event?.post(tap: .cghidEventTap)
    }

    static func simulateMoveMouse(to position: CGPoint) {
        let moveEvent = CGEvent(mouseEventSource: nil, mouseType: .mouseMoved, mouseCursorPosition: position, mouseButton: .left)
        moveEvent?.post(tap: .cghidEventTap)
    }
}
