
import Foundation
import UIKit
import AVFoundation
import Photos
import CoreData

//MARK: - UIView
enum Side {
	case all
	case top
	case bottom
}
extension UIView {
	func setRoundedCorners() {
		self.cornerRadius = 10
	}
	func setCurvedCorners() {
		self.cornerRadius = self.bounds.height/2
	}
	func setTopLeftRoundedCorner() {
		let maskLayer = CAShapeLayer()
		maskLayer.path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: [.topLeft], cornerRadii: CGSize(width: 120, height: 120)).cgPath
		self.layer.mask = maskLayer
	}
	func setRoundedCorners(Side : Side) {
		let maskLayer = CAShapeLayer()
		if Side == .all {
			maskLayer.path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: [.topLeft , .topRight , .bottomLeft , .bottomRight], cornerRadii: CGSize(width: 10, height: 10)).cgPath
		} else {
			maskLayer.path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: Side == .top ? [.topLeft , .topRight] : [.bottomLeft,.bottomRight], cornerRadii: CGSize(width: 25, height: 25)).cgPath
		}
		self.layer.mask = maskLayer
	}
    
    func setBorderAndCornerRadius(Side : Side) {
        let maskLayer = CAShapeLayer()
        if Side == .all {
            maskLayer.path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: [.topLeft , .topRight , .bottomLeft , .bottomRight], cornerRadii: CGSize(width: 10, height: 10)).cgPath
        } else {
            maskLayer.path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: Side == .top ? [.topLeft , .topRight] : [.bottomLeft,.bottomRight], cornerRadii: CGSize(width: 10, height: 10)).cgPath
        }
        self.layer.mask = maskLayer
    }
	class func instanceFromNib(nibName: String) -> UIView {
		return UINib(nibName: nibName, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
	}
}

//MARK: - UIViewController

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
	
	func showAlert(title: String , message: String) {
		let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
		let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
		alertController.addAction(OKAction)
		self.present(alertController, animated: true, completion: nil)
	}
}


extension UIView {
    class func fromNib<T: UIView>() -> T {
        return Bundle(for: T.self).loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
}

extension UIButton {
	func addSelectionLine() {
		let lineView = UIView(frame: CGRect(x: 0, y: self.frame.size.height-4, width: self.frame.size.width, height: 4))
		lineView.tag = 100;
		lineView.backgroundColor = #colorLiteral(red: 0.9450980392, green: 0.4, blue: 0.137254902, alpha: 1)
		self.isSelected = true;
		self.addSubview(lineView)
	}
	func removeSelectionLine() {
		guard let lineView = self.viewWithTag(100) else { return }
		lineView.removeFromSuperview()
	}
}

extension UIButton {
    func underline() {
        guard let text = self.titleLabel?.text else { return }
        let attributedString = NSMutableAttributedString(string: text)
        //NSAttributedStringKey.foregroundColor : UIColor.blue
        attributedString.addAttribute(NSAttributedString.Key.underlineColor, value: self.titleColor(for: .normal)!, range: NSRange(location: 0, length: text.count))
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: self.titleColor(for: .normal)!, range: NSRange(location: 0, length: text.count))
        attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: text.count))
        self.setAttributedTitle(attributedString, for: .normal)
    }
}

extension UILabel {
    func underlineMyText() {
        if let textString = self.text {
            let attributedString = NSMutableAttributedString(string: textString)
            attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: attributedString.length - 1))
            attributedText = attributedString
        }
    }
}



extension Collection {
    // Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}


extension String {
    func isEqualToString(find: String) -> Bool {
        return String(format: self) == find
    }
    
    
    public func isImageType() -> Bool {
        // image formats which you want to check
        let imageFormats = ["jpg", "png", "gif"]
        
        if URL(string: self) != nil  {
            
            let extensi = (self as NSString).pathExtension
            
            return imageFormats.contains(extensi)
        }
        return false
    }
    
    
    func numberOfOccurrencesOf(string: String) -> Int {
        return self.components(separatedBy:string).count - 1
    }
}

extension String {
    func containsIgnoreCase(_ string: String) -> Bool {
        return self.lowercased().contains(string.lowercased())
    }
}

extension String {
    func decode() -> String {
        let data = self.data(using: .utf8)!
        return String(data: data, encoding: .nonLossyASCII) ?? self
    }

    func encode() -> String {
        let data = self.data(using: .nonLossyASCII, allowLossyConversion: true)!
        return String(data: data, encoding: .utf8)!
    }
}

extension String {
    func evaluate(with condition: String) -> Bool {
        guard let range = range(of: condition,
                                options: .regularExpression,
                                range: nil,
                                locale: nil) else {
                                    return false
        }
        
        return range.lowerBound == startIndex
            && range.upperBound == endIndex
    }
    
    var isBlank: Bool {             //check Blank textfield
        get {
            let trimmed = trimmingCharacters(in: CharacterSet.whitespaces)
            return trimmed.isEmpty
        }
    }
    
    var toSpaceString:String {          //to space string
        return "   " + self + "   "
    }
    
    func toPhoneNumberFormat() -> String {          //Phone number format
        return self.replacingOccurrences(of: "(\\d{3})(\\d{3})(\\d+)", with: "($1) $2-$3", options: .regularExpression, range: nil)
    }
    
    func toGetFirstCharacter() -> String { //get first characters of string
        var stringCharacters = ""
        self.enumerateSubstrings(in: self.startIndex..<self.endIndex, options: .byWords) { (substring, _, _, _) in
            if let substring = substring { stringCharacters += substring.prefix(1) }
        }
        return stringCharacters
    }
    
    func toFindFirstCharacter() -> String { //find first characters of string
        let first = self[self.startIndex ..< self.index(startIndex, offsetBy: 1)]
        return String(first)
    }
    
    func capitalizedFirst() -> String {
        let first = self[self.startIndex ..< self.index(startIndex, offsetBy: 1)]
        let rest = self[self.index(startIndex, offsetBy: 1) ..< self.endIndex]
        return first.uppercased() + rest.lowercased()
    }

    func capitalizedFirst(with: Locale?) -> String {
        let first = self[self.startIndex ..< self.index(startIndex, offsetBy: 1)]
        let rest = self[self.index(startIndex, offsetBy: 1) ..< self.endIndex]
        return first.uppercased(with: with) + rest.lowercased(with: with)
    }
    
    //swap the characters
    func swapAt(_ index1: Int, _ index2: Int) -> String {
        var characters = Array(self)
        characters.swapAt(index1, index2)
        return String(characters)
    }
    
    var isValidURL: Bool {
        let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        if let match = detector.firstMatch(in: self, options: [], range: NSRange(location: 0, length: self.utf16.count)) {
            // it is a link, if the match covers the whole string
            return match.range.length == self.utf16.count
        } else {
            return false
        }
    }
    
