//
//  ContentView.swift
//  Restart
//
//  Created by Niveytha Waran on 4/12/21.
//

import SwiftUI

struct ContentView: View {
    // AppStorage use user's defaults and stores some values on device permanently
    @AppStorage("onboarding") var isOnboardingViewActive: Bool = true   // initial value
    
    var body: some View {
        ZStack {    // Container used to display different views on top of each other
            if isOnboardingViewActive {
                OnboardingView()
            } else {
                HomeView()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
