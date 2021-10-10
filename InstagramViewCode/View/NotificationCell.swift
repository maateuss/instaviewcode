//
//  NotificationCell.swift
//  InstagramViewCode
//
//  Created by Mateus Santos on 08/10/21.
//

import Foundation

import UIKit

protocol NotificationCellDelegate: AnyObject {
    
    func cell(_ cell: NotificationCell, wantsToFollow uid: String)
    func cell(_ cell: NotificationCell, wantsToUnfollow uid: String)
    func cell(_ cell: NotificationCell, wantsToViewPost postid: String)

}
class NotificationCell: UITableViewCell {
    // MARK: - Properties
    
    var viewModel: NotificationViewModel? {
        didSet{
            configure()
        }
    }
    
    weak var delegate: NotificationCellDelegate?
    
    
    lazy var profileImage : UIImageView  = {
       let iv = UIImageView()
        iv.backgroundColor = .lightGray
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        

        
        iv.layer.cornerRadius = 20
        return iv
    }()
    private lazy var followButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(.black, for: .normal)
        button.setTitle("Loading", for: .normal)
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
        followButton.setTitle(viewModel.followButtonText, for: .normal)
        followButton.backgroundColor = viewModel.followButtomBackgroundColor
        followButton.setTitleColor(viewModel.followButtomTextColor, for: .normal)
        postImage.isHidden = viewModel.shouldHidePostImage
        followButton.isHidden = !viewModel.shouldHidePostImage
        
    }
    
    func configureUI(){
        contentView.addSubview(profileImage)
        profileImage.centerY(inView: self)
        profileImage.setDimensions(height: 40, width: 40)
        profileImage.anchor(left:leftAnchor, paddingLeft: 16)

        
        
        contentView.addSubview(postImage)
        postImage.centerY(inView: self)
        postImage.setDimensions(height: 70, width: 70)
        postImage.anchor(right: rightAnchor, paddingRight: 16)
        
        contentView.addSubview(followButton)
        followButton.centerY(inView: self)
        followButton.setDimensions(height: 30, width: 100)
        followButton.anchor(right: rightAnchor, paddingRight: 16)
        
        contentView.addSubview(notificationMainText)
        notificationMainText.lineBreakMode = .byWordWrapping
        notificationMainText.centerY(inView: self)
        notificationMainText.anchor(left: profileImage.rightAnchor, right: followButton.leftAnchor, paddingLeft: 16, paddingRight: 0)
    }
    
    // MARK: - Actions
    
    @objc func HandleFollowButton(){
        guard let viewModel = viewModel else {
            return
        }
        if viewModel.notification.isFollowedByCurrentUser {
            delegate?.cell(self, wantsToUnfollow: viewModel.notification.userId)
        } else {
            delegate?.cell(self, wantsToFollow: viewModel.notification.userId)
        }
    }
    
    
    @objc func HandlePostButton(){
        guard let postid = viewModel?.notification.postId else {
            return
        }
        
        delegate?.cell(self, wantsToViewPost: postid)
    }
    
    
    @objc func HandleProfileButton(){
        print("profile button pressed")
    }
    
    
}