    var isValidVideoUrl: Bool {
        let urlRegEx = "((?:http|https)://)?(?:www\\.)?[\\w\\d\\-_]+\\.\\w{2,3}(\\.\\w{2})?(/(?<=/)(?:[\\w\\d\\-./_]+)?)?"
        return NSPredicate(format: "SELF MATCHES %@", urlRegEx).evaluate(with: self)
    }
    
    
}



func isPhoneNumberValid(text: String) -> Bool {
    let regexp = "^[0-9]{10}$"
    return text.evaluate(with: regexp)
}

func isZipCodeValid(text: String) -> Bool {
    let regexp = "^[0-9]{5}$"
    return text.evaluate(with: regexp)
}

func isStateValid(text: String) -> Bool {
    let regexp = "^[A-Z]{2}$"
    return text.evaluate(with: regexp)
}

func isCVCValid(text: String) -> Bool {
    let regexp = "^[0-9]{3,4}$"
    return text.evaluate(with: regexp)
}

func isEmailValid(text: String) -> Bool {
    let regexp = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
    return text.evaluate(with: regexp)
}
func isPasswordContainsSpecialCharacter(text:String) -> Bool {
    let regexp = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d$@$!%*#?&]{6,}$"
    return text.evaluate(with: regexp)
}
func isPasswordValid(text: String) -> Bool {
    if !isPasswordContainsSpecialCharacter(text: text) {
        return false
    }
    return true
}

func isAlphaNumeric(text: String) -> Bool {
    let regexp = "^[a-zA-Z0-9_]*$" //"[^a-zA-Z0-9]"
    return text.evaluate(with: regexp)
}


//Minimum 8 characters at least 1 Uppercase Alphabet, 1 Lowercase Alphabet, 1 Number and 1 Special Character
func isPasswordAllPartsMustNeedValidation_Fns(text: String) -> Bool {
    let passwordRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[d$@$!%*?&#])[A-Za-z\\dd$@$!%*?&#]{8,}"
    return text.evaluate(with: passwordRegex)
}

//Checking if a string contains a number
func isDoStringContainsNumber( _string : String) -> Bool{
    let numberRegEx  = ".*[0-9]+.*"
    let testCase = NSPredicate(format:"SELF MATCHES %@", numberRegEx)
    let containsNumber = testCase.evaluate(with: _string)
    
    return containsNumber
}

//Checking if a string contains a UpperCase letter
func isDoStringContainsUpperCase( _string : String) -> Bool{
    //let passwordRegex = "^(?=.*[A-Z]+)"
    let upperCaseRegex = "(?s)[^A-Z]*[A-Z].*"
    return _string.evaluate(with: upperCaseRegex)
}

//Checking if a string contains a LowerCase letter
func isDoStringContainsLowerCase( _string : String) -> Bool{
    //let passwordRegex = "^(?=.*[A-Z]+)"
    let upperCaseRegex = "(?s)[^a-z]*[a-z].*"
    return _string.evaluate(with: upperCaseRegex)
}

//Checking if a string contains a Special Characters
func isContainsSpecialCharacters( _string: String) -> Bool {
    do {
        let regex = try NSRegularExpression(pattern: "[^a-z0-9 ]", options: .caseInsensitive)
        if let _ = regex.firstMatch(in: _string, options: [], range: NSMakeRange(0, _string.count)) {
            return true
        } else {
            return false
        }
    } catch {
        debugPrint(error.localizedDescription)
        return true
    }
}

//Checking if a string contains a Illegal Characters
func isCheckForIllegalCharacters( _string: String) -> Bool {
    let invalidCharacters = CharacterSet(charactersIn: "\\/:*?\"<>|")
    .union(.newlines)
    .union(.illegalCharacters)
    .union(.controlCharacters)

    if _string.rangeOfCharacter(from: invalidCharacters) != nil {
        print ("Illegal characters detected in file name")
        //Raise an alert here
        return true
    } else {
        return false
    }
}


extension String {
    func countEmojiCharacter() -> Int {

        func isEmoji(s:NSString) -> Bool {
            
            let high:Int = Int(s.character(at: 0))
            if 0xD800 <= high && high <= 0xDBFF {
                let low:Int = Int(s.character(at: 1))
                let codepoint: Int = ((high - 0xD800) * 0x400) + (low - 0xDC00) + 0x10000
                return (0x1D000 <= codepoint && codepoint <= 0x1F9FF)
            }
            else {
                return (0x2100 <= high && high <= 0x27BF)
            }
        }
        
        let nsString = self as NSString
        var length = 0
        
        nsString.enumerateSubstrings(in: NSMakeRange(0, nsString.length), options: NSString.EnumerationOptions.byComposedCharacterSequences) { (subString, substringRange, enclosingRange, stop) -> Void in
            
            if isEmoji(s: subString! as NSString) {
                length = length + 1
            }
        }

        return length
    }
}


//
//MARK: - DATE
//
extension Date {
    var isToday: Bool {
        Calendar.current.isDateInToday(self)
    }//
    func isTodayOrNot(date: Date) -> Bool {
        let today = Calendar.current.isDateInToday(date)
        //print("today==>>\(today)")
        return today
    }
    func dayDifference(from interval: TimeInterval) -> String {
        let calendar = Calendar.current
        let date = Date(timeIntervalSince1970: interval)
        if calendar.isDateInYesterday(date) { return "Yesterday" }
        else if calendar.isDateInToday(date) { return "Today" }
        else if calendar.isDateInTomorrow(date) { return "Tomorrow" }
        else {
            let startOfNow = calendar.startOfDay(for: Date())
            let startOfTimeStamp = calendar.startOfDay(for: date)
            let components = calendar.dateComponents([.day], from: startOfNow, to: startOfTimeStamp)
            let day = components.day!
            if day < 1 { return "\(-day) days ago" }
            else { return "In \(day) days" }
        }
    }
    
    //Add calendar components
    func add(years: Int = 0, months: Int = 0, days: Int = 0, hours: Int = 0, minutes: Int = 0, seconds: Int = 0) -> Date? {
        let components = DateComponents(year: years, month: months, day: days, hour: hours, minute: minutes, second: seconds)
        return Calendar.current.date(byAdding: components, to: self)
    }
    
    // Subtract calendar components
    func subtract(years: Int = 0, months: Int = 0, days: Int = 0, hours: Int = 0, minutes: Int = 0, seconds: Int = 0) -> Date? {
        return add(years: -years, months: -months, days: -days, hours: -hours, minutes: -minutes, seconds: -seconds)
    }
    
    // Convert local time to UTC (or GMT)
    func toGlobalUTCTime() -> Date {
        let timezone = TimeZone(identifier: Constants.DateFormatterConstants.CST)
        let seconds = -TimeInterval(timezone!.secondsFromGMT(for: self))
        return Date(timeInterval: seconds, since: self)
    }
    
    // Convert UTC (or GMT) to local time
    func toLocalTime() -> Date {
        let timezone = TimeZone(identifier: Constants.DateFormatterConstants.CST)
        let seconds = TimeInterval(timezone!.secondsFromGMT(for: self))
        return Date(timeInterval: seconds, since: self)
    }
    
    //Calendar local time zone
    func calendarLocalTimeZone() -> Date {
        let timezone = NSTimeZone.local
        let seconds = TimeInterval(timezone.secondsFromGMT(for: self))
        return Date(timeInterval: seconds, since: self)
    }
    
    func formatTitleDatewithMonth () -> String {         //Date month - 10 Oct format
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = Constants.DateFormatterConstants.DDMMM
        dateFormatterGet.timeZone = TimeZone(abbreviation: Constants.DateFormatterConstants.UTC)
        return dateFormatterGet.string(from: self)
    }
    
    func formatDateMonthYear () -> String{        //DateYearMonth - wednesday, October 16th, 2018
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "EEEE, MMMM '\(getDayOnly())', YYYY"
        dateFormatterGet.timeZone = TimeZone(abbreviation: Constants.DateFormatterConstants.UTC)
        return dateFormatterGet.string(from: self)
    }
    
    func formatMonthYearOnly () -> String{        //DateYearMonth - October 16th, 2018
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "MMMM '\(getDayOnly())', YYYY"
        dateFormatterGet.timeZone = TimeZone(abbreviation: Constants.DateFormatterConstants.UTC)
        return dateFormatterGet.string(from: self)
    }
    
    func formatDateMonthYearWithOutDay () -> String{        //DateYearMonth - wednesday, October 16, 2018
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = Constants.DateFormatterConstants.EEEMMMMYYYY
        dateFormatterGet.timeZone = TimeZone(abbreviation: Constants.DateFormatterConstants.UTC)
        return dateFormatterGet.string(from: self)
    }
    
    func formatMonthYearOnlyWithOutTH () -> String{        //DateYearMonth - October 16, 2018
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = Constants.DateFormatterConstants.MMMDYYYY
        dateFormatterGet.timeZone = TimeZone(abbreviation: Constants.DateFormatterConstants.UTC)
        return dateFormatterGet.string(from: self)
    }
    
    func formatDateAMPM() -> String {         //Date format - 12 AM / 12 PM
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale
        dateFormatterGet.dateFormat = Constants.DateFormatterConstants.AMPM
        dateFormatterGet.timeZone = TimeZone(abbreviation: Constants.DateFormatterConstants.UTC)
        return dateFormatterGet.string(from: self)
    }
    
    func formatDateOnly() -> String {     //  Date format - 2018-11-10
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = Constants.DateFormatterConstants.YYYYMMDD
        dateFormatterGet.timeZone = TimeZone(abbreviation: Constants.DateFormatterConstants.UTC)
        return dateFormatterGet.string(from: self)
    }
    
    func formatDateYearWithAMPMTime() -> String {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale
        dateFormatterGet.timeZone = TimeZone(abbreviation: Constants.DateFormatterConstants.UTC)
        dateFormatterGet.dateFormat = Constants.DateFormatterConstants.MMMDD_AMPM
        return dateFormatterGet.string(from: self)
    }
    
    func getDayOnly() -> String {                   // date with 'th'
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.timeZone = TimeZone(abbreviation: Constants.DateFormatterConstants.UTC)
        dateFormatterGet.dateFormat = "d"
        let StrDate = dateFormatterGet.string(from: self)
        let numformatter = NumberFormatter()
        numformatter.numberStyle = .ordinal
        let first = numformatter.string(from: Int(StrDate)! as NSNumber)
        return first!
    }
    
    func ToLocalStringWithFormat(dateFormat: String) -> String {
        //change to a readable time format and change to local time zone
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        //dateFormatter.timeZone = NSTimeZone.local
        dateFormatter.timeZone = TimeZone(abbreviation: Constants.DateFormatterConstants.UTC)
        let timeStamp = dateFormatter.string(from: self)
        
        return timeStamp
    }
}

//MARK: - Date and Time
extension String {
    func toDateFormatted(with string: String)-> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "d/M/yy"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = string
        return formatter.date(from: self)
    }
    
    func getDatefromStringAndFormatter(string: String, withDateFormat:String) -> Date? {
        let isoDate = dataValidation(data: string as AnyObject)
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = withDateFormat //"yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        /*guard let date = dateFormatter.date(from:isoDate) else {
            return Date()
        }*/
        return dateFormatter.date(from:isoDate) //date
    }
    
}

