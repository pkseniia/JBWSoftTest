//
//  SignUpTableViewController.swift
//  JBWTest
//
//  Created by Kseniia Poternak on 15.05.2018.
//  Copyright © 2018 Kseniia Poternak. All rights reserved.
//

import UIKit

class SignUpTableViewController: UITableViewController {

    private var messageInObject = [ErrorMessage]()

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passTextField: UITextField!
    @IBOutlet weak var signUpStyle: UIButton!
    @IBOutlet weak var logInStyle: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    // SignUp button send request for sign up possibility
    @IBAction func signUpButton(_ sender: UIButton) {
        guard let name = nameTextField.text,
            let email = emailTextField.text,
            let pass = passTextField.text
            else { return }

        messageInObject.removeAll()
        signUp(name: name, email: email, password: pass)

    }

    // LogIn button goes to LogInTableVC
    @IBAction func logInButton(_ sender: UIButton) {
        performSegue(withIdentifier:
            AppConstans.ScreenIdentifier.LogInScreenID,
                     sender: nil)
    }

    // Completion handler post request for sign up
    private func signUp (name: String, email: String, password: String) {
        Networking.shared.signUp(name: name,
                                 email: email,
                                 password: password,
                                 completionHandler: { messages in
            self.messageInObject = messages
            DispatchQueue.main.async {
                if self.messageInObject.last?.success == 0 {
                    guard let message = self.messageInObject.first?.message
                        else { return }
                    self.showAlert(title: "Error", message: message)
                } else {
             self.successSignUp()
                }
            }
        })
    }

    /// Success alert plus clear field
    private func successSignUp() {
        self.showAlert(title: "Success",
                       message: "Your profile is created.")
        self.nameTextField.text = ""
        self.emailTextField.text = ""
        self.passTextField.text = ""
    }

    // UI settings
    private func setupUI() {
        tableView.allowsSelection = false
        tableView.tableFooterView = UIView()
        buttonStyle(title: "Sign Up",
                    button: signUpStyle,
                    color: .yellow,
                    fontSize: 18.0)
        buttonStyle(title: "Log In",
                    button: logInStyle,
                    color: .black,
                    fontSize: 15.0)
        let bar = makeToolBar()
        nameTextField.inputAccessoryView = bar
        emailTextField.inputAccessoryView = bar
        passTextField.inputAccessoryView = bar
        passTextField.isSecureTextEntry = true
    }

}
