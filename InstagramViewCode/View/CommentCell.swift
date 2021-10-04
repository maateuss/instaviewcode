//
//  CommentCell.swift
//  InstagramViewCode
//
//  Created by Mateus Santos on 04/10/21.
//

import UIKit



class CommentCell : UICollectionViewCell {
    
    // MARK: - Properties
    
    private lazy var profileImage: UIImageView = {
        let img = UIImageView()
        
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        img.backgroundColor = .systemGray
        img.layer.cornerRadius = 30
        
        return img
    }()
    
    private lazy var comment: UITextView = {
        let tv = UITextView()
        tv.isScrollEnabled = false
        
        var attrText =  NSMutableAttributedString(string: "username ", attributes: [.font : UIFont.boldSystemFont(ofSize: 14)])
        
        attrText.append(NSAttributedString(string:"comment...sad.a.sd.asd.asd. teteeteteste sdasd auhsdus", attributes: [.font : UIFont.systemFont(ofSize: 14)]))
        tv.attributedText = attrText
        
        return tv
    }()
    
    private lazy var timestampLabel: UILabel = {
        let label = UILabel()
        
        label.attributedText = NSAttributedString(string: "2 days ago", attributes: [.font: UIFont.boldSystemFont(ofSize: 14), .foregroundColor: UIColor.lightGray])
        
        return label
        
    }()
    
    
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Helpers
    
    func configureUI(){
        backgroundColor = .white
        addSubview(profileImage)
        profileImage.anchor(top: topAnchor, left: leftAnchor, paddingTop: 16, paddingLeft: 16)
        profileImage.setDimensions(height: 60, width: 60)
       
        let stack = UIStackView(arrangedSubviews: [comment, timestampLabel])
        stack.spacing = 2
        stack.axis = .vertical
        stack.distribution = .fill
        addSubview(stack)
        stack.anchor(top: topAnchor, left: profileImage.rightAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 16, paddingLeft: 10, paddingRight: 16)
        
    }
    
}