//MARK: ISO DATE formate Start,,,,,
extension ISO8601DateFormatter {
    convenience init(_ formatOptions: Options) {
        self.init()
        self.formatOptions = formatOptions
    }
}
extension Formatter {
    static let iso8601withFractionalSeconds = ISO8601DateFormatter([.withInternetDateTime, .withFractionalSeconds])
}
extension Date {
    var iso8601withFractionalSeconds: String { return Formatter.iso8601withFractionalSeconds.string(from: self) }
}
extension String {
    var iso8601withFractionalSeconds: Date? { return Formatter.iso8601withFractionalSeconds.date(from: self) }
}
func getCurrentDate_viaISO() -> String {
    let dateString = Date().iso8601withFractionalSeconds   //  "2019-02-06T00:35:01.746Z"
    return dateString
    
    //Date().description(with: .current)  //  Tuesday, February 5, 2019 at 10:35:01 PM Brasilia Summer Time"
    /*if let date = dateString.iso8601withFractionalSeconds {
        //date.description(with: .current) // "Tuesday, February 5, 2019 at 10:35:01 PM Brasilia Summer Time"
        print(date.iso8601withFractionalSeconds)          //  "2019-02-06T00:35:01.746Z\n"
    }*/
}
//MARK: ISO DATE formate End,,,,,

func getDatefromString(string: String) -> Date {
    if string != "" {
        let isoDate = string

        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date = dateFormatter.date(from:isoDate)!
        return date
    } else {
        return Date()
    }
    
}

func getUTCDateString_FromUnixTimeStamp(UnixTime: Double) -> String {
    let dateFromUnix = Date(timeIntervalSince1970: UnixTime)
    let dateFormatter = DateFormatter()
    dateFormatter.timeStyle = DateFormatter.Style.medium //Set time style
    dateFormatter.dateStyle = DateFormatter.Style.medium //Set date style
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    dateFormatter.timeZone = .current
    let localDate = dateFormatter.string(from: dateFromUnix)
    return localDate
}

func getUnixTimeStamp_FromUTCDateString(dateString: String) -> Double {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    dateFormatter.timeZone = TimeZone(abbreviation: Constants.DateFormatterConstants.UTC)
    //dateFormatter.timeZone = .current
    let date = dateFormatter.date(from: dateString)!
    
    let unixTime = date.timeIntervalSince1970
    
    return unixTime
}

/*extension String {
    var getUnixTimeStamp_FromUTCDateString:TimeInterval {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFormatter.timeZone = TimeZone(abbreviation: Constants.DateFormatterConstants.UTC)
        let utcDate = dateFormatter.date(from: self)
        let unixTime = utcDate?.timeIntervalSince1970
        return unixTime!
    }
}*/

func setTimestamp(epochTime: String) -> String {
    let currentDate = Date()
    let epochDate = Date(timeIntervalSince1970: TimeInterval(epochTime)!)

    let calendar = Calendar.current

    let currentDay = calendar.component(.day, from: currentDate)
    let currentHour = calendar.component(.hour, from: currentDate)
    let currentMinutes = calendar.component(.minute, from: currentDate)
    let currentSeconds = calendar.component(.second, from: currentDate)

    let epochDay = calendar.component(.day, from: epochDate)
    let epochMonth = calendar.component(.month, from: epochDate)
    let epochYear = calendar.component(.year, from: epochDate)
    let epochHour = calendar.component(.hour, from: epochDate)
    let epochMinutes = calendar.component(.minute, from: epochDate)
    let epochSeconds = calendar.component(.second, from: epochDate)

    if (currentDay - epochDay < 30) {
        if (currentDay == epochDay) {
            if (currentHour - epochHour == 0) {
                if (currentMinutes - epochMinutes == 0) {
                    if (currentSeconds - epochSeconds <= 1) {
                        return String(currentSeconds - epochSeconds) + " second ago"
                    } else {
                        return String(currentSeconds - epochSeconds) + " seconds ago"
                    }

                } else if (currentMinutes - epochMinutes <= 1) {
                    return String(currentMinutes - epochMinutes) + " minute ago"
                } else {
                    return String(currentMinutes - epochMinutes) + " minutes ago"
                }
            } else if (currentHour - epochHour <= 1) {
                return String(currentHour - epochHour) + " hour ago"
            } else {
                return String(currentHour - epochHour) + " hours ago"
            }
        } else if (currentDay - epochDay <= 1) {
            return String(currentDay - epochDay) + " day ago"
        } else {
            return String(currentDay - epochDay) + " days ago"
        }
    } else {
        return String(epochDay) + " " + getMonthNameFromInt(month: epochMonth) + " " + String(epochYear)
    }
}
func getMonthNameFromInt(month: Int) -> String {
    switch month {
    case 1:
        return "Jan"
    case 2:
        return "Feb"
    case 3:
        return "Mar"
    case 4:
        return "Apr"
    case 5:
        return "May"
    case 6:
        return "Jun"
    case 7:
        return "Jul"
    case 8:
        return "Aug"
    case 9:
        return "Sept"
    case 10:
        return "Oct"
    case 11:
        return "Nov"
    case 12:
        return "Dec"
    default:
        return ""
    }
}

extension Date {
    
