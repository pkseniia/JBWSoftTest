//
//  ChooseLocaleTableViewController.swift
//  JBWTest
//
//  Created by Kseniia Poternak on 16.05.2018.
//  Copyright © 2018 Kseniia Poternak. All rights reserved.
//

import UIKit

class ChooseLocaleTableViewController: UITableViewController {

    private let listOfLocale = Locale().localeCode

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    /// Transport data to CharactersListTableVC
    private func showNextScreen(indexPath: Int) {
        let storyboard = UIStoryboard(name: AppConstans.ScreenIdentifier.Main,
                                      bundle: nil)
        let selectedLocale = listOfLocale[indexPath]

        // swiftlint:disable force_cast
        let charactersController = storyboard.instantiateViewController(withIdentifier: AppConstans.ScreenIdentifier.CharactersID) as! CharactersListTableViewController

        charactersController.selectedLocale = selectedLocale
        navigationController?.pushViewController(charactersController,
                                                 animated: true)
    }

    // UI settings
    private func setupUI() {
        navigationItem.title = AppConstans.ScreenTitles.Locale
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOfLocale.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = UITableViewCell()
        cell.textLabel?.text = listOfLocale[indexPath.row]
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        showNextScreen(indexPath: indexPath.row)
    }

}
