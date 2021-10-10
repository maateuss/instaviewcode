//
//  NotificationsController.swift
//  InstagramViewCode
//
//  Created by Mateus Santos on 12/09/21.
//

import UIKit

private let reuseIdentifier = "NotificationCell"


class NotificationsController : UITableViewController{
    
    // MARK: - Properties
    var notifications = [Notification]() {
        didSet{
            tableView.reloadData()
        }
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        fetchNotifications()
    }
    
    
    // MARK: - Helpers
    
    func configureTableView(){
        view.backgroundColor = .white
        navigationItem.title = "Notifications"
        
        
        tableView.register(NotificationCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.rowHeight = 80
        
    }
    
    // MARK: -  API
    
    func fetchNotifications(){
        NotificationService.fetchNotifications { notifications in
            self.notifications = notifications
        }
    }
    
}

extension NotificationsController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! NotificationCell
        let viewmodel = NotificationViewModel(notification: notifications[indexPath.row])
        cell.viewModel = viewmodel
        return cell
    }
    
}
