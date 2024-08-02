import Foundation
import AVFoundation

class CleanerManager: ObservableObject {
    
    @Published var isPlaying = false

    private var audioPlayer: AVAudioPlayer?
    let audioSession = AVAudioSession.sharedInstance()
     
     init() {
         
     }
     
     func playSound() {
         guard let soundURL = Bundle.main.url(forResource: "high_frequency_sound", withExtension: "mp3") else {
             return
         }

         Task {
             try audioSession.setCategory(.playback, mode: .default)
             try audioSession.setActive(true)
             audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
             audioPlayer?.prepareToPlay()
             audioPlayer?.setVolume(1.0, fadeDuration: .infinity)
             DispatchQueue.main.async {
                 self.isPlaying = true
             }
             audioPlayer?.play()
         }
         
//         do {
//             DispatchQueue.main.async {
//                 audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
//                 audioPlayer?.prepareToPlay()
//                 audioPlayer?.setVolume(1.0, fadeDuration: .infinity)
//                 self.isPlaying = true
//                 audioPlayer?.play()
//             }
//         } catch {
//             DispatchQueue.main.async {
//                 self.isPlaying = false
//             }
//             print(error.localizedDescription)
//         }
     }
     
     func stopSound() {
         DispatchQueue.main.async {
             self.isPlaying = false
         }
         audioPlayer?.stop()
         do {
             try audioSession.setActive(false)
         } catch {
             print(error.localizedDescription)
         }
     }
}
