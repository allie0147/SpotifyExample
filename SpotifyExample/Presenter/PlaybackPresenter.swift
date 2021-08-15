//
//  PlaybackPresenter.swift
//  SpotifyExample
//
//  Created by Allie Kim on 2021/06/29.
//

import UIKit
import Foundation
import AVFoundation

protocol PlayerDataSource: AnyObject {
    var songName: String? { get }
    var subTitle: String? { get }
    var imageURL: URL? { get }
}

final class PlaybackPresenter {

    static let shared = PlaybackPresenter()

    private var track: AudioTrack?
    private var tracks = [AudioTrack]()

    var index = 0

    var currentTrack: AudioTrack? {
        if let track = track, tracks.isEmpty { // 한 곡 재생용
            return track
        } else if let player = self.playerQueue, !tracks.isEmpty { // 앨범 재생용
//            let item = player.currentItem
//            let items = player.items()
//            guard let index = items.firstIndex(where: { $0 == item }) else {
//                return nil
//            }
            return tracks[index]
        }
        return nil
    }

    var player: AVPlayer? // single play
    var playerQueue: AVQueuePlayer? // playlist
    var playerVC: PlayerViewController?

    let session = AVAudioSession.sharedInstance()

    init() {
        do {
            try session.setCategory(.playback, mode: .default)
            try session.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            fatalError()
        }
    }

    /// play music from audio track
    func startPlayback(
        from viewController: UIViewController,
        track: AudioTrack
    ) {
        guard let url = URL(string: track.preview_url ?? "")else {
            return
        }
        // make audio player
        player = AVPlayer(url: url)
        player?.volume = 0.5

        self.track = track
        self.tracks = []

        let vc = PlayerViewController()
        vc.title = track.name
        vc.dataSource = self
        vc.delegate = self
        viewController.present(
            UINavigationController(rootViewController: vc),
            animated: true
        ) { [weak self] in
            self?.player?.play()
        }
        self.playerVC = vc
    }

    /// play music from album
    func startPlayback(
        from viewController: UIViewController,
        tracks: [AudioTrack]
    ) {
        // make audio tracks
        self.playerQueue = AVQueuePlayer(
            items: tracks.compactMap {
                guard let url = URL(string: $0.preview_url ?? "") else {
                    return nil
                }
                return AVPlayerItem(url: url)
            }
        )
//        print(playerQueue)
        self.playerQueue?.volume = 0.5

        self.tracks = tracks
        self.track = nil


        let vc = PlayerViewController()
        vc.dataSource = self
        vc.delegate = self
        viewController.present(
            UINavigationController(rootViewController: vc),
            animated: true
        ) { [weak self] in
            self?.playerQueue?.play()
        }
        self.playerVC = vc
    }

/// play music from playlist
//    func startPlayback(
//        from viewController: UIViewController,
//        playlist: Playlist
//    ) {
//
//    }
}

extension PlaybackPresenter: PlayerDataSource {
    var songName: String? {
        return currentTrack?.name
    }

    var subTitle: String? {
        return currentTrack?.artists.first?.name
    }

    var imageURL: URL? {
        return URL(string: currentTrack?.album?.images.first?.url ?? "")
    }
}
extension PlaybackPresenter: PlayerViewControllerDelegate {
    func didTapPlayPause() {
        if let player = player {
            if player.timeControlStatus == .playing {
                player.pause()
            } else if player.timeControlStatus == .paused {
                player.play()
            }
        } else if let player = playerQueue {
            if player.timeControlStatus == .playing {
                player.pause()
            } else if player.timeControlStatus == .paused {
                player.play()
            }
        }
    }

    func didTapNext() {
        if tracks.isEmpty {
            // not playlist or album
            player?.pause()
        } else if let player = playerQueue {
            player.advanceToNextItem()
            index += 1
            playerVC?.refreshUI()
//            player.play()
        }
    }

    func didTapBack() {
        if tracks.isEmpty {
            player?.pause()
//            player?.seek(to: CMTime(seconds: 0.0, preferredTimescale: .zero))
            player?.play()
        } else if let firstItem = playerQueue?.items().first {
            playerQueue?.pause()
            playerQueue?.removeAllItems()
            playerQueue = AVQueuePlayer(items: [firstItem])
            playerQueue?.volume = 0.5
        }
    }

    func didSlideSlider(_ value: Float) {
        player?.volume = value


    }
}
