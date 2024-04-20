//
//  ContentView.swift
//  FirebasePhoneLogin
//
//  Created by Aung Ko Min on 19/4/24.
//

import SwiftUI
import CountryPhoneCodeTextField
import XUI

public struct PhoneOTPLoginView: View {
    
    @State private var phoneNumber = PhoneNumber.locale
    @State private var otp = ""
    @StateObject private var viewModel = PhoneOTPViewModel()
    
    public init() {
        
    }
    public var body: some View {
        Form {
            Section {
                PhoneNumberTextField(phoneNumber: $phoneNumber)
                TextField("OTP", text: $otp)
                    .textContentType(.oneTimeCode)
            } header: {
                VStack {
                    if viewModel.step == .loading {
                        ProgressView()
                    }
                    Text("Please enter the mobile number")
                }
            } footer: {
                Button {
                    if viewModel.step == .requestCode {
                        viewModel.sendCode(phoneNumber: phoneNumber.formattedNumber.trimmingCharacters(in: .whitespacesAndNewlines))
                    } else {
                        viewModel.verifyCode(code: otp)
                    }
                } label: {
                    if viewModel.step == .requestCode {
                        Text("Get OTP")
                    } else {
                        Text("Verify OTP")
                    }
                    
                }
                ._borderedProminentButtonStyle()
            }
        }
    }
}
