//
//  SignInVC.swift
//  NAV
//
//  Created by Alex Chen on 2/11/23.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseCore
import GoogleSignIn
import FirebaseFirestore


class SignInVc: UIViewController {
    
    let db = Firestore.firestore()
    
    @IBOutlet weak var googleSignInButton: GIDSignInButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func viewRegister(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goToRegister", sender: self)
    }
    
    @IBAction func viewLogin(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goToLogin", sender: self)
        
    }
    
    @IBAction func signInWithGoogle(_ sender: GIDSignInButton) {
        setUpGoogle()
    }
    func setUpGoogle(){
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { [unowned self] result, error in
            guard error == nil else {
                return
            }
            
            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString
            else {
                return
            }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken: user.accessToken.tokenString)
            
            Auth.auth().signIn(with: credential)
            showApp()
        }
    }

    
    
    func showApp(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        var  viewController: UIViewController
        viewController = storyboard.instantiateViewController(withIdentifier: "Main")
        self.present(viewController, animated: true, completion: nil)
    }
}
    

