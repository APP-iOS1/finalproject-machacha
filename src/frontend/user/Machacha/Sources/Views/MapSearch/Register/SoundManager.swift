import SwiftUI
import AVKit

class SoundManager {
    static let instance = SoundManager()
    var player: AVAudioPlayer?
    
    enum SoundOption: String {
        case rainfall = "rainfall"
        case medieval = "medieval"
        case register = "register_success_bgm"
    }
    
    func playSound(sound: SoundOption) {
        guard let url = Bundle.main.url(forResource: sound.rawValue, withExtension: ".wav") else { return }
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    
}

struct SoundEffectsBootCamp: View {
    private let soundManager = SoundManager.instance
    var body: some View {
        VStack(spacing: 40) {
            Button("Play Sound 1") {
                soundManager.playSound(sound: .rainfall)
            }
            Button("Play Sound 2") {
                soundManager.playSound(sound: .medieval)
            }
        }
    }
}
