//
//  EditImageScreen.swift
//  LoveWidget
//
//  Created by Javad on 9/24/23.
//

import SwiftUI
import MetalPetal

struct EditImageScreen: View {
    
    @EnvironmentObject var mainViewModel : MainViewModel
    @EnvironmentObject var widgetViewModel : WidgetViewModel
    @EnvironmentObject var appState: AppState
    @Environment(\.displayScale) var displayScale
    
    @State var colorGradient : String = "colorBackground4"
    @State var fontColor : String = "textBlackColor"
    @State var textFont : String = "SF UI TEXT"
    @State var defaultTexts : String = ""
    
    @State var textFieldText = ""
    
    var body: some View {
        ZStack {
            
            Color(hex: "#FEEAEA")
                .ignoresSafeArea()
                .onTapGesture {
                    UIApplication.shared.endEditing()
                }
                .onAppear {
                    print("here")
                    appState.image = widgetViewModel.selectedImage
                }
            
            VStack {
                
                header
                    .zIndex(5)
                
                Spacer()
                
                // view
                
                editImageView
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                
                // view
                
                Spacer()
                
                // BottomViews
                
                WidgetEditImageFooter2()
                
            }
        }
    }
    
    var editImageView: some View {
        ZStack {
//            Image(uiImage: widgetViewModel.selectedImage ?? UIImage())
//                .resizable()
//                .scaledToFill()
//                .frame(width: UIScreen.screenWidth - 40, height: UIScreen.screenWidth - 40)
            if appState.image != nil {
                Image(cpImage: appState.filteredImage != nil ? appState.filteredImage! : appState.image!)
                    .resizable()
                    .scaledToFill()
                    .frame(width: UIScreen.screenWidth - 40, height: UIScreen.screenWidth - 40)
            }
//            Image(cpImage: appState.filteredImage != nil ? appState.filteredImage! : appState.image!)
//                .resizable()
//                .aspectRatio(contentMode: .fit)
        }
    }
    
    
    var header: some View {
        HStack {
            
            Button {
                //back to main
                withAnimation {
                    mainViewModel.SCREEN_VIEW = .WidgetSingle
                }
            } label: {
                Image("iconBack")
                    .frame(width: 64, height: 28)
                    .padding()
            }
            
            Spacer()
            
            Text(appName)
                .bold()
                .font(.system(size: 16))
            
            Spacer()
            
            Button {
                // save
//                widgetViewModel.selectedImage = editQuoteView.clipShape(RoundedRectangle(cornerRadius: 10)).asImage()
                
                if let image = appState.filteredImage {
                    widgetViewModel.selectedImage = appState.filteredImage
                } else {
                    widgetViewModel.selectedImage = appState.image
                }
                withAnimation {
                    mainViewModel.SCREEN_VIEW = .UploadImageScreen
                }
                
            } label: {
                ZStack {
                    
                    Color(hex: "#FDA3A3")
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    
                    Text("Next")
                        .foregroundStyle(.white)
                    
                }.frame(width: 100, height: 28)
                    .padding(.trailing, 16)
            }


            
        }
        .padding(.horizontal, 0)
    }
}

struct WidgetEditImageFooter2 : View {
    
    
    @EnvironmentObject var widgetViewModel : WidgetViewModel
    @EnvironmentObject var appState : AppState
    @EnvironmentObject var mainViewModel : MainViewModel
    
