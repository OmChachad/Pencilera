//
//  OnboardingView.swift
//
//
//  Created by Om Chachad on 16/05/24.
//

import SwiftUI

struct OnboardingView: View {
    @AppStorage("Modeldentifier") var modelIdentifier = ""
    
    var isPencilProSupported: Bool {
        let applePencilProiPadIdentifiers = ["iPad14,8",
                                             "iPad14,9",
                                             "iPad14,10",
                                             "iPad14,11",
                                             "iPad16,3",
                                             "iPad16,4",
                                             "iPad16,5",
                                             "iPad16,6",
                                             "iPad16,3-A",
                                             "iPad16,3-B",
                                             "iPad16,4-A",
                                             "iPad16,4-B",
                                             "iPad16,5-A",
                                             "iPad16,5-B",
                                             "iPad16,6-A",
                                             "iPad16,6-B"]
        return applePencilProiPadIdentifiers.contains(modelIdentifier)
    }
    
    @State private var pageIndex = 1
    let minimumIndex = 1
    var maximumIndex: Int { isPencilProSupported ? 3 : 2 }
    
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
        .onAppear(perform: storeModelIdentifier)
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
    
    func storeModelIdentifier() {
        var systemInfo = utsname()
        uname(&systemInfo)
        let modelIdentifier = withUnsafePointer(to: &systemInfo.machine) {
            $0.withMemoryRebound(to: CChar.self, capacity: 1) {
                String(cString: $0)
            }
        }
        self.modelIdentifier = modelIdentifier
    }
}
