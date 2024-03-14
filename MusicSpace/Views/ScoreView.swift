//
//  ScoreView.swift
//  MusicSpace
//
//  Created by Max Pelot on 3/12/24.
//

import SwiftUI

struct ScoreView: View {
    @Environment(GameModel.self) var gameModel
    @Environment(\.dismissImmersiveSpace) var dismissImmersiveSpace
    var body: some View {
        ZStack() {
            HStack(alignment: .top) {
                VStack(spacing: 0) {
                    HStack(alignment: .top) {
                        Button {
                            Task {
                                await dismissImmersiveSpace()
                            }
                        } label: {
                            Label("Back", systemImage: "chevron.backward")
                                .labelStyle(.iconOnly)
                        }
                        
                        HStack {
                            let songName = gameModel.songTitle
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
                            ProgressView(value: 5, total: 10)
                                .contentShape(.accessibility, Capsule().offset(y: -3))
                                .accessibilityLabel("")
                                .accessibilityValue(Text("10 seconds remaining"))
                                .tint(Color(uiColor: UIColor(red: 212 / 255, green: 244 / 255, blue: 4 / 255, alpha: 1.0)))
                                .padding(.vertical, 30)
                                .frame(width: 300)
                        }
                        .frame(width: 460)
                        Button {
                            Task {
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
            }
            .frame(width: 460)
            .glassBackgroundEffect(
             in: RoundedRectangle(
                 cornerRadius: 32,
                 style: .continuous
             )
            )
            .offset(x: 300, y: -1500)
        }
    }
}

#Preview {
    VStack {
        Spacer()
        ScoreView()
            .environment(GameModel())
            .glassBackgroundEffect(
                in: RoundedRectangle(
                    cornerRadius: 32,
                    style: .continuous
                )
            )
    }
}
