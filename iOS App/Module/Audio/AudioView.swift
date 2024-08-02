import SwiftUI

struct AudioView: View {
    
    @EnvironmentObject private var audioSession: AudioRecorder
    private var storageService = SoundStorageService.shared
    
    @State private var value: Float = 0.0
    @State private var dbArray: [Int] = []
    @State private var notificationY: CGFloat = -500
    
    init() {
        setupNavigation()
    }
    
    var body: some View {
        NavigationView {
            GeometryReader { frame in
                VStack {
                    VStack(spacing: 20) {
                        
                        Text("Any value around -120 dB can be considered silence or very quiet.")
                        
                        Text("Values closer to 0 dB would mean louder sounds, with 0 dB being the loudest level the microphone can capture without distortion.")
                        
                    }
                    .padding(.top)
                    .padding(.horizontal, 30)
                    .multilineTextAlignment(.center)
                    .font(.custom(Constants.Fonts.REGULAR, size: 16))
                    .foregroundColor(.white)
                    
                    CircularProgressView(progress: .constant(CGFloat(value)))
                        .padding(80)
                        .overlay {
                            Text("\(Int(value))")
                                .font(.custom(Constants.Fonts.REGULAR, size: 52))
                                .foregroundStyle(.white)
                        }
                    
                    Button(action: {
                        Task {
                            audioSession.stopRecording()
                            HapticManager.shared.feedback(.light)
                            storageService.createNewData(
                                model: .init(
                                    id: UUID(),
                                    date: .now,
                                    dbArray: dbArray),
                                completion: { result in
                                    dbArray = []
                                    withAnimation(.linear(duration: 0.3)) {
                                        notificationY = 0
                                    }
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.3, execute: {
                                        withAnimation(.linear(duration: 0.3)) {
                                            notificationY = -250
                                        }
                                    })
                                    DispatchQueue.main.async {
                                        audioSession.startRecording()
                                    }
                                })
                        }
                    }, label: {
                        Text("Save")
                    })
                    .buttonStyle(AppButtonStyle())
                    .tint(Constants.Colors.FOREGROUND)
                    .padding(.horizontal, 80)
                }
            }
            .background(Constants.Colors.BACKGROUND)
            .navigationTitle(TabType.audio.title)
            .navigationBarTitleDisplayMode(.inline)
        }
        .overlay(content: {
            VStack {
                HStack(spacing: 20) {
                    Image(systemName: TabType.audio.systemImage)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 25)
                        .foregroundColor(.black)
                    Text("Saved to history, you can see details about this record on History tab.")
                        .font(.custom(Constants.Fonts.REGULAR, size: 16))
                        .foregroundColor(.black)
                        .multilineTextAlignment(.leading)
                }
                .padding(.horizontal, 40)
                .padding(.vertical)
                .background {
                    RoundedRectangle(cornerRadius: 25.0, style: .continuous)
                        .foregroundColor(Constants.Colors.SECOND_ACCENT)
                        .padding(.horizontal)
                }
                .offset(y: notificationY)
                Spacer()
            }
                
        })
        .onChange(of: audioSession.averagePower, perform: { value in
            dbArray.append(Int(value))
            self.value = value
        })
        .onAppear(perform: {
            DispatchQueue.main.async {
                audioSession.startRecording()
            }
        })
        .onDisappear(perform: {
            DispatchQueue.main.async {
                dbArray = []
                audioSession.stopRecording()
            }
        })
    }
}

#Preview {
    AudioView()
        .environmentObject(AudioRecorder())
}