    func offset(from: Date) -> (Calendar.Component, Int)? {
        let descendingOrderedComponents = [Calendar.Component.year, .month, .day, .hour, .minute]
        let dateComponents = Calendar.current.dateComponents(Set(descendingOrderedComponents), from: from, to: self)
        let arrayOfTuples = descendingOrderedComponents.map { ($0, dateComponents.value(for: $0)) }
        
        for (component, value) in arrayOfTuples {
            if let value = value, value > 0 {
                return (component, value)
            }
        }
        
        return nil
    }

}

    func formatAMPMtoHoursMins(timeValue:String) -> String {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale
        dateFormatterGet.dateFormat = "h a"
        let formattedDate:Date = dateFormatterGet.date(from: timeValue)!
        dateFormatterGet.dateFormat = Constants.DateFormatterConstants.HHMMSS
        return dateFormatterGet.string(from: formattedDate)
    }
    
    func addDateTimeFromString(timeValue:String, dateValue:String) -> Date {        //add date with time
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = Constants.DateFormatterConstants.GenericDateTimeFormat
        dateFormatterGet.timeZone = TimeZone.current
        let formattedDate:Date = dateFormatterGet.date(from: dateValue + " " + timeValue)!
        
        return formattedDate.toLocalTime()
    }
    
    func UTCToLocalDate(UTC dateString:String, givenDateStrFormate: String, dateFormatToBeConverted:String) -> String { //String to date convert
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = givenDateStrFormate //"yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFormatter.timeZone = TimeZone(abbreviation: Constants.DateFormatterConstants.UTC)
        let date = dateFormatter.date(from: dateString)!
        dateFormatter.dateFormat = dateFormatToBeConverted
        dateFormatter.timeZone = TimeZone.current
        return dateFormatter.string(from: date)
    }
    
    func UTCToLocalTimeOnly(UTC dateString:String, dateFormatToBeConverted:String) -> String { //String to date convert
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFormatter.timeZone = TimeZone(abbreviation: Constants.DateFormatterConstants.UTC)
        let date = dateFormatter.date(from: dateString)!
        dateFormatter.dateFormat = dateFormatToBeConverted
        dateFormatter.timeZone = TimeZone.current
        return dateFormatter.string(from: date)
    }
    
    func toGetCurentDateAndTimeInUTC(givenDateStrFormate: String, dateFormatToBeConverted:String) -> String {
        let d_CurrentDate = Date()
        let dateFormatter = DateFormatter()
        //dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = givenDateStrFormate
        dateFormatter.timeZone = TimeZone(abbreviation: Constants.DateFormatterConstants.UTC)
        let s_CurrentDate = dateFormatter.string(from: d_CurrentDate)
        
        let date = dateFormatter.date(from: s_CurrentDate)!
        dateFormatter.dateFormat = dateFormatToBeConverted
        dateFormatter.timeZone = TimeZone(abbreviation: Constants.DateFormatterConstants.UTC)
        return dateFormatter.string(from: date)
    }
    //extension NSDate { extension Date {
    func stringToDate(dateString:String, withDateFormat:String) -> Date {        //String to date convert
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = withDateFormat
        dateFormatter.timeZone = TimeZone(abbreviation: Constants.DateFormatterConstants.UTC)
        return dateFormatter.date(from: dateString)!
    }
    
    func dateToString(dateValue:Date, withDateFormat:String) -> String {        // date to string convert
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = withDateFormat
    //    dateFormatter.timeZone = TimeZone(abbreviation: Constants.DateFormatterConstants.UTC)
        return dateFormatter.string(from: dateValue)
    }
    func getTimeDurationHoursWithAMPM(givenDate:Date, minutesPassed:Int) -> String {           //to get between hours like 9 AM - 10 AM
        var convertedTime = ""
        _ = givenDate.add(minutes:minutesPassed)
        convertedTime = givenDate.formatDateAMPM() //+ " - " + (passedDate?.formatDateAMPM())!
        return convertedTime
    }

    func getTimeDurationHoursWithAMPMForTechnician(givenDate:Date, minutesPassed:Int) -> String { //to get between hours like 9 AM - 10 AM
        var convertedTime = ""
        let passedDate = givenDate.add(minutes:minutesPassed)
        convertedTime = givenDate.formatDateAMPM() + " - " + (passedDate?.formatDateAMPM())!
        return convertedTime
    }
    

extension Date {
    func toMillis() -> Int64! {
        return Int64(self.timeIntervalSince1970 * 1000)
    }
    
    func timeAgoSinceDate() -> String {
        
        // From Time
        let fromDate = self
        
        // To Time
        let toDate = Date()
        
        // Estimation
        // Year
        if let interval = Calendar.current.dateComponents([.year], from: fromDate, to: toDate).year, interval > 0  {
            
            return interval == 1 ? "\(interval)" + " " + "year ago" : "\(interval)" + " " + "years ago"
        }
        
        // Month
        if let interval = Calendar.current.dateComponents([.month], from: fromDate, to: toDate).month, interval > 0  {
            
            return interval == 1 ? "\(interval)" + " " + "month ago" : "\(interval)" + " " + "months ago"
        }
        
        // Day
        if let interval = Calendar.current.dateComponents([.day], from: fromDate, to: toDate).day, interval > 0  {
            
            return interval == 1 ? "\(interval)" + " " + "day ago" : "\(interval)" + " " + "days ago"
        }
        
        // Hours
        if let interval = Calendar.current.dateComponents([.hour], from: fromDate, to: toDate).hour, interval > 0 {
            
            return interval == 1 ? "\(interval)" + " " + "hour ago" : "\(interval)" + " " + "hours ago"
        }
        
        // Minute
        if let interval = Calendar.current.dateComponents([.minute], from: fromDate, to: toDate).minute, interval > 0 {
            
            return interval == 1 ? "\(interval)" + " " + "minute ago" : "\(interval)" + " " + "minutes ago"
        }
        
        return "a moment ago"
    }
    
}

func getCurrencySymbolUsingCountryCode (countryCode:String) -> String? {
    let countryCodeCA = countryCode //as! String
    let localeIdCA = NSLocale.localeIdentifier(fromComponents: [NSLocale.Key.countryCode.rawValue : countryCodeCA])
    let localeCA = NSLocale(localeIdentifier: localeIdCA)
    let currencySymbolCA = localeCA.object(forKey: NSLocale.Key.currencySymbol)
    //let currencyCodeCA = localeCA.object(forKey: NSLocale.Key.currencyCode)
    //print("currencySymbolCA===>>\(currencySymbolCA!)")
    
    if let str = currencySymbolCA as? String {
        return str
    }
    return ""
}


//
//MARK: - AVFoundation
//
extension AVCaptureDevice {
    enum AuthorizationStatus {
        case justDenied
        case alreadyDenied
        case restricted
        case justAuthorized
        case alreadyAuthorized
    }
    
    class func authorizeVideo(completion: ((AuthorizationStatus) -> Void)?) {
        AVCaptureDevice.authorize(mediaType: AVMediaType.video, completion: completion)
    }
    
    class func authorizeAudio(completion: ((AuthorizationStatus) -> Void)?) {
        AVCaptureDevice.authorize(mediaType: AVMediaType.audio, completion: completion)
    }
    
    private class func authorize(mediaType: AVMediaType, completion: ((AuthorizationStatus) -> Void)?) {
        let status = AVCaptureDevice.authorizationStatus(for: mediaType)
        switch status {
        case .authorized:
            completion?(.alreadyAuthorized)
        case .denied:
            authorizationImagePickerAlert(title: Constants.ValidationMsgs.allowCameraAccess, message: Constants.ValidationMsgs.permissionAccessAllowForCamera)
            completion?(.alreadyDenied)
        case .restricted:
            completion?(.restricted)
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: mediaType, completionHandler: { (granted) in
                DispatchQueue.main.async {
                    if(granted) {
                        completion?(.justAuthorized)
                    }
                    else {
                        completion?(.justDenied)
                    }
                }
            })
        }
    }
}

//
//MARK: - PHPhotoLibrary
//
extension PHPhotoLibrary {
    enum AuthorizationStatus {
        case justDenied
        case alreadyDenied
        case restricted
        case justAuthorized
        case alreadyAuthorized
    }
    
    class func authorizePhotoLibrary(completion: ((AuthorizationStatus) -> Void)?) {
        let authorizeStatus = PHPhotoLibrary.authorizationStatus()
        switch authorizeStatus{
        case .denied:
            authorizationImagePickerAlert(title: Constants.ValidationMsgs.allowPhotoAccess, message: Constants.ValidationMsgs.permissionAccessAllowForPhoto)
            completion?(.alreadyDenied)
            break
        case .authorized:
            completion?(.alreadyAuthorized)
            break
        case .restricted:
            completion?(.restricted)
            break
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({ (status:PHAuthorizationStatus) in
                switch status{
                case .authorized:
                    completion?(.justAuthorized)
                case .denied:
                    completion?(.justDenied)
                    break
                default:
                    break
                }
            })
            break
        default:
            break
        }
    }
}


//
//MARK:- Bool and Int
//
extension Bool {        // Bool to Int
    var intValue: Int {
        return self ? 1 : 0
    }
}

extension Int {             // Int to Bool
    var boolValue: Bool {
        return self != 0
    }
    func getMinutes() -> Int{
        let minutes = (self * 60)
        return minutes
    }
}

//
// MARK: - Float
//
extension Float {       //23Saro
    func getDollarAmount() -> String {          //to get dollar amount
        
        var dollarAmt = "$" + String(format: "%.2f", self as CVarArg)
        
        if dollarAmt.contains("-") {        //update the minus (-) value added
            dollarAmt = dollarAmt.swapAt(0, 1)
        }
        
        return dollarAmt
    }
}


extension NSDate {
    
