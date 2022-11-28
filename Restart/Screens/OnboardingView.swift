//
//  OnboardingView.swift
//  Restart
//
//  Created by Niveytha Waran on 4/12/21.
//

import SwiftUI

// REUSABLE UI COMPONENT
struct OnboardingView: View {
    // MARK: - PROPERTY
    @AppStorage("onboarding") var isOnboardingViewActive: Bool = false
    // (true) value will only be added to property if program doesn't find the onboarding key previously set!
    
    @State private var buttonWidth: Double = UIScreen.main.bounds.width - 80    // horizontal constraints
    @State private var buttonOffset: CGFloat = 0    // offset value in the horizontal direction
    @State private var isAnimating: Bool = false    // switch for animation
    @State private var imageOffset: CGSize = .zero  // CGSize(width: 0, height: 0)
    @State private var indicatorOpacity: Double = 1.0
    @State private var textTitle: String = "Share."
    
    let hapticFeedback = UINotificationFeedbackGenerator()  // UINFG
    
    // MARK: - BODY
    var body: some View {
        ZStack {
            Color("ColorBlue")
                .ignoresSafeArea(.all, edges: .all)
            
            VStack(spacing: 20) {
                // MARK: - HEADER
                Spacer()
                VStack(spacing: 0) {
                    Text(textTitle)
                        .font(.system(size: 60))
                        .fontWeight(.heavy)
                        .foregroundColor(.white)
                        .transition(.opacity)   // opaque to transparent transition and vice versa
                        .id(textTitle)  // we use ID method to tell SwiftUI that a view is no longer the same view
                    
                    Text("""
                It's not how much we give but
                how much love we put into giving.
                """)    // Multi-line text
                        .font(.title3)
                        .fontWeight(.light)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 10)
                }  //: HEADER
                .opacity(isAnimating ? 1 : 0)    // appear
                .offset(y: isAnimating ? 0 : -40)   // slide down
                .animation(.easeOut(duration: 1), value: isAnimating)   // 1 second
                
                // MARK: - CENTER
                ZStack {
                    CircleGroupView(ShapeColor: .white, ShapeOpacity: 0.2)
                        .offset(x: imageOffset.width * -1)  // move in the opposite direction
                        .blur(radius: abs(imageOffset.width / 10))
                        .animation(.easeOut(duration: 1), value: imageOffset)
                    
                    Image("character-1")
                        .resizable()
                        .scaledToFit()
                        .opacity(isAnimating ? 1 : 0)   // appear
                        .animation(.easeOut(duration: 0.5), value: isAnimating)
                        .offset(x: imageOffset.width * 1.2, y: 0)   // accelerate the movement
                        .rotationEffect(.degrees(Double(imageOffset.width / 20)))
                        .gesture(
                            DragGesture()
                                .onChanged { gesture in
                                    if abs(imageOffset.width) <= 150 {
                                        imageOffset = gesture.translation
                                        withAnimation(.linear(duration: 0.25)) {
                                            indicatorOpacity = 0
                                            textTitle = "Give."
                                        }
                                    }
                                }
                                .onEnded { _ in
                                    imageOffset = .zero
                                    withAnimation(.linear(duration: 0.25)) {
                                        indicatorOpacity = 1
                                        textTitle = "Share."
                                    }
                                }
                        )   //: GESTURE
                        .animation(.easeOut(duration: 1), value: imageOffset)
                }  //: CENTER
                .overlay(
                    Image(systemName: "arrow.left.and.right.circle")
                        .font(.system(size: 44, weight: .ultraLight))
                        .foregroundColor(.white)
                        .offset(y: 20)
                        .opacity(isAnimating ? 1 : 0)
                        .animation(.easeOut(duration: 1).delay(1), value: isAnimating)
                        .opacity(indicatorOpacity)
                    , alignment: .bottom
                )
                
                Spacer()

                // MARK: - FOOTER
                ZStack {
                    // 1. BACKGROUND (STATIC)
                    Capsule()
                        .fill(Color.white.opacity(0.2))
                    
                    Capsule()
                        .fill(Color.white.opacity(0.2))
                        .padding(8)
                    
                    // 2. CALL-TO-ACTION (STATIC)
                    Text("Get Started")
                        .font(.system(.title3, design: .rounded))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .offset(x: 20)
                    
                    // 3. CAPSULE (DYNAMIC WIDTH)
                    HStack {
                        Capsule()
                            .fill(Color("ColorRed"))
                            .frame(width: buttonOffset + 80)
                        
                        Spacer()
                    }  //: HSTACK
                    
                    // 4. CIRCLE (DRAGGABLE)
                    HStack {
                        ZStack {
                            Circle()
                                .fill(Color("ColorRed"))
                            Circle()
                                .fill(.black.opacity(0.15))
                                .padding(8)
                            Image(systemName: "chevron.right.2")
                                .font(.system(size: 24, weight: .bold))
                        }  //: ZSTACK
                        .foregroundColor(.white)
                        .frame(width: 80, height: 80, alignment: .center)
                        .offset(x: buttonOffset)
                        .gesture(
                            DragGesture()
                                .onChanged { gesture in
                                    if gesture.translation.width > 0 && buttonOffset <= buttonWidth - 80 {  // initial left to right gesture
                                        buttonOffset = gesture.translation.width
                                    }
                                }
                                .onEnded{ _ in
                                    withAnimation(Animation.easeOut(duration: 0.4)) {   // smoothes animation from OnboardingView to HomeView
                                        if buttonOffset >=  buttonWidth - 80 { // snap to right edge if fully swipped
    //                                        buttonOffset = buttonWidth - 80
                                            hapticFeedback.notificationOccurred(.success)   // task has succeeded
                                            playSound(sound: "chimeup", type: "mp3")
                                            isOnboardingViewActive = false
                                        } else {   // snap to left edge
                                            hapticFeedback.notificationOccurred(.warning)   // task has failed
                                            buttonOffset = 0
                                        }
                                    }
                                }
                        )  //: GESTURE
                        
                        Spacer()
                    }  //: HSTACK
                }  //: FOOTER
                .frame(width: buttonWidth, height: 80, alignment: .center)
                .padding()
                .opacity(isAnimating ? 1 : 0)   // appear
                .offset(y: isAnimating ? 0 : 40)    // slide up
                .animation(.easeOut(duration: 1), value: isAnimating)
            }  //: VSTACK
        }  //: ZSTACK
        .onAppear(perform: {
            isAnimating = true  // trigger animation when components appear
        })
        .preferredColorScheme(.dark)    // status bar will be white
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
