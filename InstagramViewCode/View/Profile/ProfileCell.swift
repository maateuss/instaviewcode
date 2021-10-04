//
//  ProfileCell.swift
//  InstagramViewCode
//
//  Created by Mateus Santos on 23/09/21.
//

import UIKit
import SDWebImage

class ProfileCell : UICollectionViewCell {
    
    // MARK: - Properties
    var viewModel: PostViewModel? {
        didSet {
            postImageView.sd_setImage(with: viewModel?.imageUrl)
        }
    }
    
    
    private let postImageView : UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .systemGray
        iv.clipsToBounds = true
        return iv
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect){
        super.init(frame: frame)
        configureUI()
    }
    
    func configureUI(){
        backgroundColor = .purple
        if let viewModel = viewModel {
            postImageView.sd_setImage(with: viewModel.imageUrl)
        }
        addSubview(postImageView)
        postImageView.fillSuperview()
    }
    
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
