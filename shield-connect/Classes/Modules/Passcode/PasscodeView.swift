//
//  PasscodeView.swift
//  shield-connect
//
//  Created by Александр on 11.04.2025.
//

import SwiftUI

struct PasscodeView: View {
    
    var viewModel: PasscodeViewModel
    
    init(viewModel: PasscodeViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ZStack {
            Image(asset: Asset.backgroundEffects)
                .resizable()
                .edgesIgnoringSafeArea(.all)  
            VStack {
                Text("Welcome")
                    .font(.title)
                HStack {
                    Button(action: {}, label: {
                        Image(systemName: "arrow.right.square")
                            .font(.title)
                    })
                }
                .padding()
            }
        }
        .background(.white)
        .ignoresSafeArea(.all)
    }
}

//#Preview {
//    PasscodeView(viewModel: PasscodeViewModel())
//}
