//
//  UploadPostController.swift
//  InstagramViewCode
//
//  Created by Mateus Santos on 28/09/21.
//

import UIKit

class UploadPostController : UIViewController {
    
    // MARK: - Properties
    
    private let photoImageView: UIImageView = {
       let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.image = #imageLiteral(resourceName: "venom-7")
        iv.clipsToBounds = true
        return iv
    }()
    
    private lazy var captionTextView : InputTextView = {
        let input = InputTextView()
        input.font = .systemFont(ofSize: 16)
        input.delegate = self
        input.placeholderText = "Enter caption..."
        return input
    }()
    
    private let charCountLabel : UILabel = {
        let label = UILabel()
        label.text = "0/100"
        label.font = .systemFont(ofSize: 14)
        label.textColor = .lightGray
        return label
    
    }()
    
    
    // MARK: - Lifecycle
    override func viewDidLoad(){
        super.viewDidLoad()
        configureUI()
    }
    // MARK: - API

    // MARK: - Actions
    
    @objc func handleCancel(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func handleShare(){
        print("DEBUG: Handle share here")
    }
    
    
    
    // MARK: - Helpers
    
    func checkMaxlenght(_ textView: UITextView){
        if textView.text.count > 100 {
            textView.deleteBackward()
        }
    }
    
    
    func configureUI(){
        view.backgroundColor = .white
        navigationItem.title = "Upload Post"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleCancel))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: .done,  target: self, action: #selector(handleShare))
        
        view.addSubview(photoImageView)
        photoImageView.setDimensions(height: 180, width: 180)
        photoImageView.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 8)
        photoImageView.centerX(inView: view)
        photoImageView.layer.cornerRadius = 10
        
        
        view.addSubview(captionTextView)
        captionTextView.anchor(top: photoImageView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop:16,  paddingLeft: 12, paddingRight: 12, height: 64)
        
        view.addSubview(charCountLabel)
        charCountLabel.anchor(bottom:captionTextView.bottomAnchor, right: view.rightAnchor, paddingRight: 12)
        
    }


    
    
    
}


// MARK: - UITextViewDelegate

extension UploadPostController : UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        checkMaxlenght(textView)
        let count = textView.text.count
        charCountLabel.text = "\(count)/100"
    }
}
