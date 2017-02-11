import Foundation

public extension String {
    public func base64Encoded() -> String? {
        let plainData = data(using: String.Encoding.utf8)
        let base64String = plainData?.base64EncodedString(options: Data.Base64EncodingOptions.endLineWithCarriageReturn)
        return base64String
    }
    
    public func base64Decoded() -> String? {
        guard let decodedData = Data(base64Encoded: self) else {
            return nil
        }
        let decodedString = NSString(data: decodedData as Data, encoding: String.Encoding.utf8.rawValue)
        return decodedString as? String
    }
    
    public func containsAnyCharacterOfSet(_ set: CharacterSet) -> Bool {
        for character in self.characters {
            for codeUnit in String(character).utf16 {
                if set.contains(UnicodeScalar(codeUnit)!) {
                    return true
                }
            }
        }
        
        return false
    }
    
    public func toDateFromJsonFormat() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let dateObj = dateFormatter.date(from: self)
        
        return dateObj
    }

    public func toDateFromSpanishFormat() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let dateObj = dateFormatter.date(from: self)
        
        return dateObj
    }

    public var isNotEmpty: Bool {
        return !self.isEmpty
    }
    
    public func trim() -> String {
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    public var length: Int {
        return characters.count
    }
    
    public func index(from: Int) -> Index {
        return self.index(startIndex, offsetBy: from)
    }
    
    public func substring(from: Int) -> String {
        let fromIndex = index(from: from)
        return substring(from: fromIndex)
    }
    
    public func substring(to: Int) -> String {
        let toIndex = index(from: to)
        return substring(to: toIndex)
    }
    
    public func substring(with range: Range<Int>) -> String {
        let startIndex = index(from: range.lowerBound)
        let endIndex = index(from: range.upperBound)
        return substring(with: startIndex..<endIndex)
    }
    
    public func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
    public func match(withPattern pattern: String) -> Bool {
        guard let regex = try? NSRegularExpression(pattern: pattern, options: []) else {
            return false
        }
        let range = NSRange(location: 0, length: characters.count)
        return regex.firstMatch(in: self, options: [], range: range) != nil
    }
    
    public func match(forPattern pattern: String, index: Int) -> String? {
        let list = matches(forPattern: pattern)
        if let el = list.element(atIndex: index) {
            return el
        }
        return nil
    }
    
    public func matches(forPattern pattern: String) -> [String] {
        guard let regex = try? NSRegularExpression(pattern: pattern, options: []) else {
            return []
        }
        
        let nsString = self as NSString
        let results = regex.matches(in: self, options: [], range: NSRange(location: 0, length: nsString.length))
        if let result = results.first {
            return (0..<result.numberOfRanges).map {
                result.rangeAt($0).location != NSNotFound ? nsString.substring(with: result.rangeAt($0)) : ""
            }
        } else {
            return []
        }
    }
    
    public func isValidLinkedinProfileUrl() -> Bool {
        return match(withPattern: "^http[s]?://(linkedin.com|.+\\.linkedin.com)/in/(.*)$")
    }
    
    public var linkedInUsername: String? {
        return match(forPattern: "^http[s]?://(linkedin.com|.+\\.linkedin.com)/in/(.*)$", index: 2)
    }
    
    public var URLEscapedString: String {
        return addingPercentEncoding(withAllowedCharacters: CharacterSet.urlHostAllowed)!
    }
}

public extension Sequence where Iterator.Element == String {
    /**
     Find any occurences of given string in any part of every item. This func is CASE and ACCENT INSENSITIVE
     */
    public func match(with occurrence: String) -> Bool {
        return contains(where: { el in
            return occurrence.range(of: el, options: [.diacriticInsensitive, .caseInsensitive], range: nil, locale: nil) != nil
        })
    }
}
