//
//  FeedCell.swift
//  InstagramViewCode
//
//  Created by Mateus Santos on 13/09/21.
//


import UIKit
import SDWebImage


protocol FeedCellDelegate : AnyObject {
    func cell(_ cell: FeedCell, wantsToShowCommentsFor post: Post)
}


class FeedCell: UICollectionViewCell {
   
    // MARK: - Properties
    
    weak var delegate: FeedCellDelegate?
    
    
    var viewModel: PostViewModel? {
        didSet{
            configure()
        }
    }
    
    
    private let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.isUserInteractionEnabled = true
        return iv
    }()
    
    private lazy var  usernameButton : UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitleColor(.black, for: .normal)
        btn.titleLabel?.font = .boldSystemFont(ofSize: 13)
        btn.addTarget(self, action: #selector(didTapUsername), for: .touchUpInside)
        return btn
    }()
    
    private let postImageView : UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.isUserInteractionEnabled = true

        return iv
    }()
    
    
    
    private lazy var  likeButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(#imageLiteral(resourceName: "like_unselected"), for: .normal)
        btn.tintColor = .black
        return btn
    }()
    
    private lazy var  commentButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(#imageLiteral(resourceName: "comment"), for: .normal)
        btn.tintColor = .black
        btn.addTarget(self, action: #selector(didTapComment), for: .touchUpInside)
        return btn
    }()
    
    private lazy var  shareButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(#imageLiteral(resourceName: "send2"), for: .normal)
        btn.tintColor = .black
        return btn
    }()
    
    private lazy var  bookmarkButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(#imageLiteral(resourceName: "ribbon"), for: .normal)
        btn.tintColor = .black
        return btn
    }()
    
    
    private let likesLabel :  UILabel = {
        let lbl = UILabel()
        lbl.text = "1 like"
        lbl.textColor = .black
        lbl.font = .boldSystemFont(ofSize: 12)
        return lbl
    }()
    
    
    private let captionLabel :  UILabel = {
        let lbl = UILabel()
        lbl.text = "venom boladão"
        lbl.textColor = .black
        lbl.font = .boldSystemFont(ofSize: 13)
        return lbl
    }()
    
    
    private let postLabel :  UILabel = {
        let lbl = UILabel()
        lbl.text = "2 days ago"
        lbl.font = .systemFont(ofSize: 12)
        lbl.textColor = .lightGray
        return lbl
    }()
    
    
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        addSubview(profileImageView)
        profileImageView.anchor(top: topAnchor, left: leftAnchor, paddingTop: 12, paddingLeft: 12)
        
        profileImageView.setDimensions(height: 40, width: 40)
        profileImageView.layer.cornerRadius = 20
        
        
        addSubview(usernameButton)
        usernameButton.centerY(inView: profileImageView, leftAnchor: profileImageView.rightAnchor, paddingLeft: 8)
        
        addSubview(postImageView)
        
        postImageView.anchor(top: profileImageView.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 8)
        
        postImageView.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 1, constant: 0).isActive = true
        
        configureActionButtons()
        
        addSubview(bookmarkButton)
        
        bookmarkButton.anchor(top: postImageView.bottomAnchor, right: rightAnchor,  paddingRight: 8, height: 50)
        
        addSubview(likesLabel)
        
        likesLabel.anchor(top: likeButton.bottomAnchor, left: leftAnchor, paddingTop: -4, paddingLeft: 8)
        
        addSubview(captionLabel)
        captionLabel.anchor(top: likesLabel.bottomAnchor, left: leftAnchor, paddingTop: 8, paddingLeft: 8)
        
        addSubview(postLabel)
        
        postLabel.anchor(top: captionLabel.bottomAnchor, left: leftAnchor, paddingTop: 8, paddingLeft: 8)
    
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Actions
    
    @objc func didTapUsername() {
        print("tapped username")
    }
    
    @objc func didTapComment(){
        guard let viewModel = viewModel else {
            return
        }

        delegate?.cell(self, wantsToShowCommentsFor: viewModel.post)
    }
    
    // MARK: - Helpers
    
    func configure(){
        guard let viewModel = viewModel else {
            return
        }

        captionLabel.text = viewModel.caption
        postImageView.sd_setImage(with: viewModel.imageUrl)
        profileImageView.sd_setImage(with: viewModel.profileImageUrl)
        usernameButton.setTitle(viewModel.username, for: .normal)
        
    }
    
    
    func configureActionButtons() {
        let stackView = UIStackView(arrangedSubviews: [likeButton, commentButton, shareButton])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        
        addSubview(stackView)
        stackView.anchor(top: postImageView.bottomAnchor, width: 120, height: 50)
    }
}


