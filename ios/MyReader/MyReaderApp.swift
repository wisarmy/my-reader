//
//  MyReaderApp.swift
//  MyReader
//
//  Created by 高明军 on 2023/5/4.
//

import SwiftUI
import UIKit

@main
struct MyReaderApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
protocol ModuleDelegate: AnyObject {
    func presentAlert(_ title: String, message: String, from viewController: UIViewController)
    func presentError(_ error: Error?, from viewController: UIViewController)
}
