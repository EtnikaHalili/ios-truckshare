//
//  LoginViewController.swift
//  OrderApp
//
//  Created by Etnika Halili on 25.6.21.
//

import UIKit
import CoreData
class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailTextField: TextField!
    @IBOutlet weak var passwordTextField: TextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTextFields()
        // Do any additional setup after loading the view.
    }
    
    //IBActions
    @IBAction func registerButtonPressed(_ sender: Any) {
        navigateToSignUp()
    }
    @IBAction func loginButtonPressed(_ sender: Any) {
        checkIfIsRegistered()
    }
    
    //Functions
    func setupTextFields(){
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
    }
    
    func checkIfIsRegistered(){
        guard let email = emailTextField.text, !email.isEmpty else {
            self.emailTextField.becomeFirstResponder()
            self.showAlertWith(title: "Alert", message: "Empty email." )
            return
        }
        guard let password = passwordTextField.text, !password.isEmpty else {
            self.passwordTextField.becomeFirstResponder()
            self.showAlertWith(title: "Alert", message: "Empty password.")
            return
        }
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        
        let managedContex = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        let predicateEmail = NSPredicate(format: "email == %@", email)
        request.predicate = predicateEmail
        request.fetchLimit = 1
        
        do{
            let count = try managedContex.count(for: request)
            if(count == 0){
                // no matching object
                self.showAlertWith(title: "Alert", message: "User doesn't exist.")
            }
            else{
                // at least one matching object exists
                navigateToHomeScreen()
            }
        }
        catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    func navigateToHomeScreen(){
        let storyBoard : UIStoryboard = UIStoryboard(name: "Home", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    func navigateToSignUp(){
        let storyBoard : UIStoryboard = UIStoryboard(name: "SignUp", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let nextTag = textField.tag + 1
        
        if let nextResponder = textField.superview?.viewWithTag(nextTag) {
            nextResponder.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        
        return true
    }
}
