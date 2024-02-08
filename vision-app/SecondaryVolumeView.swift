//
//  SecondaryVolumeView.swift
//  vision-app
//
//  Created by Aidan York on 2/8/24.
//

import Foundation
import SwiftUI

struct SecondaryVolumeView: View {
    
    @Environment(ViewModel.self) private var model
    
    var body: some View {
    
        ZStack(alignment: .bottom) {
            CubeView()
            
            Text("This is a volume")
                .padding()
                .glassBackgroundEffect(in: .capsule)
        }
        .onDisappear {
            model.secondaryVolumeIsShowing.toggle()
        }
        
    }
}

#Preview {
    SecondaryVolumeView()
        .environment(ViewModel())
}
