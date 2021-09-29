//
//  ProfileCell.swift
//  InstagramViewCode
//
//  Created by Mateus Santos on 23/09/21.
//

import UIKit

class ProfileCell : UICollectionViewCell {
    
    // MARK: - Properties
    
    private let postImageView : UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "venom-7")
        iv.contentMode = .scaleAspectFill
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
    
        addSubview(postImageView)
        postImageView.fillSuperview()
    }
    
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
