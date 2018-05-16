//
//  CharactersListTableViewController.swift
//  JBWTest
//
//  Created by Kseniia Poternak on 16.05.2018.
//  Copyright © 2018 Kseniia Poternak. All rights reserved.
//

import UIKit

class CharactersListTableViewController: UITableViewController {

    var selectedLocale = String()
    var userToken = String()
    var text = String()

    private var dictionary = [Character: Int]()
    private var dictionaryArray = [(Character, Int)]()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        receiveToken()
        getText(locale: selectedLocale,
                accessToken: userToken)
    }

    // Completion handler get request for get text
    private func getText(locale: String,
                         accessToken: String) {
        Networking.shared.getText(locale: locale,
                                  accessToken: accessToken) { (text) in
            DispatchQueue.main.async {
                self.text = text
                self.countCharacters()
                self.tableView.reloadData()
            }
        }
    }

    /// Calculate and put characters from text to dictionary
    private func countCharacters() {
        dictionary = text.reduce([:]) { (key, value) -> [Character: Int] in
            var key = key
            let someValue = key[value] ?? 0
            key[value] = someValue+1
            return key
        }
        for (char, count) in dictionary {
            dictionaryArray.append((char, count))
        }
        dictionaryArray.sort(by: <)
    }

    /// Receive access token from Singleton
    private func receiveToken() {
        guard let token = UserData.shared.token
            else { return }
        userToken = token
    }

    // UI settings
    private func setupUI() {
        tableView.allowsSelection = false
        navigationItem.title = AppConstans.ScreenTitles.NumberOfCharacters
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dictionaryArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = ("Character '\(dictionaryArray[indexPath.row].0)' - \(dictionaryArray[indexPath.row].1)")
        return cell
    }

}
