//
//  Extensions.swift
//  JBWTest
//
//  Created by Kseniia Poternak on 15.05.2018.
//  Copyright © 2018 Kseniia Poternak. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {

    /// Custom alert
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok",
                                     style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }

    /// Custom button
    func buttonStyle(title: String,
                     button: UIButton,
                     color: UIColor,
                     fontSize: CGFloat) {
        button.backgroundColor = color
        button.layer.cornerRadius = 15
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: fontSize)
    }

    /// Done button for toolbar
    func makeToolBar() -> UIToolbar {
        let bar = UIToolbar(frame: CGRect(x: 0,
                                          y: 0,
                                          width: view.frame.width,
                                          height: 40))
        let doneButton = UIBarButtonItem(title: "Done",
                                         style: .done,
                                         target: nil,
                                         action: #selector(closeKeyboard))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                    target: nil,
                                    action: nil)
        bar.items = [space, doneButton]
        return bar
    }

    @objc private func closeKeyboard() {
        view.endEditing(true)
    }

}
