//
//  OnboardingView.swift
//
//
//  Created by Om Chachad on 16/05/24.
//

import SwiftUI

struct OnboardingView: View {
    @State private var pageIndex = 1
    let minimumIndex = 1
    var maximumIndex: Int { isPencilProSupported ? 3 : 2 }
    
    var isPencilProSupported: Bool {
        CompatibilityChecker().isPencilProSupported
    }
    
    var body: some View {
        TabView(selection: $pageIndex) {
            DoubleTap()
                .clipped()
                .tag(1)
            
            if isPencilProSupported {
                Squeeze()
                    .clipped()
                    .tag(2)
            }
            
            StartUsingView()
                .tag(isPencilProSupported ? 3 : 2)
        }
        .tabViewStyle(.page(indexDisplayMode: .always))
        .ignoresSafeArea(.all)
        .interactiveDismissDisabled()
        .overlay(alignment: .bottom) { 
            HStack {
                
                if pageIndex < maximumIndex {
                    if pageIndex != minimumIndex {
                        Button("Previous") {
                            if pageIndex != minimumIndex {
                                pageIndex -= 1
                            }
                        }
                    }
                    
                    Spacer()
                    
                    Button("Next") {
                        if pageIndex < maximumIndex {
                            pageIndex += 1
                        }
                    }
                }
            }
            .buttonStyle(CapsuleButtonStyle())
            .shadow(radius: 10)
            .font(.title3)
            .padding(10)
            .ignoresSafeArea(.all)
        }
        .animation(.bouncy, value: pageIndex)
        
    }
}
