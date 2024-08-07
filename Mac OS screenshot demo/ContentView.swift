import SwiftUI

struct ContentView: View {
    @StateObject var vm = ScreencaptureViewModel()  // ViewModel for handling screenshots
    @StateObject var eventTapManager = EventTapManager()  // Manager for handling event taps
    let simulator = Simulator()  // Simulator for handling command execution
    @State private var command = ""  // State variable to store the command input
    
    var body: some View {
        VStack {
            // Display each captured image
            ForEach(vm.images, id: \.self) { image in
                Image(nsImage: image)
                    .resizable()
                    .scaledToFit()
                    .onDrag({ NSItemProvider(object: image) })
                    .draggable(image)
            }
            
            HStack {
                // Button to take an area screenshot
                Button("Make a area screenshot") {
                    vm.takeScreenshot(for: .area)
                }
                
                // Button to take a window screenshot
                Button("Make a window screenshot") {
                    vm.takeScreenshot(for: .window)
                }
                
                // Button to take a full screenshot
                Button("Make a full screenshot") {
                    vm.takeScreenshot(for: .full)
                }
            }
            
            HStack {
                // TextField to enter a command
                TextField("Enter command", text: $command)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                // Button to start the simulation based on the command input
                Button("Start Simulation") {
                    simulator.handleCommand(command)
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                .keyboardShortcut("S", modifiers: [.command]) // 添加快捷键 Cmd+S
            }
        }
        .padding()
    }
}

// Preview for the ContentView
#Preview {
    ContentView()
}
