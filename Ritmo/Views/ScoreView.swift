//
//  ScoreView.swift
//  Ritmo
//
//  Created by Max Pelot on 3/12/24.
//

import SwiftUI

struct ScoreView: View {
    @Environment(GameModel.self) var gameModel
    @Environment(\.openWindow) private var openWindow
    @Environment(\.dismissImmersiveSpace) var dismissImmersiveSpace
    @Environment(\.dismiss) private var dismiss
    @State private var progressValue: Double = 0
    var body: some View {
        ZStack() {
            HStack(alignment: .top) {
                VStack(spacing: 0) {
                    HStack(alignment: .top) {
                        Button {
                            Task {
                                openWindow(id: "windowGroup")
                                await dismissImmersiveSpace()
                                dismiss()
                            }
                            gameModel.reset()
                        } label: {
                            Label("Exit", systemImage: "x.circle")
                                .labelStyle(.iconOnly)
                        }
                        HStack {
                            let songName = gameModel.musicView.selectedSong!.name
                            Text(songName)
                                .font(.system(size: 30))
                                .bold()
                                .accessibilityHidden(true)
                                .offset(y: -5)
                                .padding(50)
                            Text(String(gameModel.score))
                                .font(.system(size: 60))
                                .bold()
                                .accessibilityLabel(Text("Score"))
                                .accessibilityValue(String(gameModel.score))
                                .offset(x: 5)
                        }
                        .padding(.leading, 0)
                        .padding(.trailing, 60)
                    }
                    HStack {
                        HStack {
                            ProgressView(value: progressValue, total: gameModel.musicView.selectedSong!.duration)
                                .contentShape(.accessibility, Capsule().offset(y: -3))
                                .tint(Color(uiColor: UIColor(red: 212 / 255, green: 244 / 255, blue: 4 / 255, alpha: 1.0)))
                                .padding(.vertical, 30)
                                .frame(width: 300)
                        }
                        .frame(width: 460)
                        Button {
                            Task {
                                // Maybe we can repurpose this to be a mute button?
                                // await gameModel.togglePlayPause()
                            }
                        } label: {
                            Label("Pause", systemImage: "pause.fill")
                                .labelStyle(.iconOnly)
                            
                        }
                        .padding(.trailing, 12)
                        .padding(.leading, -55)
                    }
                    .background(
                        .regularMaterial,
                        in: .rect(
                            topLeadingRadius: 0,
                            bottomLeadingRadius: 12,
                            bottomTrailingRadius: 12,
                            topTrailingRadius: 0,
                            style: .continuous
                        )
                    )
                    .frame(width: 460, height: 70)
                    .offset(y: 15)
                }
                .padding(.vertical, 12)
                .onAppear { // Step 2: Start timer on appear
                    Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
                        if progressValue < gameModel.musicView.selectedSong!.duration {
                            progressValue += 1
                        } else {
                            timer.invalidate() // Stop the timer if the duration is reached
                        }
                    }
                }
            }
        }
    }
}
