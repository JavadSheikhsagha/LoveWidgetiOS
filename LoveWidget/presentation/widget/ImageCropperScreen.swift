//
//  ImageCropperScreen.swift
//  RB-Swiftui
//
//  Created by enigma 1 on 2/9/23.
//

import SwiftUI

struct ImageCropperScreen: View {
    
    @EnvironmentObject var mainController : MainViewModel
    @EnvironmentObject var widgetViewModel : WidgetViewModel
    
    @State var chosenImage : UIImage? = nil
    @State var showCrop = false
    
    var body: some View {
        ZStack {
            if showCrop {
                ImageCropper(image: $chosenImage) { img in
                    let img2 = img
                    widgetViewModel.selectedImage = img2
                    
                    withAnimation {
                        mainController.SCREEN_VIEW = .EditImage
                    }
                    
                } onCancel: {
                    withAnimation {
                        mainController.SCREEN_VIEW = .EditImage
                    }
                }
            }
        }.onAppear {
            showCrop = true
            chosenImage = widgetViewModel.selectedImage
            
        }
    }
}

struct ImageCropperScreen_Previews: PreviewProvider {
    static var previews: some View {
        ImageCropperScreen()
    }
}

struct ImageCropper: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    var isCropped : (UIImage) -> Void
    var onCancel : () -> Void
    
    var cropShapeType: CropShapeType = .square
    var presetFixedRatioType: PresetFixedRatioType = .alwaysUsingOnePresetFixedRatio(ratio: 1)
    
    @Environment(\.presentationMode) var presentationMode
    
    class Coordinator: CropViewControllerDelegate {
        func cropViewControllerDidCrop(_ cropViewController: CropViewController, cropped: UIImage, transformation: Transformation) {
            
        }
        
        func cropViewControllerDidImageTransformed(_ cropViewController: CropViewController) {
            
        }
        
        var parent: ImageCropper
        var onCropped : (UIImage) -> Void
        var onCancel : () -> Void
        
        
        init(_ parent: ImageCropper, isCropped : @escaping (UIImage) -> Void, onCancel : @escaping () -> Void) {
            self.parent = parent
            self.onCropped = isCropped
            self.onCancel = onCancel
        }
        
        func cropViewControllerDidCrop(_ cropViewController: CropViewController, cropped: UIImage, transformation: Transformation, cropInfo: CropInfo) {
            
            let img = cropped
            parent.image = img
            onCropped(img)
               print("transformation is \(transformation)")
            parent.presentationMode.wrappedValue.dismiss()
        }
        
        func cropViewControllerDidCancel(_ cropViewController: CropViewController, original: UIImage) {
            parent.presentationMode.wrappedValue.dismiss()
            onCancel()
        }
        
        func cropViewControllerDidFailToCrop(_ cropViewController: CropViewController, original: UIImage) {
        }
        
        func cropViewControllerDidBeginResize(_ cropViewController: CropViewController) {
        }
        
        func cropViewControllerDidEndResize(_ cropViewController: CropViewController, original: UIImage, cropInfo: CropInfo) {
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self) { img in
            image = img
            isCropped(img)
            
        } onCancel: {
            onCancel()
        }
    }
    
    func makeUIViewController(context: Context) -> CropViewController {
        var config = Config()
        
//        config.cropShapeType = .square
        config.presetFixedRatioType = presetFixedRatioType
//        config.showRotationDial = false
        let cropViewController = cropViewController(image: image ?? UIImage(),
                                                           config: config)
        
        
        
        cropViewController.delegate = context.coordinator
        return cropViewController
    }
    
    func updateUIViewController(_ uiViewController: CropViewController, context: Context) {
        
    }
}
