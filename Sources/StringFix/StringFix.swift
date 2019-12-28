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
        return outer[ outer.index( outer.startIndex, offsetBy: begin.count ) ..< outer.index ( outer.endIndex, offsetBy: -(end?.count ?? begin.count ) ) ]
    }
    
    /// Converts a string to camelcase
    func camelize() -> String {
        var nonLetterIndexes: [String.Index] = []
        
        for ( i, v ) in self.enumerated() {
            if ( !v.isLetter ) { nonLetterIndexes.append( self.index( startIndex, offsetBy: i ) ) }
        }
        
        var stringBuilder = ""
        if nonLetterIndexes.count > 0 {
            for i in 0..<nonLetterIndexes.count {
                if i == 0 && nonLetterIndexes[i] != startIndex {
                    stringBuilder += "\(self[ startIndex ..< nonLetterIndexes[i] ])".lowercased() + "\(nonLetterIndexes.count > 1 ? self[ index( after: nonLetterIndexes[i]) ..< nonLetterIndexes[i + 1] ] : self[ index( after: nonLetterIndexes[i] ) ..< endIndex])".lowercased().capitalized
                } else if i == nonLetterIndexes.count - 1 && nonLetterIndexes[i] != self.endIndex {
                    stringBuilder += "\(self[ index( after: nonLetterIndexes[i] ) ..< endIndex ])".lowercased().capitalized
                } else {
                    stringBuilder += "\(self[ index( after: nonLetterIndexes[i] ) ..< nonLetterIndexes[i + 1] ])".lowercased().capitalized
                }
            }
        } else {
            stringBuilder += "\(self[ startIndex ..< (firstIndex(where: { ($0.isUppercase) && ($0 != self[startIndex]) }) ?? endIndex) ])".lowercased() + "\(self[ (firstIndex(where: { ($0.isUppercase) && ($0 != self[startIndex]) }) ?? endIndex ) ..< endIndex])"
        }
        
        return stringBuilder
    }
    
    /// Removes excess whitespace, including new lines, carriage returns, tab space, etc.
    func collapseWhitespace() -> String {
        var stringBuilder = ""
        for (i,v) in self.enumerated() {
            if v.isWhitespace {
                if (i == self.count - 1) && (!v.isWhitespace) { stringBuilder += "\(v)" }
                else if (i == self.count - 1) { break }
                else if !self[self.index(self.startIndex, offsetBy: i+1)].isWhitespace { stringBuilder += "\(v)" }
            } else { stringBuilder += "\(v)" }
        }
        return String(stringBuilder.trim())
    }
    
    /// Ensures prefix exists and, if not, returns a prepended string
    func ensureLeft(_ prefix: String) -> String {
        if self[self.startIndex..<self.index(self.startIndex, offsetBy: prefix.count)].contains(prefix) { return "\(self)" }
        else { return "\(prefix)\(self)" }
    }
    
    /// Ensures suffix exists and, if not, returns an appended string
    func ensureRight(_ suffix: String) -> String {
        if self[self.index(self.endIndex, offsetBy: -suffix.count)..<self.endIndex].contains(suffix) { return "\(self)"}
        else { return "\(self)\(suffix)"}
    }
    
    /// Is this string Alphabetical
    func isAlpha() -> Bool {
        for (_, v) in self.enumerated() { if !v.isLetter { return false } }
        return true
    }
    
    /// Is this string AlphaNumeric
    func isAlphaNumeric() -> Bool {
        for (_, v) in self.enumerated() { if !v.isLetter && !v.isNumber { return false } }
        return true
    }
    
    /// Does this string only contain numbers and decimal point
    func isNumeric() -> Bool {
        for (_, v) in self.enumerated() { if (!v.isNumber) && (v != ".") { return false } }
        return true
    }
    
    /// Is this string not nil but also empty or contain only whitespace?
    func isEmpty() -> Bool {
        for (_, v) in self.enumerated() { if (!v.isWhitespace) && (v != " ") { return false } }
        return true
    }
    
    /// Remove whitespace from the left
    func trimLeft() -> SubSequence { return self[ (firstIndex( where: { !$0.isWhitespace } ) ?? startIndex)..<endIndex ] }
    
    /// Remove whitespace from the right
    func trimRight() -> SubSequence { return self[ startIndex...(lastIndex( where: { !$0.isWhitespace } ) ?? endIndex) ] }
    
    /// Remove whitepace from the left and right
    func trim() -> SubSequence { self.trimLeft().trimRight() }
    
    /// Remove the shell from a snail
    func slugify() -> String {
        var stringBuilder: String = ""
        
        for ( i, v ) in self.enumerated() {
            if i == 0 {
                if self[index(startIndex, offsetBy: i)].isLetter { stringBuilder += "\(v)" }
            } else {
                if self[index(startIndex, offsetBy: i)].isLetter { stringBuilder += "\(v)" }
                else {
                    if (self[index(startIndex, offsetBy: i + 1)].isLetter) && (i < self.count - 1) { stringBuilder += "-"}
                }
            }
        }
        return stringBuilder.lowercased()
    }
    
    /// Remove all punctuation
    func stripPunctuation() -> String {
        var stringBuilder: String = ""
        
        for ( i, v ) in self.enumerated() {
            if (v.isLetter) || (v.isWhitespace) { stringBuilder += "\(v)" }
        }
        
        return stringBuilder
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