    func isGreaterThanDate(dateToCompare: NSDate) -> Bool {
        //Declare Variables
        var isGreater = false
        
        //Compare Values
        if self.compare(dateToCompare as Date) == ComparisonResult.orderedDescending {
            isGreater = true
        }
        
        //Return Result
        return isGreater
    }
    
    func isLessThanDate(dateToCompare: NSDate) -> Bool {
        //Declare Variables
        var isLess = false
        
        //Compare Values
        if self.compare(dateToCompare as Date) == ComparisonResult.orderedAscending {
            isLess = true
        }
        
        //Return Result
        return isLess
    }
    
    func equalToDate(dateToCompare: NSDate) -> Bool {
        //Declare Variables
        var isEqualTo = false
        
        //Compare Values
        if self.compare(dateToCompare as Date) == ComparisonResult.orderedSame {
            isEqualTo = true
        }
        
        //Return Result
        return isEqualTo
    }
    
    func addDays(daysToAdd: Int) -> NSDate {
        let secondsInDays: TimeInterval = Double(daysToAdd) * 60 * 60 * 24
        let dateWithDaysAdded: NSDate = self.addingTimeInterval(secondsInDays)
        
        //Return Result
        return dateWithDaysAdded
    }
    
    func addHours(hoursToAdd: Int) -> NSDate {
        let secondsInHours: TimeInterval = Double(hoursToAdd) * 60 * 60
        let dateWithHoursAdded: NSDate = self.addingTimeInterval(secondsInHours)
        
        //Return Result
        return dateWithHoursAdded
    }
}

extension UILabel {
    /*
     @IBOutlet weak var label: LabelButton!
     self.label.onClick = {
        //TODO
     }
     */
    @IBDesignable class LabelButton: UILabel {
        var onClick: () -> Void = {}
        override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
            onClick()
        }
    }
}

extension UILabel {
    func retrieveTextHeight () -> CGFloat {
        let attributedText = NSAttributedString(string: self.text!, attributes: [NSAttributedString.Key.font:self.font])
        
        let rect = attributedText.boundingRect(with: CGSize(width: self.frame.size.width, height: CGFloat.greatestFiniteMagnitude), options: .usesLineFragmentOrigin, context: nil)
        
        return ceil(rect.size.height)
    }
    
    func retrieveTextWidth() -> CGRect {
        let attributedText = NSAttributedString(string: self.text!, attributes: [NSAttributedString.Key.font:self.font])
        
        let rect = attributedText.boundingRect(with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude), options: .usesLineFragmentOrigin, context: nil)
        
        return rect//ceil(rect.size.width)
    }
    
    func maxNumberOfLines(width:CGFloat?) -> Int {
        let maxSize = CGSize(width: width! , height: CGFloat(MAXFLOAT)) //frame.size.width
        let text = (self.text ?? "") as NSString
        let textHeight = text.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil).height
        let lineHeight = font.lineHeight
        return Int(ceil(textHeight / lineHeight))
    }
    
    func heightForParicularView(text:String, font:UIFont, width:CGFloat) -> CGFloat {
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        
        label.sizeToFit()
        return label.frame.height
    }
}



extension UITableView {
    
    func scrollToTop() {
        updateMainQueue {
            let indexPath = IndexPath(row: 0, section: 0)
            self.scrollToRow(at: indexPath, at: .top, animated: false)
        }
    }
    
    func scrollToBottom(){
        updateMainQueue {
            let indexPath = IndexPath(row: self.numberOfRows(inSection: self.numberOfSections-1) - 1, section: self.numberOfSections - 1)
            self.scrollToRow(at: indexPath, at: .bottom, animated: false)
        }
    }
    
    func scrollToTop_WithoutAnimationOrFlickers() {
        //updateMainQueue {
        UIView.performWithoutAnimation {
            self.reloadData()
            self.beginUpdates()
            self.endUpdates()
        }
        let indexPath = IndexPath(row: 0, section: 0)
        self.scrollToRow(at: indexPath, at: .top, animated: false)
        //}
    }
    
    func scrollToBottom_WithoutAnimationOrFlickers() {
        //updateMainQueue {
        UIView.performWithoutAnimation {
            self.reloadData()
            self.beginUpdates()
            self.endUpdates()
        }
        let indexPath = IndexPath(row: self.numberOfRows(inSection: self.numberOfSections-1) - 1, section: self.numberOfSections - 1)
        self.scrollToRow(at: indexPath, at: .bottom, animated: false)
        //}
    }
    
    func scrollToTop_ForParticularPosition(row: Int, section:Int) {
        updateMainQueue {
            let indexPath = IndexPath(row: row, section: section)
            self.scrollToRow(at: indexPath, at: .top, animated: false)
        }
    }
    
    func scrollToBottom_ForParticularPosition(row: Int, section:Int) {
        updateMainQueue {
            let indexPath = IndexPath(row: row, section: section)
            self.scrollToRow(at: indexPath, at: .bottom, animated: false)
        }
    }
    
    func reloadTableViewSelectedRows(SelectedSection: Int, SelectedRow: Int, tableView: UITableView, isAnimated: Bool) {
        //let row = <your array name>.index(of: <name passing in>)
        let reloadPathIndex = IndexPath(row: SelectedRow, section: SelectedSection)
        //tableView.reloadRows(at: [reloadPath], with: .none)
        tableView.scrollToRow(at: reloadPathIndex, at: .top, animated: isAnimated)//false
    }
    
    func reloadTableViewSelectedRows(SelectedSection: Int, SelectedRow: Int, tableView: UITableView) {
        //let row = <your array name>.index(of: <name passing in>)
        let reloadPath = IndexPath(row: SelectedRow, section: SelectedSection)
        tableView.reloadRows(at: [reloadPath], with: .none)
    }
    
    func reloadTableViewWithOutScroll_Fns(tableView: UITableView) {
        let contentOffset = tableView.contentOffset
        tableView.reloadData()
        tableView.layoutIfNeeded()
        tableView.setContentOffset(contentOffset, animated: false)
    }
    
    //MARK: Reloading tableview with out Animating TableView
    func scrollToTop_ForParticularPosition_WithoutAnimationOrFlickers(row: Int, section:Int) {
        //updateMainQueue {
        UIView.performWithoutAnimation {
            self.reloadData()
            self.beginUpdates()
            self.endUpdates()
        }
        let indexPath = IndexPath(row: row, section: section)
        self.scrollToRow(at: indexPath, at: .top, animated: false)
        //}
    }
    func scrollToBottom_ForParticularPosition_WithoutAnimationOrFlickers(row: Int, section:Int) {
        //updateMainQueue {
        UIView.performWithoutAnimation {
            self.reloadData()
            self.beginUpdates()
            self.endUpdates()
        }
        let indexPath = IndexPath(row: row, section: section)
        self.scrollToRow(at: indexPath, at: .bottom, animated: false)
        //}
    }
    
    /*
     UIView.performWithoutAnimation {
         self.controller.chattingView.mainTableVw.reloadData()
         self.controller.chattingView.mainTableVw.beginUpdates()
         self.controller.chattingView.mainTableVw.endUpdates()
     }
     */
    
    /*
     UIView.setAnimationsEnabled(false)
     self.tableView.beginUpdates()
     self.tableView.reloadRows(at: [IndexPath(row: 10, section: 0), IndexPath(row: 11, section: 0)], with: .none)
     self.tableView.endUpdates()
     UIView.setAnimationsEnabled(true)
     */
}





///////////////////////////////////////////=================================///////////////////////////////////////////
extension UIView {
    //OUTPUT 1
    //shadowView.addShadowAndBorder()
    func addShadowAndBorder(shadowScale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: -1, height: 1)
        layer.shadowRadius = 1

        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = shadowScale ? UIScreen.main.scale : 1
    }
    
    //OUTPUT 2
    //shadowView.addShadowAndBorder(cornerRadius: 8.0, borderWidth: 0.5, borderColor: .red, shadowColor: .red, shadowOpacity: 1, shadowOffSet: CGSize(width: -1, height: 1), shadowRadius: 3, shadowScale: true)
    func addShadowAndBorder(cornerRadius: CGFloat, borderWidth: CGFloat, borderColor: UIColor, shadowColor: UIColor, shadowOpacity: Float = 0.5, shadowOffSet: CGSize, shadowRadius: CGFloat = 1, shadowScale: Bool = true) {
        //Shadow setups
        layer.masksToBounds = false
        layer.shadowColor = shadowColor.cgColor
        layer.shadowOpacity = shadowOpacity
        layer.shadowOffset = shadowOffSet
        layer.shadowRadius = shadowRadius
        
        //Border setups
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor.cgColor
        
        //Corner setups
        layer.cornerRadius = cornerRadius
        
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = shadowScale ? UIScreen.main.scale : 1
    }
}

