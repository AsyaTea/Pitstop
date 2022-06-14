//
//  ThemePickerView.swift
//  Hurricane
//
//  Created by Ivan Voloshchuk on 13/06/22.
//

import SwiftUI
import CoreHaptics

struct ThemePickerView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        VStack(spacing:170){
            Spacer()
            HStack(spacing:40){
                Spacer()
                ColorButton(color: Palette.colorBlue, title: "Pick one")
                Spacer()
                
                ColorButton(color: Palette.colorYellow, title: "Pick one")
                
                    .accentColor(.none)
                Spacer()
            }
            
            HStack(spacing:40){
                Spacer()
                
                ColorButton(color: Palette.colorGreen, title: "Pick one")
                
                Spacer()
                
                ColorButton(color: Palette.colorViolet, title: "Pick one")
                
                Spacer()
            }
            Spacer(minLength: 300)
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(
            leading:
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    Image("arrowLeft")
                })
                .accentColor(Palette.greyHard)
        )
        .toolbar{
            ToolbarItem(placement: .principal) {
                Text("Theme")
                    .font(Typography.headerM)
                    .foregroundColor(Palette.black)
            }
        }

    }
}

struct ThemePickerView_Previews: PreviewProvider {
    static var previews: some View {
        ThemePickerView()
    }
}

struct ColorButton: View {
    var color : Color
    var title : String
    @State private var engine: CHHapticEngine?
    @GestureState var tap = false
    @State private var press = false
    let impactHeavy = UIImpactFeedbackGenerator(style: .heavy)
    
    @ObservedObject var homeVM : HomeViewModel
    
    var body: some View {
        
        HStack{
            Text(press ? "Picked" : title)
                .font(Typography.headerM)
                .foregroundColor(press ? Palette.black : Palette.white)
            
            Image(systemName:press ? "checkmark": "")
                .foregroundColor(press ? Palette.black : Palette.white)
            
        }
        .background(
            RoundedRectangle(cornerRadius: 20)
                .frame(width: 150, height: 150)
                .foregroundColor(press ? color : Palette.blackHeader)
                .rotationEffect(Angle(degrees: tap ? 90 : 0))
                .animation(.easeInOut)
                .overlay(
                    Circle()
                        .trim(from: tap ? 0.001 : 1 , to: 1)
                        .stroke(color,style: StrokeStyle(lineWidth:4,lineCap: .round))
                        .rotationEffect(Angle(degrees: 90))
                        .rotation3DEffect(Angle(degrees: 180),axis: (x: 1, y: 0, z: 0))
                        .animation(.easeInOut(duration: 0.5))
                        .frame(width: 100, height: 100)
                )
        )
        .scaleEffect(tap ? 1.15 : 1)
        .gesture(
            LongPressGesture(minimumDuration:0.6).updating($tap){ currentState, gestureState, transaction in
                gestureState = currentState
                impactHeavy.impactOccurred()
            }
                .onEnded{ value in
                    self.press.toggle()
                }
        )
        .onAppear(perform: prepareHaptics)
    }
    
    func prepareHaptics() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        
        do {
            engine = try CHHapticEngine()
            try engine?.start()
        } catch {
            print("There was an error creating the engine: \(error.localizedDescription)")
        }
    }
    //
    //    func complexSuccess() {
    //         let initialIntensity: Float = 1.0
    //         let initialSharpness: Float = 0.5
    //        // make sure that the device supports haptics
    //        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
    //        var events = [CHHapticEvent]()
    //
    //        // create one intense, sharp tap
    //        let intensity = CHHapticEventParameter(parameterID: .hapticIntensity,value: initialIntensity)
    //
    //        // Create a sharpness parameter:
    //        let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness,value: initialSharpness)
    //
    //        // Create a continuous event with a long duration from the parameters.
    //        let continuousEvent = CHHapticEvent(eventType: tap ? .hapticContinuous,parameters: [intensity, sharpness],relativeTime: 0,duration: 10)
    //
    //        // convert those events into a pattern and play it immediately
    //        do {
    //            let pattern = try CHHapticPattern(events: [continuousEvent], parameters: [])
    //            let player = try engine?.makePlayer(with: pattern)
    //            try player?.start(atTime: 0)
    //        } catch {
    //            print("Failed to play pattern: \(error.localizedDescription).")
    //        }
    //    }
    
    
}

