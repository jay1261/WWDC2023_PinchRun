import SwiftUI
import SpriteKit

struct ContentView: View {
    @State var isPlaying: Bool = false
    
    var body: some View {
        if !isPlaying{
            MainView(isPlaying: $isPlaying)
        }
        else {
            ZStack{
                MyGameView()
                VStack{
                    HStack{
                        Spacer()
                        HandCameraView()
                            .frame(width: 400, height: 300)
                            .cornerRadius(20)
                            .padding(.trailing, 30)
                    }
                    Spacer()
                }
            }
        }
    }
}


struct HandCameraView: UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) -> CameraViewController {
        
        // Load Main.storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        // Instantiate ViewController
        guard let CameraViewController = storyboard.instantiateInitialViewController() as? CameraViewController else {
            fatalError("Couldn't instanciate a ViewController class.")
        }
        
        return CameraViewController
    }
    
    func updateUIViewController(_ uiViewController: CameraViewController, context: Context) {
        
    }
    
    typealias UIViewControllerType = CameraViewController
}


struct MyGameView: View {
    func sizedScene(size: CGSize) -> SKScene {
        let scene = GameScene(size: size)
        scene.scaleMode = .fill
        return scene
    }
    
    var body: some View {
        GeometryReader { geometry in
            SpriteView(scene: sizedScene(size: CGSize(width: geometry.size.width, height: geometry.size.height)))
                .frame(width: geometry.size.width, height: geometry.size.height)
        }.edgesIgnoringSafeArea(.all)
    }
    
}