extension UIView {
    //view.addBorderAndShadowForVIEW(offset: CGSize(width: 0, height: 0), color: .red, radius: 10, opacity: 1.0)
    //vw_MainView.addBorderAndShadowForVIEW(view: vw_MainView, cornerRadius: 15, borderWidth:2.0, borderColor: Constants.ColorSet.ColorWhiteONLY!, shadowOffset: CGSize(width: 2, height: 2), shadowColor: Constants.ColorSet.ColorWhiteONLY!, shadowRadius: 1.5, shadowOpacity: 2)
    
    func addBorderAndShadowForVIEW(view:UIView, cornerRadius: CGFloat, borderWidth: CGFloat, borderColor: UIColor, shadowOffset: CGSize, shadowColor: UIColor, shadowRadius: CGFloat, shadowOpacity: Float) {
        //Shadow setups
        //view.layer.masksToBounds = false
        layer.shadowOffset = shadowOffset
        layer.shadowColor = shadowColor.cgColor
        layer.shadowRadius = shadowRadius
        layer.shadowOpacity = shadowOpacity
        
        //Border setups
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor.cgColor
        
        //Corner setups
        layer.cornerRadius = cornerRadius
        
        let backgroundCGColor = backgroundColor?.cgColor
        backgroundColor = nil
        layer.backgroundColor =  backgroundCGColor
        
    }
}

extension UIView {
    
    @discardableResult
    func addBorders(edges: UIRectEdge,
                    color: UIColor,
                    inset: CGFloat = 0.0,
                    thickness: CGFloat = 1.0) -> [UIView] {
        
        var borders = [UIView]()
        
        @discardableResult
        func addBorder(formats: String...) -> UIView {
            let border = UIView(frame: .zero)
            border.backgroundColor = color
            border.translatesAutoresizingMaskIntoConstraints = false
            addSubview(border)
            addConstraints(formats.flatMap {
                NSLayoutConstraint.constraints(withVisualFormat: $0,
                                               options: [],
                                               metrics: ["inset": inset, "thickness": thickness],
                                               views: ["border": border]) })
            borders.append(border)
            return border
        }
        
        
        if edges.contains(.top) || edges.contains(.all) {
            addBorder(formats: "V:|-0-[border(==thickness)]", "H:|-inset-[border]-inset-|")
        }
        
        if edges.contains(.bottom) || edges.contains(.all) {
            addBorder(formats: "V:[border(==thickness)]-0-|", "H:|-inset-[border]-inset-|")
        }
        
        if edges.contains(.left) || edges.contains(.all) {
            addBorder(formats: "V:|-inset-[border]-inset-|", "H:|-0-[border(==thickness)]")
        }
        
        if edges.contains(.right) || edges.contains(.all) {
            addBorder(formats: "V:|-inset-[border]-inset-|", "H:[border(==thickness)]-0-|")
        }
        
        return borders
    }
}


enum RoundType {
    case none
    case all
    case top
    case bottom
    case topLeft
    case topRight
    case bottomLeft
    case bottomRight
}

extension UIView {
    
    func cornerRadiusSetup(with type: RoundType, radius: CGFloat = 0.0, borderColor:UIColor = .clear) {
        var corners: UIRectCorner
        
        switch type {
        case .none:
            corners = []
        case .all:
            corners = [.allCorners]
        case .top:
            corners = [.topLeft, .topRight]
        case .bottom:
            corners = [.bottomLeft, .bottomRight]
        case .topLeft:
            corners = [.topRight]
        case .topRight:
            corners = [.topLeft]
        case .bottomLeft:
            corners = [.bottomRight]
        case .bottomRight:
            corners = [.bottomLeft]
        }
        
        DispatchQueue.main.async {
            let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            self.layer.mask = mask
            
            //kupe added code bellow
            //self.layer.borderColor = borderColor.cgColor
            //self.layer.borderWidth = 1
            //self.layer.masksToBounds = true
        }
    }
}

extension UIView {
   func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}

extension UIView {
    func cornorRadiusView_roundTop(radius:CGFloat = 5){
        self.clipsToBounds = true
        self.layer.cornerRadius = radius
        if #available(iOS 11.0, *) {
            self.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        } else {
            // Fallback on earlier versions
        }
    }
    
    func cornorRadiusView_roundBottom(radius:CGFloat = 5){
        self.clipsToBounds = true
        self.layer.cornerRadius = radius
        if #available(iOS 11.0, *) {
            self.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        } else {
            // Fallback on earlier versions
        }
    }
}
///////////////////////////////////////////=================================///////////////////////////////////////////

//MARK: This is used to set Round CORNORs RADIUS for particular side Start,,,,,
extension UIView {
   func roundCorners_UsingLayerMINMAX(corners:CACornerMask, radius: CGFloat) {
      self.layer.cornerRadius = radius
      self.layer.maskedCorners = corners
   }
}
//MARK: This is used to set Round CORNORs RADIUS for particular side End,,,,,


//MARK: Set Image to Button Right
extension UIButton {
    func addIconToRightSideButton(image: UIImage, imageWidthSize:(CGFloat), imageHeightSize:(CGFloat)) {
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(imageView)
        
        if imageWidthSize == 0.0 {
            imageView.isHidden = true
        }
        
        let lengthWidth = CGFloat(imageWidthSize)//22
        let lengthHeight = CGFloat(imageHeightSize)//22
        titleEdgeInsets.right += lengthWidth
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: self.titleLabel!.trailingAnchor, constant: 5),
            imageView.centerYAnchor.constraint(equalTo: self.titleLabel!.centerYAnchor, constant: 0),
            imageView.widthAnchor.constraint(equalToConstant: lengthWidth),
            imageView.heightAnchor.constraint(equalToConstant: lengthHeight)
        ])
    }
    func addIconToRightSideButton(image: UIImage, imageSize:(CGFloat)) {
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(imageView)
        
        if imageSize == 0.0 {
            imageView.isHidden = true
        }
        
        let length = CGFloat(imageSize)//22
        titleEdgeInsets.right += length
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: self.titleLabel!.trailingAnchor, constant: 5),
            imageView.centerYAnchor.constraint(equalTo: self.titleLabel!.centerYAnchor, constant: 0),
            imageView.widthAnchor.constraint(equalToConstant: length),
            imageView.heightAnchor.constraint(equalToConstant: length)
        ])
    }
    func addIconToLeftSideButton(image: UIImage, imageSize:(CGFloat)) {
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(imageView)
        
        if imageSize == 0.0 {
            imageView.isHidden = true
        }
        
        let length = CGFloat(imageSize)//22
        titleEdgeInsets.left += length
        
        NSLayoutConstraint.activate([
            imageView.trailingAnchor.constraint(equalTo: self.titleLabel!.leadingAnchor, constant: -10),
            imageView.centerYAnchor.constraint(equalTo: self.titleLabel!.centerYAnchor, constant: 0),
            imageView.widthAnchor.constraint(equalToConstant: length),
            imageView.heightAnchor.constraint(equalToConstant: length)
        ])
    }
    func addIconToLeftSideButton(image: UIImage, imageWidthSize:(CGFloat), imageHeightSize:(CGFloat)) {
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(imageView)
        
        if imageWidthSize == 0.0 {
            imageView.isHidden = true
        }
        
        let lengthWidth = CGFloat(imageWidthSize)//22
        let lengthHeight = CGFloat(imageHeightSize)//22
        titleEdgeInsets.left += lengthWidth
        
        NSLayoutConstraint.activate([
            imageView.trailingAnchor.constraint(equalTo: self.titleLabel!.leadingAnchor, constant: -10),
            imageView.centerYAnchor.constraint(equalTo: self.titleLabel!.centerYAnchor, constant: 0),
            imageView.widthAnchor.constraint(equalToConstant: lengthWidth),
            imageView.heightAnchor.constraint(equalToConstant: lengthHeight)
        ])
    }
}


