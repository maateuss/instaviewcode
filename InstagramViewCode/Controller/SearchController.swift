//
//  SearchController.swift
//  InstagramViewCode
//
//  Created by Mateus Santos on 12/09/21.
//
import UIKit

private let reuseIdentifier = "UserCell"

class SearchController : UITableViewController{


    // MARK: - Properties

    var users = [User]()
    var filteredUsers = [User]()
    
    private var inSearchMode : Bool {
        return searchController.isActive && !searchController.searchBar.text!.isEmpty
    }
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureSearchController()
        configureTableView()
        fetchUsers()
    }
    
    // MARK: - API
    
    func fetchUsers(){
        UserService.fetchUsers(completion: { users in
            self.users = users
            self.tableView.reloadData()
        })
        
    }
                                
    
    
    // MARK: - Helpers
    
    
    func configureTableView(){
        view.backgroundColor = .white
        
        tableView.register(UserCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.rowHeight = 64
    }
    
    
    func configureSearchController(){
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search"
        searchController.delegate = self
        navigationItem.searchController = searchController
        definesPresentationContext = false
        
    }
    
    
}


// MARK: - UITableViewDataSource

extension SearchController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return inSearchMode ? filteredUsers.count : users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! UserCell
        
        let user = inSearchMode ? filteredUsers[indexPath.row] : users[indexPath.row]
        
        cell.viewModel = UserCellViewModel(user: user)
        return cell
    }
    
    
    //MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let userSelected = inSearchMode ? filteredUsers[indexPath.row] : users[indexPath.row]
        
        let controller = ProfileController(user: userSelected)
        navigationController?.pushViewController(controller, animated: true)
        
    }
}

extension SearchController: UISearchControllerDelegate {
    
}
// MARK: - UISearchResultsUpdating
 

extension SearchController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text?.lowercased() else { return }
        filteredUsers = users.filter({
            $0.username.lowercased().contains(searchText) || $0.fullname.lowercased().contains(searchText)
        })
        
        self.tableView.reloadData()
        
        
    }
    
    
}
