import SwiftUI

struct ContentView: View {
    @StateObject var vm = ScreencaptureViewModel()
    @StateObject var eventTapManager = EventTapManager()
    let simulator = Simulator()
    @State private var command = ""
    
    var body: some View {
        VStack {
            ForEach(vm.images, id: \.self) { image in
                Image(nsImage: image)
                    .resizable()
                    .scaledToFit()
                    .onDrag({ NSItemProvider(object: image) })
                    .draggable(image)
            }
            
            HStack {
                Button("Make a area screenshot") {
                    vm.takeScreenshot(for: .area)
                }
                
                Button("Make a window screenshot") {
                    vm.takeScreenshot(for: .window)
                }
                
                Button("Make a full screenshot") {
                    vm.takeScreenshot(for: .full)
                }
            }
            
            HStack {
                TextField("Enter command", text: $command)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                Button("Start Simulation") {
                    simulator.handleCommand(command)
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
