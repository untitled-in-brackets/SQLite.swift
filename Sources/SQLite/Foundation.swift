//
// SQLite.swift
// https://github.com/stephencelis/SQLite.swift
// Copyright © 2014-2015 Stephen Celis.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

#if canImport(FoundationEssentials)
public import struct FoundationEssentials.Data
public import struct FoundationEssentials.Date
public import struct FoundationEssentials.URL
public import struct FoundationEssentials.UUID
#else
public import Foundation
#endif

extension Data: Value {

    public static var declaredDatatype: String {
        Blob.declaredDatatype
    }

    public static func fromDatatypeValue(_ dataValue: Blob) -> Data {
        Data(dataValue.bytes)
    }

    public var datatypeValue: Blob {
        withUnsafeBytes { (pointer: UnsafeRawBufferPointer) -> Blob in
            Blob(bytes: pointer.baseAddress!, length: count)
        }
    }

}

#if Foundation
extension Date: Value {

    public static var declaredDatatype: String {
        String.declaredDatatype
    }

    public static func fromDatatypeValue(_ stringValue: String) -> Date {
        parseSQLiteDate(stringValue)!
    }

    public var datatypeValue: String {
        formatSQLiteDate(self)
    }

}

#if canImport(FoundationEssentials)
private let dateFormatStyle = Date.ISO8601FormatStyle()
    .year()
    .month()
    .day()
    .dateSeparator(.dash)
    .time(includingFractionalSeconds: true)

func parseSQLiteDate(_ stringValue: String) -> Date? {
    try? dateFormatStyle.parse(stringValue)
}

func formatSQLiteDate(_ date: Date) -> String {
    date.formatted(dateFormatStyle)
}
#else
/// A global date formatter used to serialize and deserialize `NSDate` objects.
/// If multiple date formats are used in an application’s database(s), use a
/// custom `Value` type per additional format.
public let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.timeZone = TimeZone(secondsFromGMT: 0)
    return formatter
}()

func parseSQLiteDate(_ stringValue: String) -> Date? {
    dateFormatter.date(from: stringValue)
}

func formatSQLiteDate(_ date: Date) -> String {
    dateFormatter.string(from: date)
}
#endif
#endif

extension UUID: Value {

    public static var declaredDatatype: String {
        String.declaredDatatype
    }

    public static func fromDatatypeValue(_ stringValue: String) -> UUID {
        UUID(uuidString: stringValue)!
    }

    public var datatypeValue: String {
        uuidString
    }

}

extension URL: Value {

    public static var declaredDatatype: String {
        String.declaredDatatype
    }

    public static func fromDatatypeValue(_ stringValue: String) -> URL {
        URL(string: stringValue)!
    }

    public var datatypeValue: String {
        absoluteString
    }

}
