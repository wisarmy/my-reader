//
//  BarButtonItem.swift
//  MyReader
//
//  Created by 高明军 on 2023/5/9.
//

import Foundation
import UIKit

class BarButtonItem: UIBarButtonItem {
    typealias ActionFunc = (UIBarButtonItem) -> Void

    private var actionFunc: ActionFunc?

    convenience init(title: String?, style: UIBarButtonItem.Style, actionHandler: ActionFunc?) {
        self.init(title: title, style: style, target: nil, action: #selector(handlePress))
        target = self
        self.actionFunc = actionHandler
    }

    convenience init(image: UIImage?, style: UIBarButtonItem.Style, actionFunc: ActionFunc?) {
        self.init(image: image, style: style, target: nil, action: #selector(handlePress))
        target = self
        self.actionFunc = actionFunc
    }

    convenience init(barButtonSystemItem systemItem: UIBarButtonItem.SystemItem, actionHandler: ActionFunc?) {
        self.init(barButtonSystemItem: systemItem, target: nil, action: #selector(handlePress))
        target = self
        self.actionFunc = actionHandler
    }

    @objc func handlePress(sender: UIBarButtonItem) {
        actionFunc?(sender)
    }
}
