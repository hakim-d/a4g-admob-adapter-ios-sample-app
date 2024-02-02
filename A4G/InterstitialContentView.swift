//
//  InterstitialContentView.swift
//  A4G
//
//  Created by Hakim on 1/2/2024.
//

import Ad4AdmobMediation
import GoogleMobileAds
import SwiftUI

struct InterstitialContentView: View {
  @StateObject private var countdownTimer = CountdownTimer()
  @State private var showGameOverAlert = false
  private let coordinator = InterstitialAdCoordinator()
  private let adViewControllerRepresentable = AdViewControllerRepresentable()
  let navigationTitle: String

  var adViewControllerRepresentableView: some View {
    adViewControllerRepresentable
      .frame(width: .zero, height: .zero)
  }

  var body: some View {
    VStack(spacing: 20) {

      Spacer()

      Text("\(countdownTimer.timeLeft) seconds left")
        .font(.title2)

      Button("Show Again") {
        startNewGame()
      }
      .font(.title2)
      .opacity(countdownTimer.isComplete ? 1 : 0)

      Spacer()
    }
    .onAppear {
      if !countdownTimer.isComplete {
        startNewGame()
      }
    }
    .onDisappear {
      countdownTimer.pause()
    }
    .onChange(of: countdownTimer.isComplete) { newValue in
      showGameOverAlert = newValue
    }
    .alert(isPresented: $showGameOverAlert) {
      Alert(
        title: Text("Show Ad"),
        message: Text("Click OK to show the Ad"),
        dismissButton: .cancel(
          Text("OK"),
          action: {
            coordinator.showAd(from: adViewControllerRepresentable.viewController)
          }))
    }
    .navigationTitle(navigationTitle)
  }

  private func startNewGame() {
    coordinator.loadAd()

    countdownTimer.start()
  }
}

struct InterstitialContentView_Previews: PreviewProvider {
  static var previews: some View {
    InterstitialContentView(navigationTitle: "Interstitial")
  }
}

// MARK: - Helper to present Interstitial Ad
private struct AdViewControllerRepresentable: UIViewControllerRepresentable {
  let viewController = UIViewController()

  func makeUIViewController(context: Context) -> some UIViewController {
    return viewController
  }

  func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
}

private class InterstitialAdCoordinator: NSObject, GADFullScreenContentDelegate {
  private var interstitial: GADInterstitialAd?

  func loadAd() {
      GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = [ GADSimulatorID ]
    GADInterstitialAd.load(
      withAdUnitID: "ca-app-pub-3940256099942544/4411468910", request: GADRequest()
    ) { ad, error in
      self.interstitial = ad
      self.interstitial?.fullScreenContentDelegate = self
    }
  }

  func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
    interstitial = nil
  }

  func showAd(from viewController: UIViewController) {
    guard let interstitial = interstitial else {
      return print("Ad wasn't ready")
    }

    interstitial.present(fromRootViewController: viewController)
  }
}

class CountdownTimer: ObservableObject {
    @Published var timeLeft: Int = 0
    @Published var isComplete: Bool = false
    var countdownTime: Int
    var timer: Timer?

    init(countdownTime: Int = 3) {
        self.countdownTime = countdownTime
        self.timeLeft = countdownTime
    }

    func start() {
        self.timeLeft = self.countdownTime
        self.isComplete = false
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self = self else { return }

            self.timeLeft -= 1

            if self.timeLeft <= 0 {
                self.stop()
                self.isComplete = true
            }
        }
    }

    func pause() {
        timer?.invalidate()
        timer = nil
    }

    func stop() {
        timer?.invalidate()
        timer = nil
        timeLeft = 0
    }

    func reset() {
        stop()
        timeLeft = countdownTime
        isComplete = false
    }
}
