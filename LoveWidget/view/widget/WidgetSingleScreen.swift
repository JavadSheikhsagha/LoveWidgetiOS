//
//  WidgetSingleScreen.swift
//  LoveWidget
//
//  Created by Javad on 8/29/23.
//

import SwiftUI

struct WidgetSingleScreen: View {
    
    @EnvironmentObject var mainViewModel : MainViewModel
    @EnvironmentObject var widgetViewModel : WidgetViewModel
    @EnvironmentObject var friendsViewModel : FriendsViewModel
    
    @State var showDeleteWidgetDialog = false
    @State var showFriendsBottomSheet = false
    @State var showAction: Bool = false
    @State var showImagePicker: Bool = false
    @State var showCameraPicker: Bool = false
    @State var uiImage: UIImage? = nil
    
    var body: some View {
        ZStack {
            
            Color(hex: "#EEF1FF")
                .ignoresSafeArea()
                .onAppear {
                    widgetViewModel.getSingleWidget { bool in }
                    widgetViewModel.historyWidgets = []
                    widgetViewModel.selectedImage = nil
                }
            
            
            VStack {
                
                header
                
                userImagesTop
                
                addHistoryCards
                
                checkHistoryCard
                
                addWidgetToHomeScreenBtn
                
                
            }
            
            ZStack {
                
                Color.black
                    .opacity(showDeleteWidgetDialog ? 0.5 : 0.0)
                    .offset(y: showDeleteWidgetDialog ? 0 : UIScreen.screenHeight)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation {
                            showDeleteWidgetDialog = false
                        }
                    }
                
                deleteWidgetDialog
                
            }
            
        }
        .alert(widgetViewModel.errorMessage, isPresented: $widgetViewModel.isErrorOccurred) {
            Button("ok") {
                widgetViewModel.isErrorOccurred = false
            }
        }
        .actionSheet(isPresented: $showAction) {
            sheet
        }
        .sheet(isPresented: $showImagePicker, onDismiss: {
                    self.showImagePicker = false
                }, content: {
                    ImagePicker(isShown: self.$showImagePicker, uiImage: self.$uiImage, sourceType: .photoLibrary)
                })
        .sheet(isPresented: $showCameraPicker, onDismiss: {
                    self.showCameraPicker = false
                }, content: {
                    ImagePicker(isShown: self.$showCameraPicker, uiImage: self.$uiImage, sourceType: .camera)
                })
        .onChange(of: self.uiImage) { newValue in
            if let image = self.uiImage {
                widgetViewModel.selectedImage = image
                withAnimation {
                    mainViewModel.SCREEN_VIEW = .UploadImageScreen
                }
            }
        }
        .sheet(isPresented: $showFriendsBottomSheet) {
            FriendsScreen(doNeedSelectFriend: true)
                .onChange(of: showFriendsBottomSheet) { newValue in
                    if !showFriendsBottomSheet && friendsViewModel.selectedFriend != nil {
                        // add friend to widget
                        friendsViewModel.selectedFriend = nil
                    }
                }
        }
    }
    
    var sheet: ActionSheet {
        ActionSheet(
            title: Text("Action"),
            message: Text("Quotemark"),
            buttons: [
                .default(Text("Gallery"), action: {
                    self.showAction = false
                    self.showImagePicker = true
                    self.uiImage = nil
                }),
                .cancel(Text("Close"), action: {
                    self.showAction = false
                    
                }),
                .default(Text("Camera"), action: {
                    self.showAction = false
                    self.uiImage = nil
                    self.showCameraPicker = true
                })
            ])
    }
    
    var deleteWidgetDialog : some View {
        ZStack {
            
            Color(hex: "#FFFFFF")
                .frame(width: UIScreen.screenWidth - 64, height: 120)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            
            VStack(spacing: 20) {
                
                Text("Are you sure you want to Delete this widget?")
                    .font(.system(size: 14))
                    .foregroundColor(Color(hex: "#707070"))
                
                
                HStack(spacing: 32) {
                    
                    Button(action: {
                        withAnimation {
                            showDeleteWidgetDialog = false
                        }
                    }, label: {
                        Image("btnCancel")
                    })
                    
                    Button(action: {
                        
                        widgetViewModel.deleteWidget { bool in
                            if bool {
                                withAnimation {
                                    showDeleteWidgetDialog = false
                                    mainViewModel.SCREEN_VIEW = .MainMenu
                                }
                                
                            } else {
                                
                            }
                        }
                        
                        
                    }, label: {
                        Image("btnDelete")
                    })
                    
                }
            }
        }
        .frame(width: UIScreen.screenWidth - 64, height: 120)
        .opacity(showDeleteWidgetDialog ? 1.0 : 0.0)
        .offset(y: showDeleteWidgetDialog ? 0 : UIScreen.screenHeight)
    }
    
    var addWidgetToHomeScreenBtn : some View {
        VStack {
            
            Spacer()
            
            Button {
                
            } label: {
                Image(.addToHomeBtn)
                    .resizable()
                    .frame(width: UIScreen.screenWidth - 48, height: 55)
            }

        }
    }
    
    var checkHistoryCard : some View {
        VStack {
            
            Spacer()
                .frame(height: 36)
            
            Button {
                withAnimation {
                    mainViewModel.SCREEN_VIEW = .History
                }
            } label: {
                Image(.checkHistoryCard)
                    .resizable()
                    .frame(width: UIScreen.screenWidth - 40, height: 88)
            }

        }
    }
    
    var addHistoryCards : some View {
        VStack {
            
            Spacer().frame(height: 42)
            
            HStack(spacing: 24) {
                
                Button {
                    
                } label: {
                    Image(.addQuoteCard)
                        .resizable()
                        .frame(width : (UIScreen.screenWidth - 64) / 2, height: (UIScreen.screenWidth - 64) / 2)
                }

                Button {
                    self.showAction = true
                } label: {
                    Image(.addImageCard)
                        .resizable()
                        .frame(width : (UIScreen.screenWidth - 64) / 2, height: (UIScreen.screenWidth - 64) / 2)
                }
            }
        }
    }
    
    var userImagesTop : some View {
        VStack {
            
            HStack(spacing: 15) {
                
                VStack(spacing: 10) {
                    AsyncImage(url: URL(string: loadUser()?.profileImage ?? "imgUrl")!) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                            } placeholder: {
                                Image(.imgUserSample)
                                
                            }.frame(width: 84, height: 84)
                        .clipShape(RoundedRectangle(cornerRadius: 42))
                    
                    Text(loadUser()?.username ?? "Username")
                      .font(Font.custom("SF UI Text", size: 14))
                      .foregroundColor(Color(red: 0.08, green: 0.08, blue: 0.1))
                }
                
                Button {
                    //send notif
                } label: {
                    Image(.imgHeartMiss)
                }.offset(y: -10)

                
                VStack(spacing: 0) {
                    
                    VStack(spacing:10) {
                        if widgetViewModel.getSingleWidgetData?.members.count ?? 0 > 0 {
                            AsyncImage(url: URL(string: widgetViewModel.getSecondMember()?.profileImage ?? "imgUrl")!) { image in
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                    } placeholder: {
                                        
                                        Image(.imgUserSample)
                                    }.frame(width: 84, height: 84)
                                .clipShape(RoundedRectangle(cornerRadius: 42))
                        } else {
                            Image(.imgUserSample)
                        }
                        
                        Text(widgetViewModel.getSingleWidgetData?.members.count ?? 1 > 1 ?
                             widgetViewModel.getSecondMember()?.username ?? "" : widgetViewModel.isLoading ? "..." : "Add Friend")
                          .font(Font.custom("SF UI Text", size: 14))
                          .foregroundColor(Color(red: 0.08, green: 0.08, blue: 0.1))
                        
                    }.onTapGesture {
                        if widgetViewModel.getSingleWidgetData?.members.count ?? 1 == 1 {
                            showFriendsBottomSheet = true
                        }
                    }

                }
            }
        }
    }
    
    var header: some View {
        HStack {
            
            Button {
                //back to main
                withAnimation {
                    mainViewModel.SCREEN_VIEW = .MainMenu
                }
            } label: {
                Image("iconBack")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .padding()
            }
            
            Spacer()

            Text(widgetViewModel.selectedWidgetModel?.name ?? appName)
                .bold()
                .font(.system(size: 16))
            
            Spacer()
            
            
            Image("img3Dots")
                .resizable()
                .frame(width: 24, height: 24)
                .padding()
                .contextMenu {
                    Button("Delete Widget") {
                        // delete widget
                        withAnimation {
                            showDeleteWidgetDialog = true
                        }
                    }
                }

            
        }
    }
}

#Preview {
    WidgetSingleScreen()
}


struct ImagePicker: UIViewControllerRepresentable {

    @Binding var isShown: Bool
    @Binding var uiImage: UIImage?
    
    var sourceType : UIImagePickerController.SourceType

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

        @Binding var isShown: Bool
        @Binding var uiImage: UIImage?

        init(isShown: Binding<Bool>, uiImage: Binding<UIImage?>) {
            _isShown = isShown
            _uiImage = uiImage
        }

        func imagePickerController(_ picker: UIImagePickerController,
                                   didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            let imagePicked = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
            uiImage = imagePicked
            isShown = false
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            isShown = false
        }

    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(isShown: $isShown, uiImage: $uiImage)
    }

    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = sourceType
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController,
                                context: UIViewControllerRepresentableContext<ImagePicker>) {

    }

}