extension UIColor {
    public convenience init?(hex: String) {
        let r, g, b, a: CGFloat
        
        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            var hexColor = String(hex[start...])
            //print("hexColor==>>", hexColor)
            if hexColor.count == 6 {
                //kupe code - manually added
                hexColor = "\(hexColor)FF"
                //kupe code - manually added
            }
            
            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0
                
                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255
                    
                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            } else if hexColor.count == 6 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0
                
                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff0000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff00) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff) >> 8) / 255
                    
                    self.init(red: r, green: g, blue: b, alpha: 1.0)
                    return
                }
            }
            
        }

        return nil
    }
}


// MARK:- UITextField extensions

extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
    
    func setUpBothPadding(left: CGFloat = 0.0, right: CGFloat = 0.0) {
        if left != 0.0 {
            let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: left, height: self.frame.size.height))
            self.leftView = leftPaddingView
            self.leftViewMode = .always
        }
        if right != 0.0 {
            let rightPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: left, height: self.frame.size.height))
            self.rightView = rightPaddingView
            self.rightViewMode = .always
        }
    }
}


private var assocKey : UInt8 = 0
extension UITapGestureRecognizer {
    public var NAME:String{
        get{
            return objc_getAssociatedObject(self, &assocKey) as! String
        }
        set(newValue){
            objc_setAssociatedObject(self, &assocKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
}

/*extension Range where Bound == String.Index {
    var nsRange:NSRange {
        return NSRange(location: self.lowerBound.encodedOffset,
                   length: self.upperBound.encodedOffset -
                    self.lowerBound.encodedOffset)
    }
}*/
extension UITapGestureRecognizer {

    func didTapAttributedTextInLabel(label: UILabel, inRange targetRange: NSRange) -> Bool {
        // Create instances of NSLayoutManager, NSTextContainer and NSTextStorage
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: CGSize.zero)
        let textStorage = NSTextStorage(attributedString: label.attributedText!)

        // Configure layoutManager and textStorage
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)

        // Configure textContainer
        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        let labelSize = label.bounds.size
        textContainer.size = labelSize

        // Find the tapped character location and compare it to the specified range
        let locationOfTouchInLabel = self.location(in: label)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        let textContainerOffset = CGPointMake((labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x,
            (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y);
        let locationOfTouchInTextContainer = CGPointMake(locationOfTouchInLabel.x - textContainerOffset.x,
            locationOfTouchInLabel.y - textContainerOffset.y);
        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)

        return NSLocationInRange(indexOfCharacter, targetRange)
    }

}/*
extension UITapGestureRecognizer {
    
    func didTapAttributedTextInLabel(label: UILabel, inRange targetRange: NSRange) -> Bool {
        // Create instances of NSLayoutManager, NSTextContainer and NSTextStorage
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: CGSize.zero)
        let textStorage = NSTextStorage(attributedString: label.attributedText!)
        
        // Configure layoutManager and textStorage
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        
        // Configure textContainer
        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        let labelSize = label.bounds.size
        textContainer.size = labelSize
        
        // Find the tapped character location and compare it to the specified range
        let locationOfTouchInLabel = self.location(in: label)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        let textContainerOffset = CGPoint(x: (labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x,
                                          y: (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y);
        let locationOfTouchInTextContainer = CGPoint(x: locationOfTouchInLabel.x - textContainerOffset.x,
                                                     y: locationOfTouchInLabel.y - textContainerOffset.y);
        var indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        indexOfCharacter = indexOfCharacter + 4
        return NSLocationInRange(indexOfCharacter, targetRange)
    }

}*/

// An attributed string extension to achieve colors on text.
extension NSMutableAttributedString {
    
    func setColor_NSAttributedString(color: UIColor, forText stringValue: String) {
       let range: NSRange = self.mutableString.range(of: stringValue, options: .caseInsensitive)
        self.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
    }

}

extension UIView {

    func applyGradient(colours: [UIColor]) -> CAGradientLayer {
        return self.applyGradient(colours: colours, locations: nil)
    }
    
    func applyGradient(colours: [UIColor], locations: [NSNumber]?) -> CAGradientLayer {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.locations = locations
        self.layer.insertSublayer(gradient, at: 0)
        return gradient
    }
    
}

extension UIImage {
    var getImageWidth: CGFloat {
        get {
            let width = self.size.width
            return width
        }
    }
    
    var getImageHeight: CGFloat {
        get {
            let height = self.size.height
            return height
        }
    }
}

func getVideoDimension_ResolutionForLocalVideo(url: URL) -> CGSize? {
    guard let track = AVURLAsset(url: url).tracks(withMediaType: AVMediaType.video).first else { return nil }
   let size = track.naturalSize.applying(track.preferredTransform)
   return CGSize(width: abs(size.width), height: abs(size.height))
}


//MARK: =========================================== KUPE extension START ===========================================
//MARK: =========================================== KUPE extension START ===========================================
//MARK: data validation extension functions Start,,,,,
func dataValidation(data:AnyObject?) -> String {
    if data != nil {
        // string instance
        var stringValue:String!
        // Validating Data types
        if data is Int{
            stringValue = String(data as! Int)
        }else if data is Double{
            stringValue = String(data as! Double)
        }else if data is Float{
            stringValue = String(data as! Float)
        }else if data is String{
            stringValue = (data as! String)
        }else if data is Bool{
            stringValue = String(data as! Bool)
        }
        // validating null and nil conditions
        if ((stringValue != nil) && (stringValue != "<null>") && (stringValue != "null") && (stringValue != "") && (stringValue != "<Null>")){
            return stringValue
        }else{
            return ""
        }
    }else{
        return ""
    }
}


func dataResponseValidation(data:AnyObject?) -> Bool {
    // string instance
    var stringValue:String! = ""
    if data is String {
        stringValue = (data as! String)
    } else {
        let keyExists = (data != nil) ? true:false
        if keyExists {
            return true
        } else{
            return false
        }
    }
    
    
    // validating null and nil conditions
    if ((data != nil) && (stringValue != "<null>") && (stringValue != "null") && (stringValue != "") && (stringValue != "<Null>")) {
        return true
    } else{
        return false
    }
}
//MARK: data validation extension functions End,,,,,

extension NSLocale {
    struct Locale {
        let countryCode: String
        let countryName: String
        let countryMobileCode: String
    }
    class func locales() -> [Locale] {
        var locales = [Locale]()
        for localeCode in NSLocale.isoCountryCodes {
            let countryName = NSLocale.current.localizedString(forRegionCode: localeCode)
            //let countryName = "Name"//NSLocale.systemLocale.displayNameForKey(NSLocaleCountryCode, value: localeCode)!
            let countryCode = localeCode //as! String
            
            var countryMobileCode = ""
            let getCode = getCountryPhonceCode(countryCode)
            if getCode != "" {
                countryMobileCode = getCode//NSLocale.current.localizedString(forVariantCode: localeCode)
            } else {
                countryMobileCode = "1"
            }
            
            let locale = Locale(countryCode: countryCode, countryName: countryName!, countryMobileCode: countryMobileCode)
            locales.append(locale)
        }
        
        return locales
    }
    
}

func getCountryPhonceCode (_ country : String) -> String {
    let countryDictionary = CountryMobileCode.countryDictionary
    
    if countryDictionary[country] != nil {
        return countryDictionary[country]!
    } else {
        return ""
    }
}



//MARK: View borders Fns Start,,,,,
extension UIView {
    func addTopBorderWithColor(color: UIColor, width: CGFloat, height: CGFloat, borderSpace: CGFloat) {
        //for (index, element) in direction.enumerated() {
            //print("Item \(index): \(element)")
        //}
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x:0,y: 0, width:width, height:borderSpace)
        self.layer.addSublayer(border)
    }

    func addRightBorderWithColor(color: UIColor, width: CGFloat, height: CGFloat, borderSpace: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: width-borderSpace,y: 0, width:borderSpace, height:height)
        self.layer.addSublayer(border)
    }

