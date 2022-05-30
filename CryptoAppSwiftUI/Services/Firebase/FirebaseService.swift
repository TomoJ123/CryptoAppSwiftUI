import SwiftUI
import Firebase

class FirebaseService {
    let db = Firestore.firestore()
    
    func login(userEmail: String, userPassword: String, completion: @escaping ((Bool, String)) -> Void) {
        Auth.auth().signIn(withEmail: userEmail, password: userPassword) { authResult, error in
            if let error = error {
                completion((false, error.localizedDescription))
                return
            }
            
            switch authResult {
            case .none:
                completion((false, "There was problem with login. Check your internet or try again later"))
            case .some(_):
                completion((true, ""))
            }
        }
    }
    
    func register(userEmail: String, userPassword: String, completion: @escaping ((Bool, String)) -> Void) {
        Auth.auth().createUser(withEmail: userEmail, password: userPassword) { authResult, error in
            if let error = error {
                completion((false, error.localizedDescription))
                return
            }
            
            switch authResult {
            case .none:
                completion((false, "There was problem with registration. Check your internet or try again later!"))
            case .some(_):
                completion((true, ""))
            }
        }
    }
    
    func forgotPassword(email: String, completion: @escaping ((Bool, String)) -> Void) {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                completion((false, error.localizedDescription))
                return
            }
            completion((true, "Succesfully sent password recovery, check your mail!"))
        }
    }
    
    func getUserData(email: String, completion: @escaping ((([String: Any]?) -> Void))) {
        // Lowercased for document finding
        db.collection("Users").document(email.lowercased()).getDocument { (document, error) in
            
            if let error = error {
                completion(nil)
                return
            }
            
            if let document = document, document.exists, let data = document.data() {
                completion(data)
                return
            }
            
            completion(nil)
        }
    }
    
    func getUser(email: String, completion: @escaping ((User?) -> Void)) {
        db.collection("Users").document(email.lowercased()).getDocument { document, error in
            #warning("problem ako je error onda nismo nasli ulogiranog usera")
            if let _ = error {
                completion(nil)
                return
            }
            
            if let document = document, document.exists, let data = document.data() {
                let user = User.toObject(dict: data)
                completion(user)
            }
            
            completion(nil)
        }
    }
    
    func setUserData(userData: User, completion: @escaping ((Bool) -> Void)) {
        if let dictionary = userData.toDict() {
            db.collection("Users").document(userData.email.lowercased()).setData(dictionary) { error in
                guard error == nil else {
                    completion(false)
                    return
                }
                completion(true)
            }
        }
    }
    
    func updateBuyOptionUserData(portfolio: PortfolioModel, transaction: TransactionModel, userMail: String,completion: @escaping ((User?, String) -> Void)) {
        db.collection("Users").document(userMail.lowercased()).getDocument { [weak self] document, error in
            guard let self = self else { return }
            
            if let document = document, document.exists, let data = document.data() {
                let user = User.toObject(dict: data)
                
                if let user = user {
                    var userToUpdate = user
                    if let coinExistsIndex = userToUpdate.portfolio.firstIndex(where: { $0.symbol == portfolio.symbol }) {
                        userToUpdate.portfolio[coinExistsIndex].coins += portfolio.coins
                        userToUpdate.portfolio[coinExistsIndex].virtualAmount += portfolio.virtualAmount
                    } else {
                        userToUpdate.portfolio.append(portfolio)
                    }
                    userToUpdate.transactions.append(transaction)
                    userToUpdate.money -= Int(portfolio.virtualAmount)
                    
                    if let updatedUser = userToUpdate.toDict() {
                        self.db.collection("Users").document(userMail.lowercased()).updateData(updatedUser) { error in
                            if error == nil {
                                completion(User.toObject(dict: updatedUser), "Your transaction is saved succesfully!")
                            } else {
                                completion(nil, "Something went wrong! Try again later!")
                            }
                            return
                        }
                    }
                }
            } else {
                completion(nil, "Something went wrong! Try again later!")
                return
            }
        }
    }
}
