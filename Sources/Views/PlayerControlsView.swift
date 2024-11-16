import SwiftUI

struct PlayerControlsView: View {
    @ObservedObject var playerControlViewModel = PlayerControlsModel()
    @Binding var currentSong: DataStructs.resultTitleData
    var songsTracks: [DataStructs.resultTitleData]
    @StateObject var trackChanger = TrackChanger()
    
    var body: some View {
        
        HStack {
            Spacer()
            Button(action: { // Previous track
                trackChanger.previousTrack(currentSong: $currentSong, songsTracks: songsTracks)
                playerControlViewModel.stopOnlineMusic()
                Task{
                    try? await playerControlViewModel.playOnlineMusic(urlString: currentSong.audio, currentSong: currentSong)
                }
            }) {
                Image(systemName: "backward.end.fill")
                    .font(.title)
            }
            Spacer()
            Button(action: { // Play/stop
                Task {
                    try? await playerControlViewModel.playOnlineMusic(urlString: currentSong.audio, currentSong: currentSong)
                }
            }) {
                Image(systemName: playerControlViewModel.isPlaying ? "pause.fill" : "play.fill")
                    .font(.title)
            }
            Spacer()
            Button(action: { // Next track
                trackChanger.nextTrack(currentSong: $currentSong, songsTracks: songsTracks)
                playerControlViewModel.stopOnlineMusic()
                Task{
                    try? await playerControlViewModel.playOnlineMusic(urlString: currentSong.audio, currentSong: currentSong)
                }
            }) {
                Image(systemName: "forward.end.fill")
                    .font(.title)
            }
            Spacer()
        }

        .onDisappear {
            playerControlViewModel.stopOnlineMusic()
        }

        .frame(width: 320, height: 100)
        .background(Color.blue)
        .foregroundStyle(Color.white)
        .cornerRadius(15)
    }

}

