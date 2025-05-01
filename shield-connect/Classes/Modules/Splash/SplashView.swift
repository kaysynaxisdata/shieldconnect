//
//  SplashView.swift
//  shield-connect
//
//  Created by Александр on 29.03.2025.
//

import SwiftUI

//class ProgressViewModel: ObservableObject {
//    @Published var value: CGFloat = 0
//}
//
//struct ProgressView: View {
//    
//    @StateObject private var viewModel: ProgressViewModel
//    
//    var body: some View {
//        ZStack(content: {
//            Rectangle()
//            
//        })
//        Rectangle()
//            .fill(style: .init())
//    }
//    
//}

struct SplashView: View {
    
    @StateObject private var viewModel: SplashViewModel
    @State private var showingAlert = false
    
    var body: some View {
        ZStack {
            Image(asset: Asset.splashBackground)
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            VStack(content: {
                Spacer()
                VStack(alignment: .leading, spacing: 40, content: {
                    Image(asset: Asset.commonLogo)
                        .frame(width: 150, height: 160, alignment: .leading)
                    Text("Shield\nConnect")
                        .applyStyle(style: .init(
                            fontStyle: .titleLarge,
                            lineHeight: 64,
                            colorAsset: Asset.whiteColor)
                        )
                        .opacity(/*@START_MENU_TOKEN@*/0.8/*@END_MENU_TOKEN@*/)
                        .frame(alignment: .leading)
                    Text("Advanced Privacy.\nTotal Control")
                        .font(FontFamily.RedHatDisplay.regular.swiftUIFont(size: 28))
                        .foregroundStyle(.white)
                        .frame(alignment: .leading)
                })
            })
            .padding(.horizontal, 36)

        }
    }
}

//#Preview {
//    SplashView(viewModel: SplashViewModel(input: SplashModuleInput()))
//}
