//
//  HomeView.swift
//  Restart
//
//  Created by Niveytha Waran on 4/12/21.
//

import SwiftUI

struct HomeView: View {
    // MARK: - PROPERTY
    @AppStorage("onboarding") var isOnboardingViewActive: Bool = true // gives access to onboarding value stored on device
    @State private var isAnimating: Bool = false    // will not interfere with other isAnimating variables
    
    // MARK: - BODY
    var body: some View {
        VStack(spacing: 20) {    // Vertical Stack
            // MARK: - HEADER
            Spacer()
            
            ZStack {
                CircleGroupView(ShapeColor: .gray, ShapeOpacity: 0.1)
                
                Image("character-2")
                    .resizable()
                    .scaledToFit()
                    .padding()
                    .offset(y: isAnimating ? 33 : -33)
                    .animation(
                        .easeOut(duration: 3)
                            .repeatForever()    // will not stop
                        , value: isAnimating)
            }
            
            // MARK: - CENTER
            Text("""
            The time that leads to mastery is
            dependent on the intensity of our focus.
            """)
                .font(.title3)
                .fontWeight(.light)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding()
            
            // MARK: - FOOTER
            Spacer()
            
            Button(action: {
                withAnimation { // default animation
                    playSound(sound: "success", type: "m4a")
                    isOnboardingViewActive = true
                }
            }) {
                Image(systemName: "arrow.triangle.2.circlepath.circle.fill")
                    .imageScale(.large) // no need to wrap in HStack (auto)
                
                Text("Restart")
                    .font(.system(.title3, design: .rounded))
                    .fontWeight(.bold)
            }  //: BUTTON
            .buttonStyle(.borderedProminent)
            .buttonBorderShape(.capsule)
            .controlSize(.large)    // size of button
        }   //: VSTACK
        .onAppear(perform: {    // starting point of time
            // DispatchQueue manages the execution of tasks serially or concurrently on app's main thread or on a background thread
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {  // asyncAfter runs the code 3 seconds after appearing
                isAnimating = true
            })
        })
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
