//
//  ProfileController.swift
//  InstagramViewCode
//
//  Created by Mateus Santos on 12/09/21.
//

import UIKit

private let cellIdentifier = "ProfileCell"
private let headerIdentifier = "ProfileHeader"


protocol ViewControllerReloaderDelegate : AnyObject {
    func shouldReload()
}

class ProfileController : UICollectionViewController{
    
    // MARK: - Properties
    
    private var user: User
    
    private var posts = [Post]() {
        didSet{
            let _ = posts.map({ print("post: \($0)")} )
            collectionView.reloadData()
        }
    }
    
    // MARK: - Lifecycle
    
    init(user: User){
        self.user = user
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getUserData()
        configureCollectionView()
    }
    
    func getUserData(){
        fetchUserStats()
        checkIfUserIsFollowed()
        fetchUserPosts()
    }
    
    
    
    // MARK: - API
    
    func checkIfUserIsFollowed(){
        UserService.checkIfUserIsFollowed(uid: user.uid) { isfollowed in
            self.user.isFollowed = isfollowed
            self.collectionView.reloadData()
        }
    }
    
    func fetchUserStats() {
        UserService.fetchUserStats(uid: user.uid) { userStats in
            self.user.stats = userStats
            self.collectionView.reloadData()
        }
    }
    
    func fetchUserPosts() {
        PostService.fetchPosts(forUser: user.uid) { posts in
            self.posts = posts
        }
    }
    
    

    func configureCollectionView(){
        navigationItem.title = user.username
        view.backgroundColor = .systemPink
        collectionView.register(ProfileCell.self, forCellWithReuseIdentifier: cellIdentifier)
        collectionView.register(ProfileHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                    withReuseIdentifier: headerIdentifier)


    }
}


// MARK: - ViewControllerReloaderDelegate

extension ProfileController : ViewControllerReloaderDelegate {
    func shouldReload(){
        getUserData()
    }
}


// MARK: - UICOllectionViewDataSource


extension ProfileController{
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let post :[Post] = [posts[indexPath.row]]
        let feedController = FeedController(collectionViewLayout: UICollectionViewFlowLayout())
        feedController.isRootViewController = false
        feedController.posts = post
        navigationController?.pushViewController(feedController, animated: true)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! ProfileCell
        let vm = PostViewModel(post: posts[indexPath.row], user: user)
        cell.viewModel = vm
        return cell
    }
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath) as! ProfileHeader
        
        header.viewModel = ProfileHeaderViewModel(user: user)
        header.delegate = self
        
        return header
        
    }
}

// MARK: - UICOllectionViewDelegate

extension ProfileController {
    
}

// MARK: - UICOllectionViewDelegateFlowLayout
extension ProfileController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 2) / 3
        
        return CGSize(width: width, height: width)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 240)
    }
    
}

// MARK: - ProfileHeaderDelegate

extension ProfileController: ProfileHeaderDelegate {
    func header(_ profileHeader: ProfileHeader, tappedActionButton user: User) {
        if user.isCurrentUser {
            print("Current User Pressed")
        }
        else if user.isFollowed{
            UserService.unfollow(uid: user.uid) { error in
                if let error = error {
                    print(" error: \(error)")
                }
                
                self.user.isFollowed = false
                self.collectionView?.reloadData()
                
            }
        } else {
            UserService.follow(uid: user.uid) { error in
                if let error = error {
                    print("error: \(error)")
                }
                
                self.user.isFollowed = true
                self.collectionView?.reloadData()
                
            }
        }
        

    }
    
    
}