    @State var txtIndex = 2
    
    
    var body: some View {
        ZStack {
            
            Color(hex: "#FFDBDB")
                .opacity(0.5)
                .clipShape(RoundedRectangle(cornerRadius: 22))
                .ignoresSafeArea()
                .onChange(of: txtIndex) { newValue in
                    if newValue == 0 {
                        withAnimation {
                            mainViewModel.SCREEN_VIEW = .ImageCropperView
                        }
                    }
                }
            
            ZStack {
                
                VStack {
                    ZStack {
                        Color(hex: "#FFDBDB")
                            .cornerRadius(22, corners: [.topLeft,.topRight])
                            .frame(height: 135)
                        
                        if txtIndex == 0 {
                            
                            HStack(spacing: 20) {
                                
                                ForEach(cropImageListOptions,id: \.self) { item in
                                    
                                    VStack(spacing: 4) {
                                        
                                        Image("icon\(item)")
                                            .resizable()
                                            .frame(width: 30, height: 30)
                                        
                                        Text(item)
                                            .font(.system(size: 16))
                                            .foregroundColor(Color(hex: txtIndex == 0 ? "#FF8B8B" : "#767676"))
                                        
                                    }
                                }
                                
                            }.frame(height: 70)
                            
                        } else if txtIndex == 1 {
                            
                            HStack {
                                
                               
                            }
                            
                        } else if txtIndex == 2 {
                            HStack(spacing: 20) {
                                
                                CarouselFilterView(image: appState.image, filteredImage: self.$appState.filteredImage, appState: appState)
                                    .equatable()
                            }
                        }
                        
                    }.padding(.horizontal, 0)
                    
                    Spacer()
                }
                
                VStack {
                    
                    Spacer()
                    
                    HStack {
                      
                        Button {
                            withAnimation {
                                txtIndex = 0
                            }
                        } label: {
                            Text("Crop & Rotate")
                                .frame(width: 150)
                                .font(.system(size: 16))
                                .foregroundColor(Color(hex: txtIndex == 0 ? "#FF8B8B" : "#767676"))
                        }
                        
                        Button {
                            withAnimation {
                                txtIndex = 2
                            }
                        } label: {
                            Text("Effect")
                                .frame(width: 150)
                                .font(.system(size: 16))
                                .foregroundColor(Color(hex: txtIndex == 2 ? "#FF8B8B" : "#767676"))
                        }

                        
                    }
                    .padding(.horizontal, 24)
                    
                }.frame(height: 130)
                
            }
            
        }.frame(height: 200)
    }
    
    @State var cropImageListOptions = [
        "Original",
        "Free",
        "Square",
    ]
    
}


#Preview {
    EditImageScreen()
}


struct CarouselImageFilter: Identifiable, Equatable {
    
    var id: String {
        filter.rawValue + String(image.hashValue)
    }
    
    var filter: ImageFilter
    var image: CPImage
}

struct CarouselFilterView: View {
    
    let image: CPImage?
    @Binding var filteredImage: CPImage?
    @State var appState : AppState
    @State var selectedFilter : String? = nil
    
    fileprivate var imageFilters: [CarouselImageFilter] {
        guard let image = self.image else { return [] }
        return ImageFilter.allCases.map { CarouselImageFilter(filter: $0, image: image) }
    }
    
    var body: some View {
        VStack {
            if image != nil {
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(alignment: .top, spacing: 0) {
                        ForEach(imageFilters) { imageFilter in
                            VStack {
                                var x = ImageFilterObservable(image: imageFilter.image,
                                                                                filter: imageFilter.filter)
                                ImageFilterView(appState: $appState,
                                                observableImageFilter: x,
                                                filteredImage: self.$filteredImage,
                                                imageFilter: imageFilter)
                                    .padding(.leading, 16)
                                    .padding(.trailing, self.imageFilters.last!.filter == imageFilter.filter ? 16 : 0)
                                    
                            }
                            
                            
                        }
        
                    }
                    .frame(height: 80)
                }
            }
        }
    }
}
class ImageFilterObservable: ObservableObject {
    
    @Published var filteredImage: CPImage? = nil
    @Published var selectedFilter: String? = nil

    let image: CPImage
    let filter: ImageFilter
    
    init(image: CPImage, filter: ImageFilter) {
        self.image = image
        self.filter = filter
    }
    
    func filterImage() {
        self.filter.performFilter(with: self.image) {
            self.filteredImage = $0
        }
    }
}

extension CarouselFilterView: Equatable {

    static func == (lhs: CarouselFilterView, rhs: CarouselFilterView) -> Bool {
        return lhs.image == rhs.image
    }
}


struct ImageFilterView: View {
    
    @Binding var appState : AppState
    @ObservedObject var observableImageFilter: ImageFilterObservable
    @Binding var filteredImage: CPImage?
    let imageFilter : CarouselImageFilter
    @State var selectedFilter : String? = nil
    
    var body: some View {
        VStack {
            ZStack {
                Image(cpImage: observableImageFilter.filteredImage != nil ? observableImageFilter.filteredImage! : observableImageFilter.image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 60,height: 60)
                    .clipShape(RoundedRectangle(cornerRadius: 10.0))
                
                if observableImageFilter.filteredImage == nil {
                    ProgressView()
                }
            }
            
            Text(observableImageFilter.filter.rawValue)
                .font(.system(size: 12.0))
                .foregroundStyle(Color.black.opacity(0.7))
        }
        .onAppear(perform: self.observableImageFilter.filterImage)
        .onTapGesture(perform: handleOnTap)
    }
    
