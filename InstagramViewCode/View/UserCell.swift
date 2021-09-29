//
//  UserCell.swift
//  InstagramViewCode
//
//  Created by Mateus Santos on 24/09/21.
//

import UIKit
import SDWebImage


class UserCell : UITableViewCell {
    
    // MARK: - Properties
    
    
    var viewModel: UserCellViewModel? {
        didSet{
            configure()
        }
    }
    
    private let profileImageView : UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        img.backgroundColor = .lightGray
        return img
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 14)
        return label
    }()
    
    private let fullnameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .lightGray
        return label
    }()

    
    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Helpers
    
    func configure(){
        guard let viewModel = viewModel else { return }
        usernameLabel.text = viewModel.username
        fullnameLabel.text = viewModel.fullname
        profileImageView.sd_setImage(with: viewModel.profileImageUrl)
  
    }
    
    func configureUI(){
        addSubview(profileImageView)
        profileImageView.setDimensions(height: 48, width: 48)
        profileImageView.layer.cornerRadius = 24
        profileImageView.centerY(inView: self, leftAnchor: leftAnchor, paddingLeft: 12)
        
        
        let stackview = UIStackView(arrangedSubviews: [usernameLabel, fullnameLabel])
        stackview.alignment = .leading
        stackview.axis = .vertical
        stackview.spacing = 4
        
        addSubview(stackview)
        stackview.centerY(inView: profileImageView, leftAnchor: profileImageView.rightAnchor, paddingLeft: 8 )
        
        
        
        
    }
}
