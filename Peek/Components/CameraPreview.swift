import AVFoundation
import SwiftUI

struct CameraPreview: UIViewRepresentable {
    let session: AVCaptureSession
    func makeUIView(context: Context) -> PreviewView {
        let view = PreviewView()
        view.previewLayer.videoGravity = .resizeAspectFill
        view.previewLayer.session = session
        return view
    }
    func updateUIView(_ uiView: PreviewView, context: Context) {}

    final class PreviewView: UIView {
        override class var layerClass: AnyClass { AVCaptureVideoPreviewLayer.self }
        var previewLayer: AVCaptureVideoPreviewLayer { layer as! AVCaptureVideoPreviewLayer }
    }
}

/// Stands in for the front camera when there is none (simulator) or access was denied.
/// Everything scales with its frame, so it reads the same as a 94 pt thumbnail or a full sheet.
struct DemoCameraPreview: View {
    /// Off when something else (a play button) sits in the middle.
    var showsPerson = true
    @State private var drift = false

    var body: some View {
        GeometryReader { proxy in
            let side = min(proxy.size.width, proxy.size.height)
            ZStack {
                LinearGradient(colors: [.indigo.opacity(0.8), .pink.opacity(0.55), .black], startPoint: drift ? .topLeading : .bottomTrailing, endPoint: drift ? .bottomTrailing : .topLeading)
                if showsPerson {
                    Image(systemName: "person.crop.circle.fill")
                        .resizable().scaledToFit()
                        .frame(width: side * 0.5)
                        .foregroundStyle(.white.opacity(0.48))
                        .offset(y: -side * 0.06)
                }
                Text("SIMULATED REACTION")
                    .font(.system(size: max(7, min(11, side * 0.07)), weight: .semibold))
                    .tracking(side < 140 ? 0.4 : 1.4)
                    .lineLimit(1).minimumScaleFactor(0.6)
                    .foregroundStyle(.white.opacity(0.5))
                    .padding(.horizontal, max(10, side * 0.1))   // clear of a framing stroke
                    .frame(maxHeight: .infinity, alignment: .bottom)
                    .padding(.bottom, max(8, side * 0.07))
            }
            .frame(width: proxy.size.width, height: proxy.size.height)
        }
        .animation(.easeInOut(duration: 3).repeatForever(autoreverses: true), value: drift)
        .onAppear { drift = true }
        .accessibilityLabel("Simulated reaction")
    }
}
