import SwiftUI

struct ForgotPasswordView: View {
    @StateObject var viewModel: ForgotPasswordViewModel
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    

    var body: some View {
        VStack {
            Image("person")
                .padding(.bottom, 40)
            
            Text("Forgot\nPassword?")
                .font(.system(size: 30).bold())
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 30)
                .padding(.bottom, 5)
            
            Text("Don't worry! It happens. Please enter your Email.\nWe will send you reset link on that mail.")
                .font(.system(size: 14).italic())
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 30)
                .foregroundColor(Color(uiColor: .systemGray))
            
            TextField("", text: $viewModel.email)
                .placeholder("Enter Email...", when: $viewModel.email.wrappedValue.isEmpty)
                .padding()
                .background(RoundedRectangle(cornerRadius: 10.0).fill(Color("MainBackground")))
                .overlay(RoundedRectangle(cornerRadius: 10.0).strokeBorder(Color.black, style: StrokeStyle(lineWidth: 2.0)))
                .padding()
                .foregroundColor(.black)
            
            Button {
                if viewModel.mailValidator() {
                    viewModel.sendForgotPasswordRequest()
                }
            } label: {
                
                Text("SEND")
                    .font(.system(size: 14).bold())
                    .padding(.vertical, 20)
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.white)
                    .background(Color.black)
                    .cornerRadius(15)
                    .shadow(color: Color.black.opacity(0.7), radius: 5, x: 5, y: 5)
            }
            .padding(.horizontal, 20)
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("MainBackground"))
        .overlay {
            if viewModel.isProcessing {
                ProgressView()
                    .frame(width: 50, height: 50, alignment: .center)
                    .background(Color.gray)
                    .cornerRadius(10)
            }
        }
        .alert(isPresented: $viewModel.showAlert) {
            Alert(title: Text(""), message: Text($viewModel.alertMessage.wrappedValue), dismissButton: .default(Text("OK")) {
                if viewModel.mailSent{
                    self.presentationMode.wrappedValue.dismiss()
                }
            })
        }
    }
}

struct ForgotPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ForgotPasswordView(viewModel: ForgotPasswordViewModel(firebaseService: FirebaseService()))
    }
}
