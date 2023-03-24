# TranslateX (Under Development)

This is an app I created for learning purposes. TranslateX supports translating for over 30 languages. It is using Google's MLKit API to translate, identify between languages.

<p align="center">
<img src="https://github.com/Pistifeju/TranslateX/blob/main/screenshots.png" width="1080"/>
</p>

## Features

* 33 Languages Support: Translate between 33 different languages effortlessly.
* Conversations Translation: Translate spoken conversations in real-time for seamless communication.
* Image Translation: Translate text from images with OCR technology.
* iOS 16 Compatibility: Designed for devices running iOS 16 or later.

## Requirements

* Device running iOS 16 or later.
* Internet connection to download languages.
* Cocoapods

## Known Issues

When building the app on an Apple Silicon Mac, you may encounter an error message that reads:

`Warning: Error creating LLDB target at path '/Users/../Library/Developer/Xcode/DerivedData/TranslateMe-ajczkkqdyepzjfbdxflalewrefvv/Build/Products/Debug-iphonesimulator/TranslateX.app'- using an empty LLDB target which can cause slow memory reads from remote devices: the specified architecture 'arm64-*-*' is not compatible with 'x86_64-apple-ios16.0.0-simulator' in '/Users/../Library/Developer/Xcode/DerivedData/TranslateMe-ajczkkqdyepzjfbdxflalewrefvv/Build/Products/Debug-iphonesimulator/TranslateX.app/TranslateX'`

Unfortunately, at this time, I have not been able to resolve this issue. As a workaround, I recommend building and testing the app on a real iOS device instead of using the simulator.

## License

This project is licensed under the MIT License.
