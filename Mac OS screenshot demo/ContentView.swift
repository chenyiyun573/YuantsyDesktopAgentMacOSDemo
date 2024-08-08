import SwiftUI

struct ContentView: View {
    @StateObject var vm = ScreencaptureViewModel()  // ViewModel for handling screenshots
    
    let simulator = Simulator()  // Simulator for handling command execution
    
    
    var body: some View {
        VStack {
            
            
            
            HStack {
                
                Button("Start Simulation") {
                    simulator.startProcess()
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
