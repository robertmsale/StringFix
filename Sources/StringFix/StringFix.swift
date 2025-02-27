import Foundation

public extension StringProtocol {
    //  Allow using integers as subscripts
    subscript(_ offset: Int)                     -> Element     { self[index(startIndex, offsetBy: offset)] }
    subscript(_ range: Range<Int>)               -> SubSequence { prefix(range.lowerBound+range.count).suffix(range.count) }
    subscript(_ range: ClosedRange<Int>)         -> SubSequence { prefix(range.lowerBound+range.count).suffix(range.count) }
    subscript(_ range: PartialRangeThrough<Int>) -> SubSequence { prefix(range.upperBound.advanced(by: 1)) }
    subscript(_ range: PartialRangeUpTo<Int>)    -> SubSequence { prefix(range.upperBound) }
    subscript(_ range: PartialRangeFrom<Int>)    -> SubSequence { suffix(Swift.max(0, count-range.lowerBound)) }
    
    /// Returns a subsequence derived from two bookends, including the bookends themselves
    ///
    /// - parameter begin: The left bookend
    /// - parameter endsWith: The right bookend (optional)
    ///
    /// - returns: The subsequence (String, Substring, etc) between two bookends, or returns the whole string intact if subsequence cannot be found.
    func outerBetween( _ begin: String, _ end: String? = nil ) -> SubSequence {
        var startI = self.startIndex
        var endI = self.endIndex
        for i in 0 ..< self.count {
            if self[ index( startIndex, offsetBy: i ) ..< endIndex ].hasPrefix( begin ) {
                startI = index( startIndex, offsetBy: i )
                break
            }
        }
        for i in 0 ..< self.count {
            if self[ startIndex ..< index( endIndex, offsetBy: -i) ].hasSuffix(end ?? begin) {
                endI = index( endIndex, offsetBy: -i )
                break
            }
        }
        
        return self[startI..<endI]
    }
    
    /// Returns a subsequence derived from two bookends, excluding the bookends themselves
    ///
    /// - parameter begin: The left bookend
    /// - parameter endsWith: The right bookend
    ///
    /// - returns: The subsequence (String, Substring, etc) between two bookends, or returns the whole string intact if subsequence cannot be found
    func between( _ begin: String, _ end: String? = nil ) -> SubSequence {
        let outer = outerBetween( begin, end )
        return outer[
            outer.index( outer.startIndex, offsetBy: begin.count )
                ..< outer.index ( outer.endIndex, offsetBy: -(end?.count ?? begin.count ) ) ]
    }
    
    /// Makes first letter capital and remaining letters lowercase
    func capitalize() -> String {
        return self[0].uppercased() + self[1..<self.count].lowercased()
    }
    
    /// Converts a string to camelcase
    func camelize() -> String {
        let foundWords = words()
        guard !foundWords.isEmpty else { return "" }
        var stringBuilder = ""
        for (idx, word) in foundWords.enumerated() {
            if idx == 0 {
                stringBuilder.append(word.lowercased())
                continue
            }
            stringBuilder.append(word[0].uppercased())
            stringBuilder.append(word[1..<word.count].lowercased())
        }
        return stringBuilder
    }
    
    /// Removes excess whitespace, including new lines, carriage returns, tab space, etc.
    func collapseWhitespace() -> String {
        return String(self.trim())
    }
    
    /// Ensures prefix exists and, if not, returns a prepended string
    ///
    /// - parameter prefix: The string to ensure exists
    func ensureLeft(_ prefix: String) -> String {
        if self[self.startIndex..<self.index(self.startIndex, offsetBy: prefix.count)].contains(prefix) { return String(self) }
        else { return prefix + self }
    }
    
    /// Ensures suffix exists and, if not, returns an appended string
    ///
    /// - parameter suffix: The string to ensure exists
    func ensureRight(_ suffix: String) -> String {
        if self[self.index(self.endIndex, offsetBy: -suffix.count)..<self.endIndex].contains(suffix) { return String(self) }
        else { return self + suffix }
    }
    
