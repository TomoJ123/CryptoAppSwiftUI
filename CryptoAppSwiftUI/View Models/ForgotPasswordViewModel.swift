import SwiftUI

class ForgotPasswordViewModel: ObservableObject {
    var firebaseService: FirebaseService
    
    @Published var email: String = ""
    
    @Published var alertMessage: String = ""
    @Published var mailSent: Bool = false
    @Published var showAlert: Bool = false
    
    @Published var isProcessing: Bool = false
    
    @Published var shouldMannuallyDismiss: Bool = false
    
    init(firebaseService: FirebaseService) {
        self.firebaseService = firebaseService
    }
    
    func sendForgotPasswordRequest() {
        isProcessing = true
        firebaseService.forgotPassword(email: email) { [weak self] isSuccess in
            guard let self = self else { return }
            
            if isSuccess.0 {
                self.mailSent = true
            }
            self.alertMessage = isSuccess.1
            self.showAlert = true
            self.isProcessing = false
        }
    }
    
    func mailValidator() -> Bool {
        if email.isValidEmail {
            return true
        } else {
            self.alertMessage = "Email format is not valid!"
            self.showAlert = true
            return false
        }
    }
}
