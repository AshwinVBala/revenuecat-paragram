//
//  Paywall.swift
//  cwcmeditate
//
//  Created by Chris Ching on 2022-06-29.
//

import SwiftUI
import RevenueCat

struct Paywall: View {
    
    @Binding var isPaywallPresented: Bool
    
    @State var currentOffering: Offering?
    
    @EnvironmentObject var userViewModel: UserViewModel
    
    var body: some View {
        
        VStack (alignment: .leading, spacing: 20) {
            Text("Paragram Pro")
                .bold()
                .font(Font.largeTitle)
            Text("Unlock Premium Features")
            
            Spacer()
            
            VStack(spacing: 40) {
                HStack {
                    Image(systemName: "checkmark")
                    Text("Early access to new AI models")
                }
                
                HStack {
                    Image(systemName: "crown")
                    Text("Crown badge on your profile")
                }
                
                HStack {
                    Image(systemName: "person.3")
                    Text("Collaborate with other users")
                }
                
                HStack {
                    Image(systemName: "message")
                    Text("Custom LLMs for coding, creative writing, and research.")
                }
            }
            
            Spacer()
            
            if currentOffering != nil {
                
                ForEach(currentOffering!.availablePackages) { pkg in
                    
                    Button {
                        // BUY
                        Purchases.shared.purchase(package: pkg) { (transaction, customerInfo, error, userCancelled) in
                            
                            if customerInfo?.entitlements.all["pro"]?.isActive == true {
                                // Unlock that great "pro" content
                                
                                userViewModel.isSubscriptionActive = true
                                isPaywallPresented = false
                            }
                        }
                        
                    } label: {
                        
                        ZStack {
                            Rectangle()
                                .frame(height: 55)
                                .foregroundColor(.blue)
                                .cornerRadius(10)
                            
                            
                            Text("\(pkg.storeProduct.subscriptionPeriod!.periodTitle) \(pkg.storeProduct.localizedPriceString)")
                                .foregroundColor(.white)
                        }
                    }
                }
                
                
            }
            
            
            Spacer()
            
            Text("Auto-renews for $14.99/month")
            
        }
        .padding(50)
        .onAppear {
            
            Purchases.shared.getOfferings { offerings, error in
                
                if let offer = offerings?.current, error == nil {
                    
                    currentOffering = offer
                }
            }
        }
    }
}

struct Paywall_Previews: PreviewProvider {
    static var previews: some View {
        Paywall(isPaywallPresented: .constant(false))
    }
}
