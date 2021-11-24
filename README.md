# MarkupTextView

[![Language: Swift 5](https://img.shields.io/badge/language-swift%205-f48041.svg?style=flat)](https://developer.apple.com/swift)

Dynamic textview with auto-resizing height & width that is also movable/draggable. 

## Requirements
iOS 13 or above

## Installation
MarkupTextView is installed via the official [Swift Package Manager](https://swift.org/package-manager/).  

Select `Xcode`>`File`> `Swift Packages`>`Add Package Dependency...`  
and add ``.

## Usage

- **First import MarkupTextView**
    ```swift
    import MarkupTextView
    ```

- **Implementation**
    ```swift
    let markupTextView = UITextView()
    markupTextView.placeholder = "Enter Text"
    markupTextView.font = UIFont.systemFont(ofSize: 20)
    markupTextView.drag = .always
    markupTextView.maxHeight = 100
    markupTextView.maxWidth = 100
    ```

## License

MarkupTextView is under MIT license. See the [LICENSE](LICENSE) file for more information.
