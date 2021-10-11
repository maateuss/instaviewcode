//
//  LoginController.swift
//  InstagramViewCode
//
//  Created by Mateus Santos on 14/09/21.
//

import UIKit

protocol AuthenticationDelegate: AnyObject {
    func authenticationDidComplete()
    
}


class LoginController : UIViewController {
    
    // MARK: - Properties
    
    private var viewModel = LoginViewModel()
    
    weak var delegate: AuthenticationDelegate?
    
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
    
    private let passwordTextField: UITextField = {
        let tf = CustomTextField(placeholder: "Password")
        tf.isSecureTextEntry = true
        
        return tf
    }()
    
    
    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setHeight(50)
        button.isEnabled = false
        button.setTitle("Log In", for:.normal)
        button.setTitleColor(.white.withAlphaComponent(0.67), for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 20)
        button.backgroundColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1).withAlphaComponent(0.5)
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        return button
    }()
    
    private lazy var forgotPasswordButton: UILabel = {
        let button = UILabel()
        button.isUserInteractionEnabled = true
        button.attributedTitle(firstPart: "Forgot your password?", secondPart: "Get help signing in.")
        let tap = UITapGestureRecognizer()
        
        
        tap.addTarget(self, action: #selector(handleRestorePassword))
        button.addGestureRecognizer(tap)
        
        
        return button
    }()
    
    
    
    private let dontHaveAccountButton: UIButton = {
        let button = UIButton(type: .system)
        
        button.attributedTitle(firstPart:  "Don't have an account? ", secondPart: "Sign Up")
        button.addTarget(self, action: #selector(handleShowSignUp), for: .touchUpInside)
        
        return button
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        configureUI()
        configureNotificationObservers()
    }
    
    // MARK: - Actions
    
    @objc func handleShowSignUp(){
        let controller = RegistrationController()
        controller.delegate = delegate
        navigationController?.pushViewController(controller, animated: true)
        
    }
    
    @objc func textDidChange(sender: UITextView) {
        
        if sender == emailTextField {
            viewModel.email = sender.text
        } else{
            viewModel.password = sender.text
        }
        updateForm()
    }
    
    @objc func handleRestorePassword(){
        let controller = ResetPasswordController()
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func handleLogin(){
            guard let email = emailTextField.text else { return }
            guard let password = passwordTextField.text else { return }
             AuthService.loginUser(withEmail: email, withPassword: password) { (result, error) in
                if let error = error{
                    print("failed to log user in \(error)")
                    return
                }
                self.delegate?.authenticationDidComplete()

             }
            
            print("failed to login")
        
        
    }

    
    // MARK: - Helpers
    
    func configureUI(){
        view.backgroundColor = .white
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .black
        configureGradientLayer()
        
        view.addSubview(iconImage)
        iconImage.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 32, width: 120,  height: 80)
        iconImage.centerX(inView: view)
        
        
        let stack = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, loginButton])
        stack.axis = .vertical
        stack.spacing = 20
        
        view.addSubview(stack)
        stack.anchor(top: iconImage.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 32, paddingLeft: 32, paddingRight: 32)
        
        
        view.addSubview(forgotPasswordButton)
        forgotPasswordButton.anchor(top: stack.bottomAnchor, left: stack.leftAnchor, right: stack.rightAnchor, paddingTop: 20)
        forgotPasswordButton.lineBreakMode = .byWordWrapping
        
        view.addSubview(dontHaveAccountButton)
        dontHaveAccountButton.centerX(inView: view)
        dontHaveAccountButton.anchor( bottom: view.safeAreaLayoutGuide.bottomAnchor)
        
    }
    
    
    func configureNotificationObservers() {
        emailTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        
    }
    

}


extension LoginController : FormViewModel{
    func updateForm() {
        loginButton.backgroundColor = viewModel.buttonBackgroundColor
        loginButton.setTitleColor(viewModel.buttonTitleColor, for: .normal)
        loginButton.isEnabled = viewModel.formIsValid
    }
}
