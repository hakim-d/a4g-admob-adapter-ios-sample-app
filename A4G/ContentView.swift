//
//  ContentView.swift
//  A4G
//
//  Created by Hakim on 31/1/2024.
//

import Ad4AdmobMediation
import GoogleMobileAds
import SwiftUI

struct ContentView: View {
    
    
    var body: some View {
        NavigationView {
            VStack {
                VStack {
                    Image("a4g-logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100)
                    
                    Text("Sample app to demo A4G mediation adapter")
                        .multilineTextAlignment(.center)
                        .lineLimit(/*@START_MENU_TOKEN@*/2/*@END_MENU_TOKEN@*/)
                        .padding()
                }
                    .padding()
              
                Spacer()
              
                VStack {
                    Text("Banner Ad")
                        .font(.title2)
                    
                    BannerView()
                }
                .frame(height: 250)
              
                Spacer()
                
                NavigationLink(destination:  InterstitialContentView(navigationTitle: "Interstitial Ad")) {
                    Text("Interstitial Ad")
                        .font(.title2)
                        .padding()
                        .foregroundColor (.white)
                        .background (RoundedRectangle (cornerRadius: 10).fill (Color.blue))
                }
                
                NavigationLink(destination:  RewardedContentView(navigationTitle: "Rewarded Ad")) {
                    Text("Rewarded Ad")
                        .font(.title2)
                        .padding()
                        .foregroundColor (.white)
                        .background (RoundedRectangle (cornerRadius: 10).fill (Color.blue))
                }
          }
      }
  }
}

#Preview {
    ContentView()
}




// MARK: Banner Ad

private struct BannerView: UIViewControllerRepresentable {
  @State private var viewWidth: CGFloat = .zero
  private let bannerView = GADBannerView()
  private let adUnitID = "ca-app-pub-2451195056696095/6358050824"

  func makeUIViewController(context: Context) -> some UIViewController {
    let bannerViewController = BannerViewController()
    bannerView.adUnitID = adUnitID
    bannerView.rootViewController = bannerViewController
    bannerView.delegate = context.coordinator
    bannerView.translatesAutoresizingMaskIntoConstraints = false
    bannerViewController.view.addSubview(bannerView)
    // Constrain GADBannerView to the bottom of the view.
    NSLayoutConstraint.activate([
//      bannerView.bottomAnchor.constraint(
//        equalTo: bannerViewController.view.safeAreaLayoutGuide.bottomAnchor),
      bannerView.centerXAnchor.constraint(equalTo: bannerViewController.view.centerXAnchor),
    ])
    bannerViewController.delegate = context.coordinator

    return bannerViewController
  }

  func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    guard viewWidth != .zero else { return }

    bannerView.adSize = GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(viewWidth)
    bannerView.load(GADRequest())
  }

  func makeCoordinator() -> Coordinator {
    Coordinator(self)
  }

  fileprivate class Coordinator: NSObject, BannerViewControllerWidthDelegate, GADBannerViewDelegate
  {
    let parent: BannerView

    init(_ parent: BannerView) {
      self.parent = parent
    }

    // MARK: - BannerViewControllerWidthDelegate methods

    func bannerViewController(
      _ bannerViewController: BannerViewController, didUpdate width: CGFloat
    ) {
      parent.viewWidth = width
    }

    // MARK: - GADBannerViewDelegate methods

    func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
      print("DID RECEIVE AD")
    }

    func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
      print("DID NOT RECEIVE AD: \(error.localizedDescription)")
    }
  }
}

protocol BannerViewControllerWidthDelegate: AnyObject {
  func bannerViewController(_ bannerViewController: BannerViewController, didUpdate width: CGFloat)
}

class BannerViewController: UIViewController {

  weak var delegate: BannerViewControllerWidthDelegate?

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    delegate?.bannerViewController(
      self, didUpdate: view.frame.inset(by: view.safeAreaInsets).size.width)
  }

  override func viewWillTransition(
    to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator
  ) {
    coordinator.animate { _ in
      // do nothing
    } completion: { _ in
      self.delegate?.bannerViewController(
        self, didUpdate: self.view.frame.inset(by: self.view.safeAreaInsets).size.width)
    }
  }
}

// MARK: Interstitial Ad
