# MarkupTextView

[![Language: Swift 5](https://img.shields.io/badge/language-swift%205-f48041.svg?style=flat)](https://developer.apple.com/swift)

Dynamic textview with auto-resizing height & width that is also movable/draggable. 

<img src="demo.gif" border=1 style="border-color:#eeeeee" width="250">

## Requirements
iOS 13 or above

## Installation
MarkupTextView is installed via the official [Swift Package Manager](https://swift.org/package-manager/).  

Select `Xcode`>`File`> `Swift Packages`>`Add Package Dependency...`  
and add `https://github.com/qkrtjrrnjs/MarkupTextView`.

## Usage

- **First import MarkupTextView**
    ```swift
    import MarkupTextView
    ```

- **Implementation**
    ```swift
    let textView = MarkupTextView()
    textView.placeholder = "Enter Text"             // Default: "Text"
    textView.placeholderColor = .systemGray         // Default: .black
    textView.font = UIFont.systemFont(ofSize: 20) 
    textView.borderColor = .systemGreen             // Default: .systemBlue
    textView.drag = .always                         // Default: .always
    textView.maxHeight = 250                        // Default: UIScreen.main.bounds.size.height
    textView.maxWidth = 250                         // Default: UIScreen.main.bounds.size.width
    ```

## License

MarkupTextView is under MIT license. See the [LICENSE](LICENSE) file for more information.
