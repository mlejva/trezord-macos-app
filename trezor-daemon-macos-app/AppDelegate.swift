//
//  AppDelegate.swift
//  trezor-daemon-macos-app
//
//  Created by Vašek Mlejnský on 12/07/2018.
//  Copyright © 2018 Vaclav Mlejnsky. All rights reserved.
//

// https://theswiftdev.com/2017/10/27/how-to-launch-a-macos-app-at-login/

import Cocoa
import ServiceManagement

extension Notification.Name {
    static let killLauncher = Notification.Name("killLauncher")
}


@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    let process = Process()

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let helperAppId = "com.VaclavMlejnsky.trezor-daemon-macos-app-helper"
        let runningApps = NSWorkspace.shared.runningApplications
        let isRunning = !runningApps.filter { $0.bundleIdentifier == helperAppId }.isEmpty
        
        SMLoginItemSetEnabled(helperAppId as CFString, true)
        
        if isRunning {
            DistributedNotificationCenter.default().post(name: .killLauncher, object: Bundle.main.bundleIdentifier!)
        }
        
        guard let manageTrezordScriptPath = Bundle.main.path(forResource: "manage-trezord", ofType: "sh") else {
            print("script doesn't exist in app's bundle")
            return
        }
        let shellUrl = URL(fileURLWithPath: "/bin/sh")
        process.executableURL = shellUrl
        process.arguments = [manageTrezordScriptPath];
        process.terminationHandler = { (p: Process) in
            print("trezor daemon did finish")
        }
        
        let taskQueue = DispatchQueue.global(qos: DispatchQoS.QoSClass.background)
        taskQueue.async {
        }
        do {
            /* guard let trezord = Bundle.main.url(forResource: "trezord-go", withExtension: "") else {
             print("trezord-go doesn't exist in app's bundle")
             return
             } */
            try self.process.run()
        } catch {
            print("Error while trying to start trezor daemon \(error)")
        }
        
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        print("Terminating trezord...")
        process.terminate()
        process.waitUntilExit()
        print("Done")
    }
}

