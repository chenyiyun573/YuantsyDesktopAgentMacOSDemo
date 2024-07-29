import Foundation
import ApplicationServices

class Simulator {
    let keyCodeMapping: [String: CGKeyCode] = [
        "a": 0,
        "s": 1,
        "d": 2,
        "f": 3,
        "h": 4,
        "g": 5,
        "z": 6,
        "x": 7,
        "c": 8,
        "v": 9,
        "b": 11,
        "q": 12,
        "w": 13,
        "e": 14,
        "r": 15,
        "y": 16,
        "t": 17,
        "1": 18,
        "2": 19,
        "3": 20,
        "4": 21,
        "6": 22,
        "5": 23,
        "=": 24,
        "9": 25,
        "7": 26,
        "-": 27,
        "8": 28,
        "0": 29,
        "]": 30,
        "o": 31,
        "u": 32,
        "[": 33,
        "i": 34,
        "p": 35,
        "l": 37,
        "j": 38,
        "'": 39,
        "k": 40,
        ";": 41,
        "\\": 42,
        ",": 43,
        "/": 44,
        "n": 45,
        "m": 46,
        ".": 47,
        "`": 50,
        "space": 49,
        "return": 36,
        "tab": 48,
        "delete": 51,
        "escape": 53,
        "command": 55,
        "shift": 56,
        "caps lock": 57,
        "option": 58,
        "control": 59,
        "right shift": 60,
        "right option": 61,
        "right control": 62,
        "function": 63,
        "f17": 64,
        "volume up": 72,
        "volume down": 73,
        "mute": 74,
        "f18": 79,
        "f19": 80,
        "f20": 90,
        "f5": 96,
        "f6": 97,
        "f7": 98,
        "f3": 99,
        "f8": 100,
        "f9": 101,
        "f11": 103,
        "f13": 105,
        "f16": 106,
        "f14": 107,
        "f10": 109,
        "f12": 111,
        "f15": 113,
        "help": 114,
        "home": 115,
        "page up": 116,
        "forward delete": 117,
        "f4": 118,
        "end": 119,
        "f2": 120,
        "page down": 121,
        "f1": 122,
        "left arrow": 123,
        "right arrow": 124,
        "down arrow": 125,
        "up arrow": 126
    ]

    func simulateKeyPress(keyCode: CGKeyCode, keyDown: Bool) {
        if let event = CGEvent(keyboardEventSource: nil, virtualKey: keyCode, keyDown: keyDown) {
            event.post(tap: .cghidEventTap)
        }
    }

    func typeCharacter(_ character: String) {
        if character.lowercased() == "shift" {
            let shiftKeyCode: CGKeyCode = 56 // SHIFT key
            simulateKeyPress(keyCode: shiftKeyCode, keyDown: true)
            simulateKeyPress(keyCode: shiftKeyCode, keyDown: false)
            return
        }

        guard let keyCode = keyCodeMapping[character.uppercased()] else {
            print("Key not found for character: \(character)")
            return
        }

        let shiftKeyCode: CGKeyCode = 56 // SHIFT key

        // 检查字符是否需要 SHIFT 键
        if character.uppercased() == character && character.count == 1 {
            simulateKeyPress(keyCode: shiftKeyCode, keyDown: true)
        }

        simulateKeyPress(keyCode: keyCode, keyDown: true)
        simulateKeyPress(keyCode: keyCode, keyDown: false)

        if character.uppercased() == character && character.count == 1 {
            simulateKeyPress(keyCode: shiftKeyCode, keyDown: false)
        }
    }

    func typeString(_ string: String) {
        for character in string {
            typeCharacter(String(character))
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
            if let keyCode = keyCodeMapping[argument.uppercased()] {
                simulateKeyPress(keyCode: keyCode, keyDown: true)
            } else {
                print("Key not found for command: \(argument)")
            }
        case "key-up":
            if let keyCode = keyCodeMapping[argument.uppercased()] {
                simulateKeyPress(keyCode: keyCode, keyDown: false)
            } else {
                print("Key not found for command: \(argument)")
            }
        case "press":
            if let keyCode = keyCodeMapping[argument.uppercased()] {
                simulateKeyPress(keyCode: keyCode, keyDown: true)
                simulateKeyPress(keyCode: keyCode, keyDown: false)
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
