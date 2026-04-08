//
//  AnimatedBack.swift
//  Weather+
//
//  Created by Александр Малахов on 08.04.2026.
//

import Foundation
import SwiftUI

struct AnimatedBack : View {
    @State private var animate = false
    var body: some View {        
        ZStack{
        
                Circle()
                    .fill(Color.blue.opacity(0.9))
                    .frame(width: 500)
                    .blur(radius: 75)
                    .offset(x:animate ? 150 : -150, y:animate ? 0 : 100)
                
                Circle()
                    .fill(Color.red.opacity(0.9))
                    .frame(width: 500)
                    .blur(radius: 75)
                    .offset(x:animate ? -100 : 0, y:animate ? -350 : -250)
                
                Circle()
                    .fill(Color.green.opacity(0.9))
                    .frame(width: 500)
                    .blur(radius: 75)
                    .offset(x:animate ? -50 : 200, y:animate ? -100 : -450)
                
        }
        .ignoresSafeArea()
        .animation(.easeInOut(duration: 20).repeatForever(autoreverses: true), value: animate )
        .onAppear { animate = true }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        
    }
}


#Preview {
    AnimatedBack()
}
