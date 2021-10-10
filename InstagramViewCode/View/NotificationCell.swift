//
//  NotificationCell.swift
//  InstagramViewCode
//
//  Created by Mateus Santos on 08/10/21.
//

import Foundation

import UIKit

class NotificationCell: UITableViewCell {
    // MARK: - Properties
    
    var viewModel: NotificationViewModel? {
        didSet{
            configure()
        }
    }
    
    
    lazy var profileImage : UIImageView  = {
       let iv = UIImageView()
        iv.backgroundColor = .lightGray
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        
        iv.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer()
        tap.addTarget(self, action: #selector(HandleProfileButton))
        
        iv.addGestureRecognizer(tap)
        
        iv.layer.cornerRadius = 20
        return iv
    }()
    private lazy var followButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Loading", for:.normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 3
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.borderWidth = 0.5
        button.titleLabel?.font = .boldSystemFont(ofSize: 14)
        button.addTarget(self, action: #selector(HandleFollowButton), for: .touchUpInside)
        return button
    }()
    
    lazy var postImage : UIImageView  = {
       let iv = UIImageView()
        iv.backgroundColor = .lightGray
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 5
        iv.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer()
        tap.addTarget(self, action: #selector(HandlePostButton))
        iv.addGestureRecognizer(tap)
        
        return iv
    }()
    
     
    
    
    lazy var notificationMainText : UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    
    
    
    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none

        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    func configure(){
        guard let viewModel = viewModel else {
            return
        }

        
        profileImage.sd_setImage(with: viewModel.profileImageUrl)
        if let imgUrl = viewModel.postImageUrl {
            postImage.sd_setImage(with: imgUrl)
        }
        
        notificationMainText.attributedText = viewModel.attributedMessageText
    }
    
    func configureUI(){
        addSubview(profileImage)
        profileImage.centerY(inView: self)
        profileImage.setDimensions(height: 40, width: 40)
        profileImage.anchor(left:leftAnchor, paddingLeft: 16)

        
        
        addSubview(postImage)
        postImage.centerY(inView: self)
        postImage.setDimensions(height: 70, width: 70)
        postImage.anchor(right: rightAnchor, paddingRight: 16)
        
        addSubview(notificationMainText)
        notificationMainText.lineBreakMode = .byWordWrapping
        notificationMainText.centerY(inView: self)
        notificationMainText.anchor(left: profileImage.rightAnchor, right: postImage.leftAnchor, paddingLeft: 16, paddingRight: 16)
    }
    
    // MARK: - Actions
    
    @objc func HandleFollowButton(){
        print("follow button pressed")
    }
    
    
    @objc func HandlePostButton(){
        print("post button pressed")
    }
    
    
    @objc func HandleProfileButton(){
        print("profile button pressed")
    }
    
    
}
