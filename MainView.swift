//
//  MainView.swift
//  PinchGame
//
//  Created by Jay on 2023/04/16.
//

import SwiftUI

struct MainView: View {
    @Binding var isPlaying: Bool
    
    var body: some View {
        ZStack{
            Image("mainBackground")
                .edgesIgnoringSafeArea(.all)
            VStack{
                Spacer()
                Text("Pinch Run")
                    .font(.system(size: 70, design: .rounded))
                    .foregroundColor(.red)
                Spacer()
                
                VStack(spacing: 20){
                    Button {
                        print("gameStart, ")
                        isPlaying = true
                    } label: {
                        Text("Game Start")
                            .font(.system(size: 35))
                            .foregroundColor(.green)
                    }
                    
                    Button {
                        print("Tutorial")
                    } label: {
                        Text("Tutorial")
                            .font(.system(size: 35))
                            .foregroundColor(.green)
                    }
                }
                Spacer()
            }
        }
    }
}

/*
 struct MainView_Previews: PreviewProvider {
 
 static var previews: some View {
 MainView()
 }
 }
 */
