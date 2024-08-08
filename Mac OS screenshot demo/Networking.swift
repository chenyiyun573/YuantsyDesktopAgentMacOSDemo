import Foundation
import AppKit

struct Networking {
    static let backendURL = URL(string: "http://agent2.yuantsy.com:8000")!

    static func startSession(completion: @escaping ([String: Any]) -> Void) {
        var request = URLRequest(url: backendURL.appendingPathComponent("/sessions/"))
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let payload = [
            "prompt": "Start of session: Download the following Github repository: Mobile Agent, Cradle Github, RustDesk Github",
            "frontend_info": [
                "screen_size": "\(NSScreen.main?.frame.size.width ?? 0)x\(NSScreen.main?.frame.size.height ?? 0)",
                "os_info": ProcessInfo.processInfo.operatingSystemVersionString
            ],
            "is_script": true,
            "is_script_link": false,
            "script_name_link": "Script_win_DownloadGithubZip"
        ] as [String : Any]

        request.httpBody = try? JSONSerialization.data(withJSONObject: payload)

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data,
                  let jsonResponse = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                print("Network error or data corrupted")
                return
            }
            completion(jsonResponse)
        }.resume()
    }

    static func sendScreenshot(sessionID: String, lastAction: String, lastActionTimestamp: String, completion: @escaping ([String: Any]) -> Void) {
        let url = backendURL.appendingPathComponent("/sessions/\(sessionID)")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        // Include other necessary setup for the request, such as setting headers

        // Here you would attach the screenshot and other data
        // This is where you might convert an NSImage to data, then send it

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data,
                  let jsonResponse = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                print("Network error or data corrupted")
                return
            }
            completion(jsonResponse)
        }.resume()
    }
}
