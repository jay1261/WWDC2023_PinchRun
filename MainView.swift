//
//  MainView.swift
//  PinchGame
//
//  Created by Jay on 2023/04/16.
//

import SwiftUI

struct MainView: View {
    @Binding var isPlaying: Bool
    @State var isLevelPressed: Bool = false
    
    var body: some View {
        ZStack{
            Image("mainBackground")
                .edgesIgnoringSafeArea(.all)
            VStack{
                HStack{
                    if K.gameLevel == 1{
                        Text("Easy Mode")
                            .font(.custom("Copperplate", size: 30))
                            .foregroundColor(.white)
                            .padding(20)
                    } else if K.gameLevel == 2{
                        Text("Normal Mode")
                            .font(.custom("Copperplate", size: 30))
                            .foregroundColor(.white)
                            .padding(20)
                    } else if K.gameLevel == 3 {
                        Text("Hard Mode")
                            .font(.custom("Copperplate", size: 30))
                            .foregroundColor(.white)
                            .padding(20)
                    }
                    Spacer()
                }
                Spacer()
            }
            VStack(spacing: 10){
                Image("title")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 689, height: 159)
//                    .padding(50)
                Spacer().frame(width:10, height: 30)
                //게임시작 버튼
                
                Button {
                    isPlaying = true
                } label: {
                    Image("gameStart")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 350, height: 80)
                }
                
                HStack(spacing: 10){
                    // 레벨
                    Button {
                        isLevelPressed = true
                    } label: {
                        Image("level")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 109, height: 44)
                    }
                    // 튜토리얼 버튼
                    Button {
                        
                    } label: {
                        Image("tutorial")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 150, height: 44)
                    }
                }
                
            }
            if (isLevelPressed){
                VStack(spacing: 7){
                    HStack(spacing: 10){
                        // 난이도 easy
                        Button {
                            K.gameLevel = 1
                            isLevelPressed = false
                        } label: {
                            Image("easy")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 112, height: 34)
                        }
                        Spacer()
                            .frame(width: 150, height: 34)
                    }
                    HStack(spacing: 10){
                        // 난이도 normal
                        Button {
                            K.gameLevel = 2
                            isLevelPressed = false
                        } label: {
                            Image("normal")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 112, height: 34)
                        }
                        Spacer()
                            .frame(width: 150, height: 34)
                    }
                    HStack(spacing: 10){
                        // 난이도 hard
                        Button {
                            K.gameLevel = 3
                            isLevelPressed = false
                        } label: {
                            Image("hard")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 112, height: 34)
                        }
                        Spacer()
                            .frame(width: 150, height: 34)
                    }
                }
                .offset(y: 240)
            }
        }
    }
}



