//
//  GameOverView.swift
//  PinchGame
//
//  Created by Jay on 2023/04/17.
//

import SwiftUI

struct GameOverView: View {
    let score: Int
    var body: some View {
        ZStack{
            Image("mainBackground")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
            VStack{
                Text("Score: \(score)")
                    .font(.custom("Copperplate", size: 50))
                    .foregroundColor(.white)
                    .padding(20)
                
                Button{
                    // 앱 전체를 재실행 하는 느낌의 코드 (재시작 버튼에 넣을 코드)
                    if let window = UIApplication.shared.windows.first {
                        window.rootViewController = UIHostingController(rootView: ContentView())
                    }
                } label: {
                    Image("restart")
                }
            }
        }
    }
}

struct GameOverView_Previews: PreviewProvider {
    static var previews: some View {
        GameOverView(score: 10)
            .previewInterfaceOrientation(.landscapeRight)
    }
}
