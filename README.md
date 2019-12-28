# StringFix

A zero-dependency pure Swift library which adds useful functionality to the String Protocol. By extending String Protocol, all of these methods become available on Strings as well as Substrings and other SubSequences so you can chain them together. Most of the functionality in this library returns a subsequence rather than a new string, which saves on memory usage.

## Installation
### Prerequisites
This package requires Swift 5 and Xcode 11 (package is untested on earlier versions of Swift and Xcode)

### Add To Project
Add this package to your package.swift
```swift
.package(url: "https://github.com/" from: "1.0.0")
```

## Usage
```swift
import StringFix
```

## Subscripts
Subscripting with Integers is now allowed
```swift
"Hello World!"[2...6] // "llo W"
"Hello World!"[6...]  // "World!"
"Hello World!"[...4]  // "Hello"
"Hello World!"[0..<11]  // "Hello World"
```
Subscripts can be chained together 
```swift
"https://just1guy.org"[8...][..<8] // "just1guy"
```

## Methods
### between (_ begin: String, _ end: String? = nil) -> SubSequence
```swift
"##foo##".between("##")                      // "foo"
"<a>some link</a>".between("<a>", "</a>")    // "some link"
"## ##foo## ##".between("##")                // " ##foo## "
```
### outerBetween (_ begin: String, _ end: String? = nil) -> SubSequence
```swift
"##foo##".outerBetween("##")                      // "##foo##"
"<a>some link</a>".outerBetween("<a>", "</a>")    // "<a>some link</a>"
"## ##foo## ##".outerBetween("##")                // "## ##foo## ##"
```
### camelize () -> String
```swift
"id number".camelize()      // "idNumber"
"HelloWorld".camelize()     // "helloWorld"
"text_size".camelize()      // "textSize"
"first-name".camelize()     // "firstName"
```
### collapseWhitespace() -> String
```swift
"  So  much \t\n space!  "  // "So much space!"
```
### ensureLeft() -> String
```swift
"/etc/config".ensureLeft("/")   // "/etc/config"
"etc/config".ensureLeft("/")    // "/etc/config"
```
### ensureRight() -> String
```swift
"https://just1guy.org/".ensureRight("/")    // "https://just1guy.org/"
"https://just1guy.org".ensureRight("/")     // "https://just1guy.org/"
```
### isAlpha() -> Bool
```swift
"foobar".isAlpha()      // true
"f00b4r".isAlpha()      // false
"FooBar".isAlpha()      // true
```
### isAlphaNumeric() -> Bool
```swift
"FooBar5".isAlphaNumeric()      // true
"123abc".isAlphaNumeric()       // true
"-32".isAlphaNumeric()          // false
```
### isNumeric() -> Bool
```swift
"123".isNumeric()       // true
"f00b4r".isNumeric()    // false
```
### isEmpty() -> Bool
```swift
"   ".isEmpty()         // true
"\n\t".isEmpty()        // true
"  foo  ".isEmpty()     // false
```
### trimLeft() -> SubSequence
```swift
"   \n\t Hello World!".trimLeft()       // "Hello World!"
```
### trimRight() -> SubSequence
```swift
"Hello World!   \n\t  ".trimLeft()      // "Hello World!"
```
### trim() -> SubSequence
```swift
" \t Hello World! \t  ".trim()          // "Hello World!"
```
### stripPunctuation() -> String
```swift
"So... many, do:t(s)!".stripPunctuation()   // "So many dots"
````

### padLeft(_ count: Int, _ with: String = " ") -> String
```swift
"Pad me please".padLeft(4)              // "    Pad me please"
"Cool words".padLeft(2, "~")            // "~~Cool words"
```

### padRight(_ count: Int, _ with: String = " ") -> String
```swift
"Foobar".padRight(4)              // "Foobar    "
"Hello".padRight(3, "!")            // "Hello!!!"
```

### pad(_ count: Int, _ with: String = " ") -> String
```swift
"Swift is awesome".pad(3)              // "   Swift is awesome   "
"Hello".padRight(3, "!")            // "Hello!!!"
```
### times(_ count: Int) -> String
```swift
"Foo".times(5)          // "FooFooFooFooFoo"
```
