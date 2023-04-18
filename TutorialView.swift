//
//  TutorialView.swift
//  PinchRun
//
//  Created by Jay on 2023/04/18.
//

import SwiftUI
import AVKit

struct TutorialView: View {
    var body: some View {
        VideoPlayer(player: AVPlayer(url: Bundle.main.url(forResource: "tutorial", withExtension: "mp4")!))
    }
}

struct TutorialView_Previews: PreviewProvider {
    static var previews: some View {
        TutorialView()
    }
}
