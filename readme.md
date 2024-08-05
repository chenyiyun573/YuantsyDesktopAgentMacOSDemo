#### Table of Contents

1. Introduction
2. Requirements
3. Usage
4. Code Structure

------

#### Introduction

The **Mac OS Screenshot Demo App** is a Swift-based application designed to demonstrate the functionality of capturing screenshots and handling mouse and keyboard events on Mac OS. Currently, the functions of monitoring keyboard and mouse, saving screenshots, and simulating keyboard input have been implemented (for details, see Feishu Xianze's worklog to try MacOS Demo).

------

#### Features

- Capture screenshots of the screen.

- Handle mouse and keyboard events.

- Provide a simple user interface for interacting with the screenshot and event-handling features.

  ![whiteboard_exported_image-2](/Users/mengxianze/Desktop/Mac OS screenshot demo/images/whiteboard_exported_image-2.png)

------

#### Requirements

- macOS 10.15 or later
- Xcode 12.0 or later
- Swift 5.3 or later

------

#### Usage

1. **Launching the App:**

   - Open the app on your Mac.
   - Grant necessary permissions for screen recording and accessibility in System Preferences.

2. **Capturing Screenshots:**

   - Click the "Capture Screenshot" button to capture the current screen.

3. **Handling Mouse and Keyboard Events:**

   - The app will display the mouse and keyboard events in real-time.
   - If you want to simulate the keyboard, enter commands in the input box to simulate，the specific commands are in the Feishu document.

   ![WeChatcf124e8bc2ca2bb6298ee074ff574bd3](/Users/mengxianze/Desktop/Mac OS screenshot demo/images/WeChatcf124e8bc2ca2bb6298ee074ff574bd3.jpg)

------

#### Code Structure

1. **Simulator.swift:**
   - Handles the simulation functionalities for the application.
2. **screencaptureViewModel.swift:**
   - Contains the view model for the screen capture feature.
3. **Mouse_and_KeyBoard.swift:**
   - Defined an EventMasks struct to manage various macOS keyboard and mouse event masks and provide mappings between key codes and characters.
4. **Mac_OS_screenshot_demoApp.swift:**
   - The main application file that sets up the environment and launches the app.
5. **EventTapManager.swift:**
   - Handles the event tapping mechanism to capture and process mouse and keyboard events.
6. **ContentView.swift:**
   - Defines the user interface and user interactions for the application.

