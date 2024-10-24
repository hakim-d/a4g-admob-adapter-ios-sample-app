//
//  RewardedContentView.swift
//  A4G
//
//  Created by Hakim on 10/24/2024.
//

import Ad4AdmobMediation
import GoogleMobileAds
import SwiftUI

struct NativeContentView: View {
  @StateObject private var nativeViewModel = NativeAdViewModel()
  let navigationTitle: String

  var body: some View {
    ScrollView {
        
      VStack(spacing: 20) {
        NativeAdView(nativeViewModel: nativeViewModel)  // Updates when the native ad data changes.
          .frame(minHeight: 300)  // minHeight determined from xib.

        Text(
          nativeViewModel.nativeAd?.mediaContent.hasVideoContent == true
            ? "Ad contains a video asset." : "Ad does not contain a video."
        )
        .frame(maxWidth: .infinity)
        .foregroundColor(.gray)
        .opacity(nativeViewModel.nativeAd == nil ? 0 : 1)

        Button("Refresh Ad") {
          refreshAd()
        }
      }
      .padding()
    }
    .onAppear {
      refreshAd()
    }
    .navigationTitle(navigationTitle)
  }

  private func refreshAd() {
    nativeViewModel.refreshAd()
  }
}

struct NativeContentView_Previews: PreviewProvider {
  static var previews: some View {
    NativeContentView(navigationTitle: "Native")
  }
}

// [START create_native_ad_view]
private struct NativeAdView: UIViewRepresentable {
  typealias UIViewType = GADNativeAdView

  // Observer to update the UIView when the native ad value changes.
  @ObservedObject var nativeViewModel: NativeAdViewModel

  func makeUIView(context: Context) -> GADNativeAdView {
    return
      Bundle.main.loadNibNamed(
        "NativeAdView",
        owner: nil,
        options: nil)?.first as! GADNativeAdView
  }

  func updateUIView(_ nativeAdView: GADNativeAdView, context: Context) {
    guard let nativeAd = nativeViewModel.nativeAd else { return }

    // Each UI property is configurable using your native ad.
    (nativeAdView.headlineView as? UILabel)?.text = nativeAd.headline

    nativeAdView.mediaView?.mediaContent = nativeAd.mediaContent

    (nativeAdView.bodyView as? UILabel)?.text = nativeAd.body

    (nativeAdView.iconView as? UIImageView)?.image = nativeAd.icon?.image

    (nativeAdView.starRatingView as? UIImageView)?.image = imageOfStars(from: nativeAd.starRating)

    (nativeAdView.storeView as? UILabel)?.text = nativeAd.store

    (nativeAdView.priceView as? UILabel)?.text = nativeAd.price

    (nativeAdView.advertiserView as? UILabel)?.text = nativeAd.advertiser

    (nativeAdView.callToActionView as? UIButton)?.setTitle(nativeAd.callToAction, for: .normal)

    // For the SDK to process touch events properly, user interaction should be disabled.
    nativeAdView.callToActionView?.isUserInteractionEnabled = false

    // Associate the native ad view with the native ad object. This is required to make the ad
    // clickable.
    // Note: this should always be done after populating the ad views.
    nativeAdView.nativeAd = nativeAd
  }
  // [END create_native_ad_view]

  private func imageOfStars(from starRating: NSDecimalNumber?) -> UIImage? {
    guard let rating = starRating?.doubleValue else {
      return nil
    }
    if rating >= 5 {
      return UIImage(named: "stars_5")
    } else if rating >= 4.5 {
      return UIImage(named: "stars_4_5")
    } else if rating >= 4 {
      return UIImage(named: "stars_4")
    } else if rating >= 3.5 {
      return UIImage(named: "stars_3_5")
    } else {
      return nil
    }
  }
}
