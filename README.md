# SORAPhotoPicker

A PHPickerViewController wrapper for SwiftUI project.

![photo picker screenshot 1](./Images/photopicker-1.png)

## Requirements
- iOS 14.0 +


## How to use
### 1) Photo picker
```swift
//
// 1. Open photo picker & collect selected result
//
#import SORAPhotoPicker 

...

@State private var showPicker = false
@State private var selected: [SORAPhotoPickerResult] = []

func PhotoPickerDemo() -> some View {
    VStack {
        Button(action: {
            showPicker.toggle()
            self.selected.removeAll()
        }) {
            Text("Open picker")
        }
        .frame(height: 60)
        .sheet(isPresented: $showPicker, content: {
            SORAPhotoPickerHelper.shared.picker() { results in
                self.selected.append(contentsOf: results)
            }
        })
    }
}

```

```swift
//
// 2. Load image or video
//

@State private var image: UIImage?
@State private var videoURL: URL?

...

if result.isImage() {
    result.loadUIImage { image, error in
        guard let image = image, error == nil else {return}
        self.image = image
        ...
    }
} else {
    result.loadVideo { videoURL, error in
        guard let url = videoURL, error == nil else {return}
        self.videoURL = url
    }
}
```

```swift
//
// 3. Display image 
//
var body: some View {
   Image(uiImage: self.image!)
        .resizable()
        .aspectRatio(contentMode: .fit)
        .frame(width: 300) 
}

//
// 4. Display video
//
var body: some View {
   VideoPlayer(player: AVPlayer(url: videoURL!))
      .frame(width: 300)
}
```

### 2) Camera
```swift
@State private var showCamera = false
@State private var capturedImage: UIImage?
@State private var capturedVideoURL: URL?
...
func CameraPickerDemo() -> some View {
        VStack {
            Button(action: {
                self.capturedImage = nil
                self.capturedVideoURL = nil
                showCamera.toggle()
            }) {
                Text("Open camera")
            }
            .frame(height: 60)
            .sheet(isPresented: $showCamera, content: {
                SORACameraPicker(onDismiss:{
                                },
                                 onCapturePhoto:{ uiImage in
                                    self.capturedImage = uiImage
                                 },
                                 onCaptureVideo:{ url in
                                    self.capturedVideoURL = url
                                 })
            })
        }
    }
```
