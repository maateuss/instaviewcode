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
    
    
    private let refresher = UIRefreshControl()
    
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
        
        refresher.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        tableView.refreshControl = refresher
    }
    
    // MARK: -  API
    
    func fetchNotifications(){
        NotificationService.fetchNotifications { notifications in
            self.notifications = notifications
            self.checkIfUserIsFollowed()
        }
    }
    
    func checkIfUserIsFollowed(){
        notifications.forEach { notification in
            guard notification.type == .follow else { return }
            
            UserService.checkIfUserIsFollowed(uid: notification.userId) { isFollowed in
                if let index = self.notifications.firstIndex(where: {$0.id == notification.id}) {
                    self.notifications[index].isFollowedByCurrentUser = isFollowed
                }
            }
        }
    }
    
    
    // MARK: - Action
    
    @objc func handleRefresh(){
        notifications.removeAll()
        fetchNotifications()
        refresher.endRefreshing()
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
        cell.delegate = self
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showLoad(true)
        UserService.fetchPostUser(uid: notifications[indexPath.row].userId) { user in
            self.showLoad(false)
            let controller = ProfileController(user: user)
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
}

// MARK: - NotificationCellDelegate

extension NotificationsController : NotificationCellDelegate {
    func cell(_ cell: NotificationCell, wantsToFollow uid: String) {
        UserService.follow(uid: uid) { error in
            if error != nil { return }
            cell.viewModel?.notification.isFollowedByCurrentUser = true
        }
    } 
    func cell(_ cell: NotificationCell, wantsToUnfollow uid: String) {
        UserService.unfollow(uid: uid) { error in
            if error != nil { return }
            cell.viewModel?.notification.isFollowedByCurrentUser = false
        }
    }
    
    func cell(_ cell: NotificationCell, wantsToViewPost postid: String) {
        PostService.fetchPostByUID(postUid: postid) { post in
            let layout = UICollectionViewFlowLayout()
            let feedController = FeedController(collectionViewLayout: layout)
            feedController.isRootViewController = false
            feedController.posts = [post]
            self.navigationController?.pushViewController(feedController, animated: true)
        }
    }
    
    
    
    
}
