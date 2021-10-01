//
//  FeedController.swift
//  InstagramViewCode
//
//  Created by Mateus Santos on 12/09/21.
//

import UIKit
import Firebase
import CoreMIDI

private let reuseIdentifier = "Cell"


class FeedController : UICollectionViewController{
    
    // MARK: - Properties
    var viewModels = [PostViewModel]() {
        didSet{
            collectionView.reloadData()
        }
    }
    
    
    var posts = [Post]() {
        didSet{
            getUsersAndMakeViewmodels()
        }
    }
    
    // MARK: - Lifecycle
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchPosts()
        configureUI()
        
        
    }
    
    // MARK: - API
    
    func fetchPosts(){
        PostService.fetchPosts() {
            self.posts = $0
        }
    }
    
    
    func getUsersAndMakeViewmodels(){
        var vm = [PostViewModel]()
        let group = DispatchGroup()
        posts.forEach { post in
            group.enter()
            UserService.fetchPostUser(uid: post.ownerUid) {
                vm.append(PostViewModel(post: post, user: $0))
                group.leave()
            }
        }
        
        group.notify(queue: .main){
            self.viewModels = vm
        }
        
    }
    
    
    // MARK: - Helpers
    
    func configureUI(){
        collectionView.backgroundColor = .white
        
        
        collectionView.register(FeedCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logout))
    }
    
    // MARK: - Actions


    @objc func logout(){
        do{
            try Auth.auth().signOut()
            let controller = LoginController()
            controller.delegate = self.tabBarController as? MainTabController
            let nav = UINavigationController(rootViewController: controller)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true, completion: nil)
            
        }catch{
            print("failed to sign out")
        }
    }

    
    
}

// MARK: - UICollectionViewDataSource

extension FeedController{
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! FeedCell
        
        cell.viewModel = viewModels[indexPath.row]
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension FeedController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = view.frame.width
        var height = width + 8 + 40 + 8
        height += 50
        height += 60
        
        
        return CGSize(width: width, height: height)
    }
}


