//
//  CommentInputAcessoryView.swift
//  InstagramViewCode
//
//  Created by Mateus Santos on 04/10/21.
//

import UIKit


protocol CommentInputAcessoryViewDelegate : AnyObject{
    func inputView(_ inputView: CommentInputAcessoryView, wantsToSendComment: String)
}

class CommentInputAcessoryView: UIView {
    
    
    // MARK: - Properties
    
    
    weak var delegate : CommentInputAcessoryViewDelegate?
    
    private let commentTextView: InputTextView = {
       let input = InputTextView()
        
        input.placeholderText = "Enter comment..."
        input.font = .systemFont(ofSize: 15)
        input.isScrollEnabled = false
        return input
    }()
    
    private lazy var postButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(.black, for:.normal)
        button.setTitle("Post", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(handlePostTapped), for: .touchUpInside)
        return button
    }()
    

    
    // MARK: - Lifecycle
    
    override init (frame: CGRect){
        super.init(frame: frame)
        
        autoresizingMask = .flexibleHeight
        backgroundColor = .white
        addSubview(postButton)
        postButton.anchor(top: topAnchor, right: rightAnchor, paddingTop: 16, paddingRight: 16)
        
        addSubview(commentTextView)
        commentTextView.anchor(top: topAnchor, left: leftAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, right: postButton.leftAnchor, paddingTop: 16, paddingLeft: 8, paddingBottom: 8, paddingRight: 16)
        
        let divider = UIView()
        divider.backgroundColor = .lightGray
        addSubview(divider)
        divider.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, height: 0.5)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize{
        return .zero
    }
    // MARK: - Actions
    
    func clearCommentTextField(){
        commentTextView.text = ""
    }
    
    @objc func handlePostTapped(){
        guard let text = commentTextView.text else { return }
        delegate?.inputView(self, wantsToSendComment: text)
    }
    
    
}
