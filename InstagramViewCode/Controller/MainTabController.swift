//
//  MainTabController.swift
//  InstagramViewCode
//
//  Created by Mateus Santos on 12/09/21.
//

import UIKit
import Firebase
import YPImagePicker

class MainTabController: UITabBarController {
    

    // MARK: - Properties
    
    private var user: User? {
        didSet{
            guard let user = user else {return}
            configureViewControllers(withUser: user)
        }
    }
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        checkIfUserIsLoggedIn()
        fetchUserData()
    }
    
    // MARK: - API
    
    func fetchUserData(){
        UserService.fetchUser { user in
            self.user = user
        }
    }
    
    
    
    func checkIfUserIsLoggedIn(){
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                let controller = LoginController()
                controller.delegate = self
                let nav = UINavigationController(rootViewController: controller)
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true, completion: nil)
            }
            
        }
        
    }
    
    // MARK: - Helpers
    
    func configureViewControllers(withUser user: User){
        
        view.backgroundColor = .white
        self.delegate = self

        let layout = UICollectionViewFlowLayout()
        
        let feed = templateNavigationController(unselectedImage: #imageLiteral(resourceName: "home_unselected"), selectedImage: #imageLiteral(resourceName: "home_selected"), rootViewController: FeedController(collectionViewLayout: layout))
        
        let search = templateNavigationController(unselectedImage: #imageLiteral(resourceName: "search_unselected"), selectedImage: #imageLiteral(resourceName: "search_selected"), rootViewController: SearchController())
        
        let imgSelector = templateNavigationController(unselectedImage: #imageLiteral(resourceName: "plus_unselected"), selectedImage: #imageLiteral(resourceName: "plus_unselected"), rootViewController:  ImageSelectorController())
        
        let notifications = templateNavigationController(unselectedImage: #imageLiteral(resourceName: "like_unselected"), selectedImage: #imageLiteral(resourceName: "like_selected"), rootViewController: NotificationsController())
        
       
        let profileController = ProfileController(user: user)
        let profile = templateNavigationController(unselectedImage: #imageLiteral(resourceName: "profile_unselected"), selectedImage: #imageLiteral(resourceName: "profile_selected"), rootViewController: profileController)
        
        
        viewControllers = [feed, search, imgSelector, notifications, profile]
        tabBar.tintColor = .black
        tabBar.backgroundColor = .white
        
    }
    
    
    func templateNavigationController(unselectedImage: UIImage, selectedImage: UIImage, rootViewController: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: rootViewController)
        nav.tabBarItem.image = unselectedImage
        nav.tabBarItem.selectedImage = selectedImage
        nav.navigationBar.tintColor = .black
        nav.navigationBar.backgroundColor = .white
        return nav
    }
    
    func didFinishPickingMedia(_ picker: YPImagePicker) {
        picker.didFinishPicking { items, cancelled in
            picker.dismiss(animated: true) {
                guard let selectedImage = items.singlePhoto?.image else {return}
                
                
                let controller = UploadPostController()
                controller.delegate = self
                controller.selectedImage = selectedImage
                let nav = UINavigationController(rootViewController: controller)
                nav.modalPresentationStyle = .fullScreen
                nav.navigationBar.tintColor = .black
                nav.navigationBar.backgroundColor = .white
                self.present(nav, animated: true, completion: nil)
                
                
            }
        }
    }
    
}

//MARK: - AuthenticationDelegate

extension MainTabController : AuthenticationDelegate {
    
    func authenticationDidComplete() {
        fetchUserData()
        self.dismiss(animated: true, completion: nil)
    }
    
}


// MARK: - UITabBarControllerDelegate

extension MainTabController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        let index = viewControllers?.firstIndex(of: viewController)
        
        if index == 2 {
            
            var config = YPImagePickerConfiguration()
            config.library.mediaType = .photo
            config.shouldSaveNewPicturesToAlbum = false
            config.startOnScreen = .library
            config.screens = [.library]
            config.hidesBottomBar = false
            config.hidesStatusBar = false
            config.library.maxNumberOfItems = 1
            
            let picker = YPImagePicker(configuration:  config)
            
            picker.modalPresentationStyle = .overCurrentContext
            present(picker, animated: true, completion: nil)
            
            didFinishPickingMedia(picker)
            
        }
        
        
        return true
        
    }
}

// MARK: - UploadPostControllerDelegate

extension MainTabController : UploadPostControllerDelegate {
    func controllerDidFinishUploadingPost(_ controller: UploadPostController) {
        selectedIndex = 0
        controller.dismiss(animated: true, completion: nil)
    }
}
