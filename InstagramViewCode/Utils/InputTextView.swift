//
//  InputTextView.swift
//  InstagramViewCode
//
//  Created by Mateus Santos on 28/09/21.
//

import UIKit

class InputTextView : UITextView {
    // MARK: - Properties
    
    var placeholderText: String? {
        didSet { placeholderLabel.text = placeholderText?.lowercased()}
    }
    
    
    private let placeholderLabel: UILabel = {
       let label = UILabel()
        label.textColor = .lightGray
        
        return label
    }()
    
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        addSubview(placeholderLabel)
        placeholderLabel.anchor(top: topAnchor, left: leftAnchor, paddingTop: 5, paddingLeft: 8)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleTextChanged), name: UITextView.textDidChangeNotification, object: nil)
        
    }
    
    
    required init?(coder: NSCoder){
        fatalError("init(coder:) has note been implemented")
    }
    
    // MARK: - Actions
    
    
    @objc func handleTextChanged(){
        placeholderLabel.isHidden = !text.isEmpty
    }
    
    
    
}
