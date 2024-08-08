import Foundation


struct Simulator {
    let executor = Executor()

    func startProcess() {
        Networking.startSession { sessionData in
            guard let sessionID = sessionData["session_id"] as? String else { return }
            self.pollServer(sessionID: sessionID)
        }
    }

    private func pollServer(sessionID: String) {
        var lastAction = "START"
        var lastActionTimestamp = Date().iso8601withFractionalSeconds

        Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { timer in
            Networking.sendScreenshot(sessionID: sessionID, lastAction: lastAction, lastActionTimestamp: lastActionTimestamp) { response in
                guard let actionCommand = response["next_action"] as? String else {
                    print("Session ended by server or error.")
                    timer.invalidate()
                    return
                }

                if actionCommand == "END" {
                    print("Session ended by the server.")
                    timer.invalidate()
                    return
                }

                Executor.executeCommand(actionCommand)
                lastAction = actionCommand
                lastActionTimestamp = Date().iso8601withFractionalSeconds
            }
        }
    }
}


extension Date {
    var iso8601withFractionalSeconds: String {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter.string(from: self)
    }
}
