//
//  WelcomeView.swift
//  Informant
//
//  Created by Ty Irvine on 2021-07-16.
//

import LaunchAtLogin
import SwiftUI

// TODO: Finish this view
struct WelcomeView: View {
	
	private let confettiFrameSize: CGFloat = 140
	
	@ObservedObject public var interfaceState: InterfaceState
	
	var body: some View {

		// Main stack
		VStack(alignment: .center) {
			
			// App icon
			ZStack {
				Image("confetti")
					.scaleEffect(0.5)
					.offset(y: 25)
					.rotationEffect(Angle(degrees: -8))
					.mask(
						LinearGradient(gradient: Gradient(colors: [.black, .black.opacity(0)]), startPoint: UnitPoint(x: 0.5, y: 0.53), endPoint: UnitPoint(x: 0.5, y: 0.58))
					)
					.frame(width: confettiFrameSize, height: confettiFrameSize, alignment: .center)
					
				ComponentsWindowAppIcon()
			}
	
			// Welcome message
			Text("You're ready to use Informant!")
				.WelcomeHeaderFont()
				.fixedSize(horizontal: false, vertical: true)
			
			Spacer().frame(height: 5)
			
			// How to use Informant
			Text("To use Informant, select a file, and its size will appear in the menu bar.")
				.Body()
			
			Spacer().frame(height: Style.Padding.welcomeWindow)
				
			// How-to-use image
				
			Divider().frame(height: Style.Padding.welcomeWindow + 10)
			
			// Options stack
			VStack(alignment: .center, spacing: Style.Padding.welcomeWindow) {
				
				// Ask if they want to be logged in automatically
				LaunchAtLogin.Toggle(ContentManager.SettingsLabels.launchOnStartup)
			
				// Ask for root url
				SettingsPickRootURL(interfaceState.settingsRootURL, AppDelegate.current().welcomeWindow, .center)
					.fixedSize(horizontal: false, vertical: true)
			}
			.padding([.horizontal], 15)
		}
		.padding([.horizontal, .bottom], Style.Padding.welcomeWindow)
		.frame(width: 350)
	}
}
