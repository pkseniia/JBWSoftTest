//
//  LogInTableViewController.swift
//  JBWTest
//
//  Created by Kseniia Poternak on 15.05.2018.
//  Copyright © 2018 Kseniia Poternak. All rights reserved.
//

import UIKit

class LogInTableViewController: UITableViewController {

    private var accessObject = [AccessToken]()
    private var messageInObject = [ErrorMessage]()

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passTextField: UITextField!
    @IBOutlet weak var logInStyle: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    // LogIn button send request for log in possibility
    @IBAction func logInButton(_ sender: UIButton) {
        guard let email = emailTextField.text,
            let pass = passTextField.text
            else { return }

        messageInObject.removeAll()
        accessObject.removeAll()
        logIn(email: email, password: pass)
    }

    // Completion handler post request for log in
    private func logIn(email: String, password: String) {

        Networking.shared.logIn(email: email, password: password) { (tokens, messages) in
            self.accessObject = tokens
            self.messageInObject = messages

            DispatchQueue.main.async {
                if self.accessObject.first?.success == 1 {

                    guard let token = self.accessObject.first?.token
                        else { return }
                    UserData.shared.token = token
                    self.performSegue(withIdentifier: AppConstans.ScreenIdentifier.ChooseLocaleID,
                                      sender: nil)
                } else {
                    guard let message = self.messageInObject.last?.message
                        else { return }

                    self.showAlert(title: "Error", message: message)
                }
            }
        }
    }

    // UI settings
    private func setupUI() {
        tableView.allowsSelection = false
        tableView.tableFooterView = UIView()
        buttonStyle(title: "Log In",
                    button: logInStyle,
                    color: .yellow,
                    fontSize: 18.0)
        let bar = makeToolBar()
        emailTextField.inputAccessoryView = bar
        passTextField.inputAccessoryView = bar
        passTextField.isSecureTextEntry = true
    }

}
