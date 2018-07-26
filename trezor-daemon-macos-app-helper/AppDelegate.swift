//
//  AppDelegate.swift
//  trezor-daemon-macos-app-helper
//
//  Created by Vašek Mlejnský on 12/07/2018.
//  Copyright © 2018 Vaclav Mlejnsky. All rights reserved.
//

import Cocoa

extension Notification.Name {
    static let killLauncher = Notification.Name("killLauncher")
}


@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @objc func terminate() {
        NSApp.terminate(nil)
    }

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        let mainAppIdentifier = "com.VaclavMlejnsky.trezor-daemon-macos-app"
        let runningApps = NSWorkspace.shared.runningApplications
        let isRunning = !runningApps.filter { $0.bundleIdentifier == mainAppIdentifier }.isEmpty
        
        if !isRunning {
            DistributedNotificationCenter.default().addObserver(self,
                                                                selector: #selector(self.terminate),
                                                                name: .killLauncher,
                                                                object: mainAppIdentifier)
            
            let path = Bundle.main.bundlePath as NSString
            var components = path.pathComponents
            components.removeLast()
            components.removeLast()
            components.removeLast()
            components.append("MacOS")
            components.append("trezor-daemon-macos-app") //main app name
            
            let newPath = NSString.path(withComponents: components)
            
            NSWorkspace.shared.launchApplication(newPath)
        
        }
        else {
            self.terminate()
        }
        
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
}

