//
//  WelcomeView.swift
//  Informant
//
//  Created by Ty Irvine on 2021-07-16.
//

import LaunchAtLogin
import SwiftUI

/// This is the welcome view that appears only once on first run after a fresh install. Fresh install determined by user defaults
struct WelcomeView: View {
	
	private let confettiFrameSize: CGFloat = 140
	
	/// This is the radius of the actual help image
	private let helpImageRadius: CGFloat = 10.0
	
	/// Pop a new image in, adjust this scale and you'll be ready to go.
	/// The image is anchored to the top so it'll relocate automatically sort to speak.
	private let helpImageScale: CGFloat = 1.6
	
	@ObservedObject public var interfaceState: InterfaceState
	
	var body: some View {

		// Main stack
		VStack(alignment: .center) {
			
			// App icon
			ZStack {
				Image("welcome-confetti")
					.scaleEffect(0.5)
					.offset(y: 25)
					.rotationEffect(Angle(degrees: -8))
					.mask(
						LinearGradient(gradient: Gradient(colors: [.black, .black.opacity(0)]), startPoint: UnitPoint(x: 0.5, y: 0.54), endPoint: UnitPoint(x: 0.5, y: 0.58))
					)
					.frame(width: confettiFrameSize, height: confettiFrameSize, alignment: .center)
					
				ComponentsWindowAppIcon()
			}
	
			// Welcome message
			Text(ContentManager.WelcomeLabels.welcomeReadyToUse)
				.WelcomeHeaderFont()
				.fixedSize(horizontal: false, vertical: true)
			
			Spacer().frame(height: 5)
			
			// How to use Informant
			Text(ContentManager.WelcomeLabels.welcomeHowToUse)
				.Body()
			
			Spacer().frame(height: Style.Padding.welcomeWindow)
				
			// How-to-use image
			Image("welcome-howto(BigSur)")
				.resizable()
				.aspectRatio(contentMode: .fill)
				.frame(width: 275, height: 145, alignment: .top)
				.scaleEffect(helpImageScale, anchor: .top)
				.cornerRadius(helpImageRadius)
				.padding(1)
				.background(Color.primary.opacity(0.25).cornerRadius(helpImageRadius + 1))
				.padding(.bottom, 5)

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
