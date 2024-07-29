import Quartz

struct EventMasks {
    static let keyDownMask = 1 << CGEventType.keyDown.rawValue
    static let keyUpMask = 1 << CGEventType.keyUp.rawValue
    static let leftMouseDownMask = 1 << CGEventType.leftMouseDown.rawValue
    static let leftMouseUpMask = 1 << CGEventType.leftMouseUp.rawValue
    static let rightMouseDownMask = 1 << CGEventType.rightMouseDown.rawValue
    static let rightMouseUpMask = 1 << CGEventType.rightMouseUp.rawValue
    static let mouseMovedMask = 1 << CGEventType.mouseMoved.rawValue
    static let leftMouseDraggedMask = 1 << CGEventType.leftMouseDragged.rawValue
    static let rightMouseDraggedMask = 1 << CGEventType.rightMouseDragged.rawValue
    static let scrollWheelMask = 1 << CGEventType.scrollWheel.rawValue

    static let allEventsMask: CGEventMask = {
        return CGEventMask(keyDownMask) |
               CGEventMask(keyUpMask) |
               CGEventMask(leftMouseDownMask) |
               CGEventMask(leftMouseUpMask) |
               CGEventMask(rightMouseDownMask) |
               CGEventMask(rightMouseUpMask) |
               CGEventMask(mouseMovedMask) |
               CGEventMask(leftMouseDraggedMask) |
               CGEventMask(rightMouseDraggedMask) |
               CGEventMask(scrollWheelMask)
    }()
    // 定义一个字典，将 CGEventType 的原始值映射到相应的操作名
    static let eventTypeNames: [CGEventType: String] = [
        .keyDown: "Key Down",
        .keyUp: "Key Up",
        .flagsChanged: "Flags Changed",
        .leftMouseDown: "Left Mouse Down",
        .leftMouseUp: "Left Mouse Up",
        .rightMouseDown: "Right Mouse Down",
        .rightMouseUp: "Right Mouse Up",
        .mouseMoved: "Mouse Moved",
        .leftMouseDragged: "Left Mouse Dragged",
        .rightMouseDragged: "Right Mouse Dragged",
        .scrollWheel: "Scroll Wheel",
        .tabletPointer: "Tablet Pointer",
        .tabletProximity: "Tablet Proximity",
        .otherMouseDown: "Other Mouse Down",
        .otherMouseUp: "Other Mouse Up",
        .otherMouseDragged: "Other Mouse Dragged"
    ]
}

