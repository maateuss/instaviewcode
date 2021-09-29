//
//  ProfileHeader.swift
//  InstagramViewCode
//
//  Created by Mateus Santos on 23/09/21.
//

import UIKit
import SDWebImage

protocol ProfileHeaderDelegate: AnyObject {
    func header(_ profileHeader: ProfileHeader, tappedActionButton user: User)
}


class ProfileHeader: UICollectionReusableView {
    // MARK: - Properties
    
    var delegate : ProfileHeaderDelegate?
    
    
    var viewModel: ProfileHeaderViewModel? {
        didSet{
            configure()
        }
    }
    private let profileImageView : UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .lightGray
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        
        return label
    }()
    
    private lazy var editProfileButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Loading", for:.normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 3
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.borderWidth = 0.5
        button.titleLabel?.font = .boldSystemFont(ofSize: 14)
        button.addTarget(self, action: #selector(HandleEditProfile), for: .touchUpInside)
        return button
    }()
    
    private lazy var postsLabel: UILabel = {
        return statUIText(value: 0, label: "posts")
    }()
    
    private lazy var followersLabel: UILabel = {
        return statUIText(value: 0, label: "followers")
    }()
    
    private lazy var followingLabel: UILabel = {
        return statUIText(value: 0, label: "following")
    }()
    
    private lazy var gridButton: UIButton = {
        let btn = UIButton(type: .system)
        var image = #imageLiteral(resourceName: "grid")
        btn.setImage(image, for: .normal)
        btn.tintColor = UIColor(white:0, alpha: 0.2)
        return btn
    }()
    private lazy var listButton: UIButton = {
        let btn = UIButton(type: .system)
        var image = #imageLiteral(resourceName: "list")
        btn.setImage(image, for: .normal)
        btn.tintColor = UIColor(white:0, alpha: 0.2)
        return btn
    }()
    
    private lazy var bookmarkButton: UIButton = {
        let btn = UIButton(type: .system)
        var image = #imageLiteral(resourceName: "ribbon")
        btn.setImage(image, for: .normal)
        btn.tintColor = UIColor(white:0, alpha: 0.2)
        return btn
    }()
    
    
    
    
    
    // MARK: - Lifecycle
    override init(frame: CGRect){
        super.init(frame: frame)
        configureUI()
    }
    
    func configureUI(){
        backgroundColor = .white
        
        addSubview(profileImageView)
        profileImageView.anchor(top: topAnchor, left: leftAnchor, paddingTop: 16, paddingLeft: 12)
        profileImageView.setDimensions(height: 80, width: 80)
        profileImageView.layer.cornerRadius = 40
        
        addSubview(nameLabel)
        nameLabel.anchor(top: profileImageView.bottomAnchor, left: leftAnchor, paddingTop: 12, paddingLeft: 12)
        
        addSubview(editProfileButton)
        editProfileButton.anchor(top: nameLabel.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 16, paddingLeft: 24, paddingRight: 24)
        let stack = UIStackView(arrangedSubviews:  [postsLabel, followersLabel, followingLabel] )
        stack.distribution = .fillEqually
        
        addSubview(stack)
        stack.centerY(inView: profileImageView)
        stack.anchor(left:profileImageView.rightAnchor, right: rightAnchor, paddingLeft: 12, paddingRight: 12, height: 50)
        
        
        let buttonStack = UIStackView(arrangedSubviews: [gridButton, listButton, bookmarkButton])
        buttonStack.distribution = .fillEqually
        
        addSubview(buttonStack)
        buttonStack.anchor(left: leftAnchor, bottom: bottomAnchor,  right: rightAnchor, height: 50)
        
        let topDivider = UIView()
        topDivider.backgroundColor = .lightGray
        
        addSubview(topDivider)
        topDivider.anchor(top: buttonStack.topAnchor, left: leftAnchor, right: rightAnchor, height: 0.5)
        
        
        let bottomDivider = UIView()
        bottomDivider.backgroundColor = .lightGray
        
        addSubview(bottomDivider)
        bottomDivider.anchor(top: buttonStack.bottomAnchor, left: leftAnchor, right: rightAnchor, height: 0.5)
        
        
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Actions
    
    @objc func HandleEditProfile (sender: UIButton){
        guard let viewModel = viewModel else {
            return
        }

        delegate?.header(self, tappedActionButton: viewModel.user)
    }
    
    // MARK: - Helper

    func configure(){
        guard let viewModel = viewModel else { return }
        nameLabel.text = viewModel.fullname
        editProfileButton.setTitle(viewModel.followButtonText, for: .normal)
        editProfileButton.setTitleColor(viewModel.followButtomTextColor, for: .normal)
        editProfileButton.backgroundColor = viewModel.followButtomBackgroundColor
        profileImageView.sd_setImage(with: viewModel.profileImageUrl)
        followersLabel.attributedText = viewModel.followers
        followingLabel.attributedText = viewModel.following
        postsLabel.attributedText = viewModel.posts
    }
    
    
    
    func statUIText(value: Int, label: String) -> UILabel {
        let lbl = UILabel()
        lbl.numberOfLines = 0
        lbl.textAlignment = .center
        return lbl
    }
    

    
    

}
