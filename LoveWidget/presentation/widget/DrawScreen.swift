//
//  DrawScreen.swift
//  LoveWidget
//
//  Created by Javad on 10/16/23.
//

import SwiftUI

struct DrawScreen: View {
    @EnvironmentObject var mainViewModel : MainViewModel
    @EnvironmentObject var widgetViewModel : WidgetViewModel
    @EnvironmentObject var appState: AppState
    @Environment(\.displayScale) var displayScale
    
    @State var colorGradient : String = "colorBackground4"
    @State var fontColor : String = "textBlackColor"
    @State var textFont : String = "SF UI TEXT"
    @State var defaultTexts : String = ""
    
    @State var textFieldText = ""
    
    @State private var selctedColor: Color = .black
    @State private var lines = [Line]()
    @State private var undoLines = [Line]()
    
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
                
                Spacer()
                    .frame(height: 36)
                
                // view
                
                VStack {
                    editImageView
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    
                    Spacer()
                    
                    HStack {
                        Button {
                            let line = lines.remove(at: lines.count - 1)
                            undoLines.append(line)
                            
                        } label: {
                            Image(.iconUndo)
                                
                        }.disabled(lines.count == 0)
                        
                        Button {
                            let line = undoLines.removeLast()
                            lines.append(line)
                        } label: {
                            Image(.iconUndo)
                            
                                .rotation3DEffect(
                                    .degrees(180),axis: (x: 0.0, y: 1.0, z: 0.0)
                                )
                        }.disabled(undoLines.count == 0)
                        
                    }
                    .padding()
                    
                }
                // view
                
                
                // BottomViews
                
                WidgetEditImageFooter3(selectedColor: $selctedColor)
                
            }
        }
    }
    
    var editImageView: some View {
        ZStack {

            VStack {
                Canvas { context, size in
                                for line in lines {
                                    let path = createPath(for: line.points)
                                    context.stroke(path,
                                        with: .color(line.color),
                                        lineWidth: 4)
                                }
                            }
                            .gesture(DragGesture(minimumDistance: 0).onChanged({ value in
                                if value.translation.width + value.translation.height == 0 {
                                    //length of line is zero -> new line
                                    lines.append(Line(points: [CGPoint](), linewidth: 1, color: selctedColor))
                                } else {
                                    let index = lines.count - 1
                                    lines[index].points.append(value.location)
                                }
                            }))
                            .frame(width: UIScreen.screenWidth - 64,
                                   height: UIScreen.screenWidth - 64)
                            .background {
                                Color.white
                                    .frame(width: UIScreen.screenWidth - 64,
                                           height: UIScreen.screenWidth - 64)
                            }.clipShape(RoundedRectangle(cornerRadius: 10))
                            
                
            }
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
                widgetViewModel.selectedImage = editImageView.clipShape(RoundedRectangle(cornerRadius: 10)).asImage()
                
                withAnimation {
                    mainViewModel.SCREEN_VIEW = .UploadImageScreen
                }
                
            } label: {
                ZStack {
                    
                    Color(hex: "#FDA3A3")
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    
                    Text("Send")
                        .foregroundStyle(.white)
                    
                }.frame(width: 100, height: 28)
                    .padding(.trailing, 16)
            }


            
        }
        .padding(.horizontal, 0)
    }
    
    func createPath(for line: [CGPoint]) -> Path {
        var path = Path()
        if let firstPoint = line.first {
            //use scaling factor
            path.move(to:firstPoint)
        }
        if line.count > 2 {
            for index in 1..<line.count {
                let mid = calculateMidPoint(line[index - 1], line[index])
                path.addQuadCurve(to: mid, control: line[index - 1])
            }
        }
        if let last = line.last {
            path.addLine(to: last)
        }
        return path
    }
    
    func calculateMidPoint(_ point1: CGPoint, _ point2: CGPoint) -> CGPoint {
        let newMidPoint = CGPoint(x: (point1.x + point2.x)/2, y: (point1.y + point2.y)/2)
        return newMidPoint
    }
}

#Preview {
    DrawScreen()
}


struct WidgetEditImageFooter3 : View {
    
    
    @EnvironmentObject var widgetViewModel : WidgetViewModel
    @EnvironmentObject var appState : AppState
    @EnvironmentObject var mainViewModel : MainViewModel
    
    @Binding var selectedColor: Color
    
    @State var txtIndex = 0
    
    
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
                            .frame(height: 80)
                        
                        if txtIndex == 0 {
                            
                            CColorPicker(selctedColor: $selectedColor)
                            
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
                            Text("Color")
                                .frame(width: 150)
                                .font(.system(size: 16))
                                .bold()
                                .foregroundColor(Color(hex: txtIndex == 0 ? "#FF8B8B" : "#767676"))
                        }
                        
                    }
                    .padding(.horizontal, 24)
                    
                }.frame(height: 90)
                
            }
            
        }.frame(height: 120)
    }
    
}

struct CColorPicker: View {
    let colors:  [Color] = [.black, .blue, .green, .red]
    
    @Binding var selctedColor: Color
    
    var body: some View {
//        ScrollView(.horizontal, showsIndicators: true) {
            HStack {
                ForEach(colors, id: \.self) { c in
                    c.frame(width: 38, height: 38)
                        .cornerRadius(10)
                        .overlay(content: {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color(hex: "#FDA3A3"), lineWidth: selctedColor == c ? 4 : 0)
                        })
                        .onTapGesture {
                            selctedColor = c
                        }
                }
            }.padding()
            
//        }
    }
}

struct CColorPicker_Previews: PreviewProvider {
    @State static private var slectedColor = Color.purple
    static var previews: some View {
        CColorPicker(selctedColor: $slectedColor)
    }
}


struct Line: Identifiable {
    var points: [CGPoint]
    var linewidth: CGFloat
    var color: Color
    let id = UUID()
}