    /// Is this string Alphabetical
    func isAlpha() -> Bool {
        return allSatisfy { c in c.isLetter }
    }
    
    /// Is this string AlphaNumeric
    func isAlphaNumeric() -> Bool {
        return allSatisfy{ c in c.isLetter || c.isNumber }
    }
    
    /// Does this string only contain numbers and decimal point
    func isNumeric() -> Bool {
        var decimalFound: Bool = false;
        for c in self {
            if (!c.isNumber) && (c != ".") {
                return false
            }
            if (c == ".") {
                if (decimalFound) { return false }
                decimalFound = true
            }
        }
        return true
    }
    
    /// Does this string only contain numbers
    func isIntegral() -> Bool {
        self.allSatisfy { $0.isNumber }
    }
    
    /// Is this string not nil but also empty or contain only whitespace?
    func isEmpty() -> Bool {
        return self.count == 0 || self.allSatisfy { $0.isWhitespace }
    }
    
    /// Remove whitespace from the left
    func trimLeft() -> SubSequence { return self[ (firstIndex( where: { !$0.isWhitespace } ) ?? startIndex)..<endIndex ] }
    
    /// Remove whitespace from the right
    func trimRight() -> SubSequence { return self[ startIndex...(lastIndex( where: { !$0.isWhitespace } ) ?? endIndex) ] }
    
    /// Remove whitepace from the left and right
    func trim() -> SubSequence { self.trimLeft().trimRight() }
    
    /// Convert to Slug (i.e. kebabCase) with option to preserve case.
    func slugify(preserveCase: Bool = false) -> String {
        return words()
            .map { preserveCase ? $0.string : $0.lowercased() }
            .joined(separator: "-")
    }
    
    var snakeCase: String {
        return words().map { $0.lowercased() }.joined(separator: "_")
    }
    
    /// Returns all the words in a string
    func words() -> [SubSequence] {
        if self.count == 0 { return [] }
        var result: [SubSequence] = []
        
        var curr: SubSequence = self[startIndex..<endIndex]
        while curr.count != 0 {
            guard let firstLetter = curr.firstIndex(where: { $0.isLetter }) else { break }
            let trimmed = curr[firstLetter..<endIndex]
            guard let afterLastLetter = trimmed.firstIndex(where: { !$0.isLetter }) else {
                result.append(trimmed)
                break
            }
            result.append(curr[firstLetter..<afterLastLetter])
            curr = curr[afterLastLetter..<endIndex]
        }
        
        return result
    }
    
    /// Remove all punctuation
    func stripPunctuation() -> String {
        var stringBuilder: String = ""
        
        for ( _, v ) in self.enumerated() {
            if (!v.isPunctuation) { stringBuilder.append(v) }
        }
        
        return stringBuilder
    }
    
    /// Pad the left side of the string with another string
    func padLeft(_ count: Int, _ with: String = " ") -> String {
        return Array(repeating: with, count: count).joined() + self
    }
    
    /// Pad the right side of the string with another string
    func padRight(_ count: Int, _ with: String = " ") -> String {
        return self + Array(repeating: with, count: count).joined()
    }
    
    /// Pad both sides of the string with another string
    func pad(_ count: Int, _ with: String = " ") -> String {
        return self.padLeft(count, with).padRight(count, with)
    }
    
    /// Repeat string a number of times
    func times(_ count: Int) -> String {
        return Array(repeating: self, count: (count > 1 ? count : 1)).joined()
    }
}

public extension LosslessStringConvertible {
    var string: String { .init(self) }
}

public extension BidirectionalCollection {
    subscript(safe offset: Int) -> Element? {
        guard !isEmpty, let i = index(startIndex, offsetBy: offset, limitedBy: index(before: endIndex)) else { return nil }
        return self[i]
    }
}
