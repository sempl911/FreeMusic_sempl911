//
//  TrackChanger.swift
//  FreeMusicApp
//
//  Created by Алексей Кустов on 27.10.2024.
//

import Foundation
import SwiftUI

class TrackChanger:ObservableObject{
    
    @Published var currentTrack: DataStructs.resultTitleData?
    @Published var tracks: [DataStructs.resultTitleData] = []
    
    func saveTracks(_ tracks: [DataStructs.resultTitleData]) {
        self.tracks = tracks
        print("Saved tracks count: \(tracks.count)")
    }
    
    func findCurrentSong(currentSong: DataStructs.resultTitleData, startTracks: [DataStructs.resultTitleData]) -> Int {
        
        guard !startTracks.isEmpty else {
            print("Массив треков пуст.")
            return 0
        }
        if let index = startTracks.firstIndex(where: { $0.id == currentSong.id }) {
            print("Index curent song: \(index)")
            return index
        }
        return 0
    }
    func nextTrack(currentSong: Binding<DataStructs.resultTitleData>, songsTracks: [DataStructs.resultTitleData]) {
        guard let currentIndex = songsTracks.firstIndex(where: { $0.id == currentSong.wrappedValue.id }) else { return }
        
        let nextIndex = (currentIndex + 1) % songsTracks.count
        currentSong.wrappedValue = songsTracks[nextIndex]
        print("Switched to next track: \(currentSong.wrappedValue.name)")
    }
    func previousTrack(currentSong: Binding<DataStructs.resultTitleData>, songsTracks: [DataStructs.resultTitleData]) {
        guard let currentIndex = songsTracks.firstIndex(where: { $0.id == currentSong.wrappedValue.id }) else { return }
        
        let previousIndex = (currentIndex - 1 + songsTracks.count) % songsTracks.count
        currentSong.wrappedValue = songsTracks[previousIndex]
        print("Switched to previous track: \(currentSong.wrappedValue.name)")
    }
}
