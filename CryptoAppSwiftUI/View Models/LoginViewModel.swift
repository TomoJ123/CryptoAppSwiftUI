//
//  LoginViewModel.swift
//  CryptoAppSwiftUI
//
//  Created by Tomislav Jurić-Arambašić on 24.04.2022..
//

import SwiftUI

class LoginViewModel: ObservableObject {
    var firebaseService: FirebaseService
    
    // Login properties
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var firstLastName: String = ""
    @Published var showPassword: Bool = false
    
    //Register properties
    @Published var registerUser: Bool = false
    @Published var re_Enter_Password: String = ""
    @Published var showReEnterPassword: Bool = false
    
    // Alert
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    
    // Login or Register success and processing
    @Published var authSuccess: Bool = false
    @Published var isProcessing: Bool = false
    
    @Published var loggedInUser: User? = nil
    
    init(loginService: FirebaseService) {
        self.firebaseService = loginService
    }
    
    func login() {
        isProcessing = true
        firebaseService.login(userEmail: email, userPassword: password) { [weak self] isSuccess in
            guard let self = self else { return }
            
            if isSuccess.0 {
                self.getUserData()
            } else {
                self.showAlert = true
                self.alertMessage = isSuccess.1
            }
            self.isProcessing = false
        }
    }
    
    func register() {
        isProcessing = true
        firebaseService.register(userEmail: email, userPassword: password) { [weak self] isSuccess in
            guard let self = self else { return }
            
            if isSuccess.0 {
                self.getUserData()
            } else {
                self.showAlert = true
                self.alertMessage = isSuccess.1
            }
            self.isProcessing = false
        }
    }
    
    func credentialsValidator(isRegister: Bool) -> Bool {
        if isRegister {
            if !password.isPasswordSameAs(password: re_Enter_Password) {
                showAlert = true
                alertMessage = "Password are not the same!"
                return false
            }
            
            if firstLastName.isEmpty {
                showAlert = true
                alertMessage = "You need to fill out your name and last name!"
                return false
            }
        }
        
        if email.isValidEmail && password.isValidPassword {
            return true
        } else if email.isValidEmail && !password.isValidPassword {
            alertMessage = "Password is not strong enough!"
        } else if !email.isValidEmail && password.isValidPassword {
            alertMessage = "Wrong email format!"
        } else {
            alertMessage = "Password and email format is wrong!"
        }
        showAlert = true
        return false
    }
    
    func getUserData() {
        firebaseService.getUserData(email: email) { [weak self] data in
            guard let self = self else { return }
            
            guard let userData = data else {
                let newUser = User(firstLastName: self.firstLastName, money: 5000, email: self.email, portfolio: [], transactions: [])
                self.firebaseService.setUserData(userData: newUser) { [weak self] isSaved in
                    //ako nije spremljen poduzmi nesto problem je
                    UserDefaults.standard.set(newUser.email, forKey: UserDefaultsKeys.mail.rawValue)
                    self?.loggedInUser = newUser
                    self?.authSuccess = true
                    return
                }
                return
            }
            
            if let user = User.toObject(dict: userData) {
                UserDefaults.standard.set(user.email, forKey: UserDefaultsKeys.mail.rawValue)
                self.loggedInUser = user
                self.authSuccess = true
            }
        }
    }
}