    func addBottomBorderWithColor(color: UIColor, width: CGFloat, height: CGFloat, borderSpace: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x:0, y:height-borderSpace, width:width, height:borderSpace)
        self.layer.addSublayer(border)
    }
    
    func addLeftBorderWithColor(color: UIColor, width: CGFloat, height: CGFloat, borderSpace: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x:0, y:0, width:borderSpace, height:height)
        self.layer.addSublayer(border)
    }
}
//MARK: View borders Fns End,,,,,


//MARK: Height for Lable Values Functions,,,,,
func getHeightForLableValues(text: String, font:UIFont, width: CGFloat) -> CGFloat {
    //A dummy label in order to compute dynamic height.
    let label = UILabel()
    
    label.numberOfLines = 0
    label.lineBreakMode = .byWordWrapping
    label.font = font
    
    label.preferredMaxLayoutWidth = width
    label.text = text
    label.invalidateIntrinsicContentSize()
    
    let height = label.intrinsicContentSize.height
    return height
}
func heightForLableValues(text:String, font:UIFont, width:CGFloat) -> CGFloat {
    let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
    label.numberOfLines = 0
    label.lineBreakMode = NSLineBreakMode.byWordWrapping
    //label.preferredMaxLayoutWidth = width
    label.font = font
    label.text = text
    
    label.sizeToFit()
    return label.frame.height
}
//MARK: Width for Lable Values Functions,,,,,
func widthForLableValues(text:String, font:UIFont, width:CGFloat) -> CGFloat {
    let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
    label.numberOfLines = 0
    label.lineBreakMode = NSLineBreakMode.byWordWrapping
    //label.preferredMaxLayoutWidth = width
    label.font = font
    label.text = text
    
    label.sizeToFit()
    return label.frame.width
}

extension UIColor {

    convenience init(hex: Int) {
        let components = (
            R: CGFloat((hex >> 16) & 0xff) / 255,
            G: CGFloat((hex >> 08) & 0xff) / 255,
            B: CGFloat((hex >> 00) & 0xff) / 255
        )

        self.init(red: components.R, green: components.G, blue: components.B, alpha: 1)
    }

}

//
extension UIView {
    
    public func removeAllConstraints() {
        var _superview = self.superview
        
        while let superview = _superview {
            for constraint in superview.constraints {
                
                if let first = constraint.firstItem as? UIView, first == self {
                    superview.removeConstraint(constraint)
                }
                
                if let second = constraint.secondItem as? UIView, second == self {
                    superview.removeConstraint(constraint)
                }
            }
            
            _superview = superview.superview
        }
        
        self.removeConstraints(self.constraints)
        self.translatesAutoresizingMaskIntoConstraints = true
    }
}


public extension UIViewController {
    //statusBarSetGlobally_Fns(setBackColor: .red, setBarStyle: .lightContent, setIsStatusBarHidden:false)
    func statusBarSetGlobally_Fns(setBackColor: UIColor, setBarStyle: UIStatusBarStyle, setIsStatusBarHidden: Bool) {
        
        let keyWindow = UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .compactMap({$0 as? UIWindowScene})
            .first?.windows
            .filter({$0.isKeyWindow}).first
        
        if #available(iOS 13.0, *) {
            let statusBar = UIView(frame: keyWindow?.windowScene?.statusBarManager?.statusBarFrame ?? CGRect.zero)
            statusBar.backgroundColor = setBackColor
            statusBar.tag = 100
            keyWindow?.addSubview(statusBar)
            
           // keyWindow?.windowScene?.statusBarManager?.statusBarStyle = setBarStyle
            UIApplication.shared.statusBarStyle = setBarStyle//Set Style
            UIApplication.shared.isStatusBarHidden = setIsStatusBarHidden//Set if hidden
            
        } else {
            let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView
            statusBar?.backgroundColor = setBackColor
            
            //UIApplication.shared.statusBarStyle = setBarStyle//Set Style
            UIApplication.shared.isStatusBarHidden = setIsStatusBarHidden//Set if hidden
            
        }
        
    }
}

extension UIView {

    var safeAreaBottom: CGFloat {
         if #available(iOS 11, *) {
            if let window = UIApplication.shared.keyWindowInConnectedScenes {
                return window.safeAreaInsets.bottom
            }
         }
         return 0
    }

    var safeAreaTop: CGFloat {
         if #available(iOS 11, *) {
            if let window = UIApplication.shared.keyWindowInConnectedScenes {
                return window.safeAreaInsets.top
            }
         }
         return 0
    }
}

extension UIApplication {
    var keyWindowInConnectedScenes: UIWindow? {
        return windows.first(where: { $0.isKeyWindow })
    }
}

//extension CGFloat {
    
    func stringToCGFloat(string: String) -> CGFloat {
        guard let n = NumberFormatter().number(from: string) else {
            return 0.0
        }
        return CGFloat(truncating: n)
    }
    
//}

extension UIColor {
    static func rgbColor(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: alpha)
    }
}

extension UIButton {

    func makeMultiLineSupport() {
        guard let titleLabel = titleLabel else {
            return
        }
        titleLabel.numberOfLines = 0
        titleLabel.setContentHuggingPriority(.required, for: .vertical)
        titleLabel.setContentHuggingPriority(.required, for: .horizontal)
        addConstraints([
            .init(item: titleLabel,
                  attribute: .top,
                  relatedBy: .greaterThanOrEqual,
                  toItem: self,
                  attribute: .top,
                  multiplier: 1.0,
                  constant: contentEdgeInsets.top),
            .init(item: titleLabel,
                  attribute: .bottom,
                  relatedBy: .greaterThanOrEqual,
                  toItem: self,
                  attribute: .bottom,
                  multiplier: 1.0,
                  constant: contentEdgeInsets.bottom),
            .init(item: titleLabel,
                  attribute: .left,
                  relatedBy: .greaterThanOrEqual,
                  toItem: self,
                  attribute: .left,
                  multiplier: 1.0,
                  constant: contentEdgeInsets.left),
            .init(item: titleLabel,
                  attribute: .right,
                  relatedBy: .greaterThanOrEqual,
                  toItem: self,
                  attribute: .right,
                  multiplier: 1.0,
                  constant: contentEdgeInsets.right)
            ])
    }

}

/*
extension UILabel {
    typealias MethodHandler = () -> Void
    func addRangeGesture(stringRange: String, function: @escaping MethodHandler) {
        RangeGestureRecognizer.stringRange = stringRange
        RangeGestureRecognizer.function = function
        self.isUserInteractionEnabled = true
        let tapgesture: UITapGestureRecognizer = RangeGestureRecognizer(target: self, action: #selector(tappedOnLabel(_ :)))
        tapgesture.numberOfTapsRequired = 1
        self.addGestureRecognizer(tapgesture)
    }

    @objc func tappedOnLabel(_ gesture: RangeGestureRecognizer) {
        guard let text = self.text else { return }
        let stringRange = (text as NSString).range(of: RangeGestureRecognizer.stringRange ?? "")
        if gesture.didTapAttributedTextInLabel_1(label: self, inRange: stringRange) {
            guard let existedFunction = RangeGestureRecognizer.function else { return }
            existedFunction()
        }
    }
}
*/

//MARK: Both Json to String && String to Json Convertions Start,,,,,
func convertToJsonString(json: [Any]) -> String? {
    do {
        let jsonData = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        return String(data: jsonData, encoding: .utf8)
    } catch {
        print(error.localizedDescription)
    }
    return nil
}

func jsonToString(json: AnyObject) -> String {
    do {
        let data1 =  try JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions.prettyPrinted) // first of all convert json to the data
        let convertedString = String(data: data1, encoding: .utf8) // the data will be converted to the string
        //print(convertedString) // <-- here is ur string
        return convertedString ?? ""
    } catch let error as NSError {
        print("myJSONError===>>\(error)")
        return ""
    }
}

func stringToJson(strMessage: String?) -> AnyObject {
    let nilAnyObj = [] as AnyObject
    if let strMessage = strMessage {
        let data = strMessage.data(using: .utf8)!
        do {
            if let jsonChatDict = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? AnyObject {
                return jsonChatDict
            } else {
                return nilAnyObj
            }
        } catch let error as NSError {
            print("error===>>", error)
            return nilAnyObj
        }
    } else {
        return nilAnyObj
    }
}
//MARK: Both Json to String && String to Json Convertions End,,,,,

//MARK: =========================================== KUPE extension END ===========================================
//MARK: =========================================== KUPE extension END ===========================================

