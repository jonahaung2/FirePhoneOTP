//
//  FirePhoneLoginView.swift
//  FirebasePhoneLogin
//
//  Created by Aung Ko Min on 21/4/24.
//

import SwiftUI
import CountryPhoneCodeTextField
import XUI

public struct FirePhoneOTPLoginView: View {
    @StateObject private var viewModel = FirePhoneOTPLoginViewModel()
    @FocusState private var focused: FirePhoneLoginViewState?
    public init() {}
    public var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                
                switch viewModel.viewState {
                case .enterPhoneNumber:
                    PhoneNumberTextField(phoneNumber: $viewModel.phoneNumber)
                        .frame(height: 60)
                        .font(.title2)
                        .padding(.horizontal)
                        .focused($focused, equals: .enterPhoneNumber)
                        .onAppear {
                            if viewModel.phoneNumber.rawString.isWhitespace {
                                focused = .enterPhoneNumber
                            }
                        }
                    Divider()
                case .verifyOTP:
                    OTPView(otpCode: $viewModel.otp, otpCodeLength: 6)
                        .padding()
                case .error(let error):
                    OTPView(otpCode: $viewModel.otp, otpCodeLength: 6)
                        .padding()
                    Text(error)
                        .foregroundStyle(.secondary)
                    AsyncButton {
                        focused = .enterPhoneNumber
                        viewModel.reset()
                    } label: {
                        Text("Reset")
                            ._borderedProminentLightButtonStyle()
                    }
                    
                case .loggedIn(let user, isNewUser: let isNewUser):
                    Text(user.phoneNumber ?? "Phone")
                        ._badged(isNewUser ? "New" : "Existing")
                }
                Spacer()
            }
            .padding()
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    if viewModel.isLoading {
                        ProgressView()
                            .padding()
                            ._onAppear(after: 0.5) {
                                focused = nil
                            }
                    }
                }
            }
            .navigationTitle(viewModel.phoneNumber.countryCode.name)
        }
    }
}
