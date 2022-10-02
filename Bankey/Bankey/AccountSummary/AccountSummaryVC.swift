//
//  AccountSummaryVC.swift
//  Bankey
//
//  Created by W Lawless on 9/24/22.
//

import UIKit

class AccountSummaryVC: UIViewController {
    
    // MARK: - Request Models
    
    var profile: Profile?
    var accountData: [Account] = []
    
    // MARK: - View Models
    
    var accounts: [AccountSummaryCell.ViewModel] = []
    
    // MARK: - Components
    
    var tableView = UITableView()
    let header = AccountSummaryHeaderView(frame: .zero)
    let refreshControl = UIRefreshControl()
    
    // MARK: - Properties
    
    var dataIsLoaded: Bool = false
    var networkManager: NetworkManageable = NetworkManager()
    
    lazy var errorAlert: UIAlertController = {
        let alert =  UIAlertController(title: "", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        return alert
    }()

    
    lazy var logoutBarButton: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logoutTapped))
        barButtonItem.tintColor = .label
        return barButtonItem
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
}

// MARK: - Layout

extension AccountSummaryVC {
    
    private func setupNav() {
        navigationItem.rightBarButtonItem = logoutBarButton
    }

    private func setup() {
        setupTableView()
        setupNav()
        setupTableHeaderView()
        setupRefreshControl()
        setupSkeletons()
        fetchData()
    }
    
    private func setupSkeletons() {
        let row = Account.makeSkeleton()
        accountData = Array(repeating: row, count: 7)
        configureTableCells(with: accountData)
    }
    
    private func setupRefreshControl() {
        refreshControl.tintColor = appColor
        refreshControl.addTarget(self, action: #selector(refreshContent), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    private func setupTableView() {
        tableView.backgroundColor = appColor

        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(AccountSummaryCell.self, forCellReuseIdentifier: AccountSummaryCell.reuseID)
        tableView.register(SkeletonCell.self, forCellReuseIdentifier: SkeletonCell.reuseID)
        
        tableView.rowHeight = AccountSummaryCell.rowHeight
        tableView.tableFooterView = UIView()
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setupTableHeaderView(){
        
        var size = header.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        size.width = UIScreen.main.bounds.width
        header.frame.size = size
        
        tableView.tableHeaderView = header
    }

}

// MARK: - Networking

extension AccountSummaryVC {
    
    private func fetchData() {
        
        let networkGroupCall = DispatchGroup()
        
        let userId = String(Int.random(in: 1..<4))
        
        fetchProfile(group: networkGroupCall, userId: userId)
        fetchAccounts(group: networkGroupCall, userId: userId)
        
        networkGroupCall.notify(queue: .main) {
            self.reloadView()
        }
    }
     
    private func fetchProfile(group: DispatchGroup, userId: String){
        group.enter()
        networkManager.fetchProfile(forUserId: userId) { result in
            switch result {
            case .success(let profile):
                self.profile = profile
            case .failure(let error):
                self.displayError(error)
            }
            group.leave()
        }
    }
    
    private func fetchAccounts(group: DispatchGroup, userId: String){
        group.enter()
        networkManager.fetchAccounts(forUserId: userId) { result in
            switch result {
            case .success(let accounts):
                self.accountData = accounts
            case .failure(let error):
                self.displayError(error)
            }
            group.leave()
        }
    }

    private func reloadView() {
        self.tableView.refreshControl?.endRefreshing()
        
        guard let profile = self.profile else { return }
        
        self.dataIsLoaded = true
        self.configureTableHeaderView(with: profile)
        self.configureTableCells(with: self.accountData)
        self.tableView.reloadData()
    }
    
    private func displayError(_ error: NetworkError) {
        let titleAndMessage = configureAlert(for: error)
        self.showErrorAlert(title: titleAndMessage.0, message: titleAndMessage.1)
    }
    
    private func configureAlert(for error: NetworkError) -> (String, String) {
        let title: String
        let message: String
        switch error {
        case .serverError:
            title = "Server Error"
            message = "We could not proccess your request."
        case .decodingError:
            title = "Network Error"
            message = "Check your connection."
        }
        return (title, message)
    }

    private func showErrorAlert(title: String, message: String) {
        errorAlert.title = title
        errorAlert.message = message
        
        present(errorAlert, animated: true, completion: nil)
    }
}

// MARK: - Expose Network to Testing

extension AccountSummaryVC {
    func configureAlertForTesting(for error: NetworkError) -> (String, String) {
        return configureAlert(for: error)
    }
    
    func forceFetchProfile() {
        fetchProfile(group: DispatchGroup(), userId: "1")
    }
    
    func forceFetchAccount() {
        fetchAccounts(group: DispatchGroup(), userId: "1")
    }
}

// MARK: - Configure Table

extension AccountSummaryVC {
    private func configureTableCells(with theData: [Account]) {
        accounts = theData.map {
            AccountSummaryCell.ViewModel(accountType: $0.type, accountName: $0.name, balance: $0.amount)
        }
    }
    
    private func configureTableHeaderView(with profile: Profile) {
        let vm = AccountSummaryHeaderView.ViewModel(welcomeMessage: "Good morning,",
                                                    name: profile.firstName,
                                                    date: Date())
        header.configure(vm: vm)
    }
}


//MARK: - Protocol-Delegate

extension AccountSummaryVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard !accounts.isEmpty else { return UITableViewCell() }
        let account = accounts[indexPath.row]
        
        if dataIsLoaded {
            let cell = tableView.dequeueReusableCell(withIdentifier: AccountSummaryCell.reuseID, for: indexPath) as! AccountSummaryCell
            cell.configure(with: account)
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: SkeletonCell.reuseID, for: indexPath) as! SkeletonCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accounts.count
    }
}

// MARK: - Protocol-Datasource

extension AccountSummaryVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

// MARK: - Button Actions

extension AccountSummaryVC {
    @objc private func logoutTapped(sender: UIButton) {
        NotificationCenter.default.post(name: .Logout, object: nil)
    }
    
    @objc private func refreshContent(sender: UIRefreshControl) {
        reset()
        setupSkeletons()
        tableView.reloadData()
        fetchData()
    }
    
    private func reset() {
        profile = nil
        accountData = []
        dataIsLoaded = false
    }
}
