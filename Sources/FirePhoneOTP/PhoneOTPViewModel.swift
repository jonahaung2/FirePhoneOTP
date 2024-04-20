//
//  ViewModel.swift
//  SwiftUI OTP
//
//  Created by Luthfi Abdul Azis on 07/03/21.
//

import Foundation
import Firebase
import SwiftUI

public class PhoneOTPViewModel: ObservableObject {
    
    enum LoginSteps: Hashable, Equatable {
        case requestCode, verifyOTP, loading
        case existingUser(User)
        case newUser(User)
        case error(String)
    }
    
    @Published var step = LoginSteps.requestCode
}

extension PhoneOTPViewModel {
    
    func sendCode(phoneNumber: String) {
        step = .loading
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { (verificationId, error) in
            if let error {
                self.step = .error(error.localizedDescription)
                return
            }
            UserDefaults.standard.set(verificationId, forKey: "verificationId")
            self.step = .verifyOTP
        }
    }
    
    func verifyCode(code: String) {
        step = .loading
        let verificationId = UserDefaults.standard.string(forKey: "verificationId") ?? ""
        let credentials = PhoneAuthProvider.provider().credential(withVerificationID: verificationId, verificationCode: code)
        
        Auth.auth().signIn(with: credentials) { (authResult, error) in
            if let error {
                self.step = .error(error.localizedDescription)
                return
            }
            guard let authResult else {
                self.step = .error("No Auth Rresults")
                return
            }
            let user = authResult.user
            self.step = authResult.additionalUserInfo?.isNewUser == true ? .newUser(user) : .existingUser(user)
        }
    }
    
    func logout() {
        do {
            try Auth.auth().signOut()
            self.step = .requestCode
        } catch {
            self.step = .error(error.localizedDescription)
        }
    }
}