    private func handleOnTap() {
        appState.selectedImageFilter = imageFilter.id
        print(imageFilter.id)
        print(appState.selectedImageFilter)
        
        guard let filteredImage = observableImageFilter.filteredImage else {
            return
        }
        self.filteredImage = filteredImage
    }
}


let serialQueue = DispatchQueue(label: "com.alfianlosari.imagefilter")

enum ImageFilter: String, Identifiable, Hashable, CaseIterable {
    
    var id: ImageFilter { self }
    
    case `default` = "Default"
    case contrast = "Contrast"
    case saturation = "Saturation"
    case pixellate = "Pixellate"
    case inverted = "Inverted"
    case dotScreen = "Dot Screen"
    case vibrance = "Vibrance"
    case skinSmoothing = "Skin Smoothing"
    case colorHalfTone = "Halftone"
    
    func performFilter(with image: CPImage, queue: DispatchQueue = serialQueue, completion: @escaping(CPImage) -> ()) {
        
        DispatchQueue.global(qos: .userInitiated).async {
            let outputImage: CPImage
            
            switch self {
            case .default:
                outputImage = image
                
            case .pixellate:
                outputImage = self.processFilterWithMetal(image: image) { (inputImage) -> MTIImage? in
                    let filter = MTIPixellateFilter()
                    filter.inputImage = inputImage
                    return filter.outputImage
                }
                
            case .saturation:
                outputImage = self.processFilterWithMetal(image: image) { (inputImage) -> MTIImage? in
                    let filter = MTISaturationFilter()
                    filter.saturation = 0
                    filter.inputImage = inputImage
                    return filter.outputImage
                }
                
            case .dotScreen:
                outputImage = self.processFilterWithMetal(image: image) { (inputImage) -> MTIImage? in
                    let filter = MTIDotScreenFilter()
                    filter.inputImage = inputImage
                    return filter.outputImage
                }
                
            case .inverted:
                outputImage = self.processFilterWithMetal(image: image) { (inputImage) -> MTIImage? in
                    let filter = MTIColorInvertFilter()
                    filter.inputImage = inputImage
                    return filter.outputImage
                }
                
            case .vibrance:
                outputImage = self.processFilterWithMetal(image: image) { (inputImage) -> MTIImage? in
                    let filter = MTIVibranceFilter()
                    filter.amount = 0.5
                    filter.inputImage = inputImage
                    return filter.outputImage
                }
                
            case .skinSmoothing:
                outputImage = self.processFilterWithMetal(image: image) { (inputImage) -> MTIImage? in
                    let filter = MTIHighPassSkinSmoothingFilter()
                    filter.amount = 1
                    filter.radius = 5
                    
                    filter.inputImage = inputImage
                    return filter.outputImage
                }
                
            case .contrast:
                outputImage = self.processFilterWithMetal(image: image) { (inputImage) -> MTIImage? in
                    let filter = MTIContrastFilter()
                    filter.contrast = 1.5
                    filter.inputImage = inputImage
                    return filter.outputImage
                }
                
            case .colorHalfTone:
                outputImage = self.processFilterWithMetal(image: image) { (inputImage) -> MTIImage? in
                    let filter = MTIColorHalftoneFilter()
                    filter.scale = 2
                    
                    filter.inputImage = inputImage
                    return filter.outputImage
                }
                
                
                
   
                
            }
            
            DispatchQueue.main.async {
                completion(outputImage)
            }
        }
    }
    
    private func processFilterWithMetal(image: CPImage, filterHandler: (MTIImage) -> MTIImage?) -> CPImage {
        guard let ciImage = image.coreImage else {
            return image
        }
        
        let imageFromCIImage = MTIImage(ciImage: ciImage).unpremultiplyingAlpha()
        
        guard let outputFilterImage = filterHandler(imageFromCIImage), let device = MTLCreateSystemDefaultDevice(), let context = try? MTIContext(device: device)  else {
            return image
        }
        do {
            let outputCGImage = try context.makeCGImage(from: outputFilterImage)
            let nsImage = outputCGImage.cpImage
            
            return nsImage
        } catch {
            print(error)
            return image
        }
    }
}

