//
//  CommentController.swift
//  InstagramViewCode
//
//  Created by Mateus Santos on 04/10/21.
//

import Foundation
import UIKit

private let commentCellReuseIdentifier = "CommentCell"

class CommentController : UICollectionViewController {
    
    // MARK: - Properties
    
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
    }
    
    override var inputAccessoryView: UIView? {
        get { return commentInputView}
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
 
    override func viewWillDisappear(_ animated: Bool){
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    // MARK: - Helpers
    
    func configureCollectionView(){
        collectionView.backgroundColor = .white
        navigationItem.titleView?.backgroundColor = .white
        navigationItem.title = "Comments"
        collectionView.register(CommentCell.self, forCellWithReuseIdentifier: commentCellReuseIdentifier)
        collectionView.alwaysBounceVertical = true
        collectionView.keyboardDismissMode = .interactive
    }
    
}



extension CommentController{
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: commentCellReuseIdentifier, for: indexPath) as! CommentCell
    
        return cell
    }
    
}

extension CommentController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: view.frame.width, height: 80)
    }
}


extension CommentController : CommentInputAcessoryViewDelegate {
    func inputView(_ inputView: CommentInputAcessoryView, wantsToSendComment: String) {
        inputView.clearCommentTextView()
        print("\(wantsToSendComment)")
        
    }
    
    
}
