//
//  View.swift
//  ViperExample
//
//  Created by Arleson Silva on 28/01/22.
//

import Foundation
import UIKit

// ViewController
// Protocol
// Reference to presenter

protocol AnyView {
    var presenter: AnyPresenter? { get set }

    func update(with users: [User])
    func update(with error: String)
}

class UserViewController: UIViewController, AnyView {

    var users: [User] = []
    var presenter: AnyPresenter?

    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        table.isHidden = true
        table.delegate = self
        table.dataSource = self
        return table
    }()

    private var labelError: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupLayout()
        setupUI()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupConstraints()
    }
    
    private func setupLayout() {
        view.backgroundColor = .systemBackground
        title = "Viper"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func setupUI() {
        view.addSubview(labelError)
        view.addSubview(tableView)
    }

    private func setupConstraints() {
        labelError.frame = CGRect(x: 0, y: 0, width: 200, height: 50)
        labelError.center = view.center
        tableView.frame = view.bounds
    }

    func update(with users: [User]) {
        DispatchQueue.main.async {
            self.users = users
            self.tableView.reloadData()
            self.tableView.isHidden = false

            self.labelError.isHidden = true
        }
    }

    func update(with error: String) {
        DispatchQueue.main.async {
            self.users = []
            self.labelError.text = error
            self.labelError.isHidden = false

            self.tableView.isHidden = true
        }
    }

}

extension UserViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = users[indexPath.row].name
        return cell
    }
}
