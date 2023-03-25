//
//  Home.swift
//  GlassMorphism
//
//  Created by minii on 2023/03/25.
//

import SwiftUI

struct Home: View {
  @State var blurView: UIVisualEffectView = .init()
  @State var defaultBlurRadius: CGFloat = 0
  @State var defaultSaturationAmount: CGFloat = 0
  @State var activateGlassMorphism: Bool = false
  
  var body: some View {
    ZStack {
      Color(.black)
        .ignoresSafeArea()
      
      topCircle()
        .frame(width: 230, height: 230)
        .offset(x: 150, y: -90)
      
      bottomCircle()
        .frame(width: 130, height: 130)
        .offset(x: -150, y: 90)
      
      centerCircle()
        .frame(width: 80, height: 80)
        .offset(x: -40, y: -100)
      
      glassMorphicCard()
      
      Toggle("Activate Glass Morphism", isOn: $activateGlassMorphism)
        .font(.title3)
        .fontWeight(.semibold)
        .foregroundColor(.white)
        .onChange(of: activateGlassMorphism) { newValue in
          blurView.gaussianBlurRadius = (activateGlassMorphism ? 10 : defaultBlurRadius)
          blurView.saturationAmount = (activateGlassMorphism ? 1.8 : defaultSaturationAmount)
        }
        .frame(maxHeight: .infinity, alignment: .bottom)
        .padding(15)
    }
  }
}

extension Home {
  func topCircle() -> some View {
    Circle()
      .fill(
        LinearGradient(
          colors: [.purple, .pink],
          startPoint: .topTrailing,
          endPoint: .bottom
        )
      )
  }
  
  func bottomCircle() -> some View {
    Circle()
      .fill(
        LinearGradient(
          colors: [.pink.opacity(0.9), .red],
          startPoint: .top,
          endPoint: .bottom
        )
      )
  }
  
  func centerCircle() -> some View {
    Circle()
      .fill(
        LinearGradient(
          colors: [.pink, .red.opacity(0.9)],
          startPoint: .top,
          endPoint: .bottom
        )
      )
  }
}

extension Home {
  func glassMorphicCard() -> some View {
    ZStack {
      CustomBlurView(effect: .systemUltraThinMaterialDark) { view in
        blurView = view
        if defaultBlurRadius == 0 {
          defaultBlurRadius = view.gaussianBlurRadius
        }
        if defaultSaturationAmount == 0 {
          defaultSaturationAmount = view.saturationAmount
        }
      }
      .clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous))
      
      RoundedRectangle(cornerRadius: 25, style: .continuous)
        .fill(
          LinearGradient(
            colors: [.white.opacity(0.25), .white.opacity(0.5)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
          )
        )
      
      RoundedRectangle(cornerRadius: 25, style: .continuous)
        .stroke(
          LinearGradient(
            colors: [
              .white.opacity(0.6),
              .clear,
              .purple.opacity(0.2),
              .purple.opacity(0.5)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
          ),
          lineWidth: 2
        )
    }
    .shadow(color: .black.opacity(0.15), radius: 5, x: -10, y: 10)
    .shadow(color: .black.opacity(0.15), radius: 5, x: 10, y: -10)
    .overlay {
      cardContent()
        .opacity(activateGlassMorphism ? 1 : 0)
        .animation(.easeIn(duration: 0.5), value: activateGlassMorphism)
    }
    .padding(.horizontal, 25)
    .frame(height: 220)
  }
  
  func cardContent() -> some View {
    VStack(alignment: .leading, spacing: 12) {
      HStack {
        Text("MEMBERSHIP")
          .modifier(CardFontModifier(font: .callout))
        
        Image(systemName: "chevron.left.to.line")
          .resizable()
          .aspectRatio(contentMode: .fit)
          .foregroundColor(.white)
          .frame(width: 40, height: 40)
      }
      
      Spacer()
      
      Text("CHANG MIN PARK")
        .modifier(CardFontModifier(font: .title3))
      
      Text("KAVSOFT")
        .modifier(CardFontModifier(font: .callout))
    }
    .padding(20)
    .padding(.vertical, 10)
    .blendMode(.overlay)
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
  }
}


struct CardFontModifier: ViewModifier {
  var font: Font
  
  func body(content: Content) -> some View {
    content
      .font(font)
      .fontWeight(.semibold)
      .foregroundColor(.white)
      .kerning(1.2)
      .shadow(radius: 15)
      .frame(maxWidth: .infinity, alignment: .leading)
  }
}

struct CustomBlurView: UIViewRepresentable {
  var effect: UIBlurEffect.Style
  var onChange: (UIVisualEffectView) -> ()
  
  func makeUIView(context: Context) -> UIVisualEffectView {
    let view = UIVisualEffectView(effect: UIBlurEffect(style: effect))
    return view
  }
  
  func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
    DispatchQueue.main.async {
      onChange(uiView)
    }
  }
}

// MARK: Adjusting Blur Radius In UIVisualEffectView
extension UIVisualEffectView {
  // MARK: Steps
  // Extracting private class BackDropView Class
  // Then from that view extracting ViewEffects like Gaussian Blur & Saturation
  var backDrop: UIView? {
    // PRIVATE CLASS
    // MARK: how to know??
    return subView(forClass: NSClassFromString("_UIVisualEffectBackdropView"))
  }
  
  // MARK: Extracting Gaussian Blur From BackDropView
  var gaussianBlur: NSObject? {
    return backDrop?.value(key: "filters", filter: "gaussianBlur")
  }
  
  // MARK: Extracting Saturation From BackDropView
  var saturation: NSObject? {
    return backDrop?.value(key: "filters", filter: "colorSaturate")
  }
  
  var gaussianBlurRadius: CGFloat {
    get {
      return gaussianBlur?.values?["inputRadius"] as? CGFloat ?? 0
    }
    set {
      gaussianBlur?.values?["inputRadius"] = newValue
      applyNewEffects()
    }
  }
  
  var saturationAmount: CGFloat {
    get {
      return saturation?.values?["inputAmount"] as? CGFloat ?? 0
    }
    set {
      saturation?.values?["inputAmount"] = newValue
      applyNewEffects()
    }
  }
  
  func applyNewEffects() {
    UIVisualEffectView.animate(withDuration: 0.5) {
      self.backDrop?.perform(Selector(("applyRequestedFilterEffects")))
    }
  }
}

extension UIView {
  func subView(forClass: AnyClass?) -> UIView? {
    return subviews.first { view in
      type(of: view) == forClass
    }
  }
}

extension NSObject {
  var values: [String : Any]? {
    get {
      return value(forKey: "requestedValues") as? [String : Any]
    }
    set {
      setValue(newValue, forKeyPath: "requestedValues")
    }
  }
  
  func value(key: String, filter: String) -> NSObject? {
    (value(forKey: key) as? [NSObject])?.first {
      $0.value(forKeyPath: "filterType") as? String == filter
    }
  }
}

struct Home_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
