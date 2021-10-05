//
//  CommentController.swift
//  InstagramViewCode
//
//  Created by Mateus Santos on 04/10/21.
//

import Foundation
import IQKeyboardManagerSwift
import UIKit

private let commentCellReuseIdentifier = "CommentCell"

class CommentController : UICollectionViewController {
    
    // MARK: - Properties
    
    var comments = [Comment]() {
        didSet{
            getUsersAndMakeViewModels()
        }
    }
    
    var viewModels = [CommentCellViewModel]()
    
    
    var postId: String?
    
    private lazy var commentInputView: CommentInputAcessoryView = {
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 80)
        let cv = CommentInputAcessoryView(frame: frame)
        cv.delegate = self
        return cv
    }()
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        fetchComments()
    }
    
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        IQKeyboardManager.shared.enable = false
        tabBarController?.tabBar.isHidden = true
    }
 
    override func viewWillDisappear(_ animated: Bool){
        super.viewWillDisappear(animated)
        IQKeyboardManager.shared.enable = true
        tabBarController?.tabBar.isHidden = false
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override var inputAccessoryView: UIView? {
        get { return commentInputView}
    }
    
    // MARK: - API
    
    func fetchComments(){
        guard let postId = postId else {
            return
        }

        CommentService.fetchComments(postUid: postId) { comments in
            self.comments = comments
        }
    }
    
    func getUsersAndMakeViewModels(){
        showLoad(true)
        let commentsDispatchGroup = DispatchGroup()

        let _ = comments.map { comment in
            if viewModels.contains(where: { $0.uid == comment.commentUid }) { return }
            commentsDispatchGroup.enter()
            UserService.fetchPostUser(uid: comment.ownerUid) {user in
                self.viewModels.append(CommentCellViewModel(comment: comment, user: user))
                commentsDispatchGroup.leave()
            }
        }
        
        commentsDispatchGroup.notify(queue: .main){
            self.showLoad(false)
            self.collectionView.reloadData()
        }
        
    }
    

    
    // MARK: - Helpers
    
    func configureCollectionView(){
        collectionView.backgroundColor = .white
        navigationItem.titleView?.backgroundColor = .white
        navigationItem.title = "Comments"
        collectionView.register(CommentCell.self, forCellWithReuseIdentifier: commentCellReuseIdentifier)
        collectionView.alwaysBounceVertical = true
    }
    
}



extension CommentController{
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let viewModel = viewModels[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: commentCellReuseIdentifier, for: indexPath) as! CommentCell
        
        cell.viewModel = viewModel
    
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let viewModel = viewModels[indexPath.row]
        let user = viewModel.user
        let controller = ProfileController(user: user)
        navigationController?.pushViewController(controller, animated: true)
    }
    
}


// MARK: - UICollectionViewDelegateFlowLayout

extension CommentController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: view.frame.width, height: 80)
    }
}

// MARK: - CommentInputAcessoryViewDelegate
extension CommentController : CommentInputAcessoryViewDelegate {
    func inputView(_ inputView: CommentInputAcessoryView, wantsToSendComment: String) {
        guard let postId = postId else { return }
        
        showLoad(true)
        
        CommentService.uploadComment(content: wantsToSendComment, postUid: postId){error in
            self.showLoad(false)
            self.fetchComments()
        }
        
    }
    
    
}
