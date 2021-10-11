//
//  ResetPasswordController.swift
//  InstagramViewCode
//
//  Created by Mateus Santos on 10/10/21.
//

import UIKit

protocol ResetPasswordControllerDelegate: AnyObject {
    func didSendPasswordLink(_ controller:ResetPasswordController)
    
}

class ResetPasswordController : UIViewController {
    // MARK: - Properties
    
    private var viewModel = ResetPasswordViewModel()
    
    weak var delegate: ResetPasswordControllerDelegate?
    
    private let iconImage: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "Instagram_logo_white"))
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    private let emailTextField: UITextField = {
        let tf = CustomTextField(placeholder: "Email")
        tf.keyboardType = .emailAddress
        
        return tf
    }()
    
    
    private let performResetButton: UIButton = {
        let button = UIButton(type: .system)
        button.setHeight(50)
        button.isEnabled = false
        button.setTitle("Reset Password", for:.normal)
        button.setTitleColor(.white.withAlphaComponent(0.67), for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 20)
        button.backgroundColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1).withAlphaComponent(0.5)
        button.addTarget(self, action: #selector(handleResetPassword), for: .touchUpInside)
        return button
    }()
    
    private let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(handleBackButton), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad(){
        configureUI()
        configureNotificationObservers()
        
    }
    
    // MARK: - Helpers
    
    func configureUI(){
        configureGradientLayer()
        
        view.addSubview(backButton)
        backButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, paddingTop: 16, paddingLeft: 16)
        
        view.addSubview(iconImage)
        iconImage.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 32, width: 120,  height: 80)
        iconImage.centerX(inView: view)
        
        
        let stack = UIStackView(arrangedSubviews: [emailTextField, performResetButton])
        stack.axis = .vertical
        stack.spacing = 20
        
        view.addSubview(stack)
        stack.anchor(top: iconImage.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 32, paddingLeft: 32, paddingRight: 32)
        
        
    }
    
    func configureNotificationObservers() {
        emailTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        
    }
    
    
    
    // MARK: - Action
    @objc func handleBackButton(){
        navigationController?.popViewController(animated: true)
    }
    
    
    @objc func textDidChange(sender: UITextView) {
        viewModel.email = sender.text
        updateForm()
    }
    

    @objc func handleResetPassword(){
        guard let email = viewModel.email else {return }
        showLoad(true)
        AuthService.resetPassword(withEmail: email ) { error in
            self.showLoad(false)
            if error != nil { return }
            self.delegate?.didSendPasswordLink(self)
        }
    }
    
}

extension ResetPasswordController : FormViewModel{
    func updateForm() {
        performResetButton.backgroundColor = viewModel.buttonBackgroundColor
        performResetButton.setTitleColor(viewModel.buttonTitleColor, for: .normal)
        performResetButton.isEnabled = viewModel.formIsValid
    }
}
