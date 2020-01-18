//
//  UTI.swift
//  SyzygyCore
//
//  Created by Dave DeLong on 12/31/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

public final class UTI: Newtype, Hashable, CustomStringConvertible, CustomDebugStringConvertible {
    
    public static func ==(lhs: UTI, rhs: UTI) -> Bool {
        if lhs === rhs { return true }
        return UTTypeEqual(lhs.rawCFValue, rhs.rawCFValue)
    }
    
    public static func ~=(pattern: UTI, value: UTI) -> Bool {
        return value.conformsTo(pattern)
    }
    
    public static func UTIs(for tagClass: String, tag: String, conformingTo: UTI?) -> Array<UTI> {
        guard let raw = UTTypeCreateAllIdentifiersForTag(tagClass as CFString, tag as CFString, conformingTo?.rawCFValue) else { return [] }
        let rawUTIs = raw.takeRetainedValue() as? Array<String> ?? []
        return rawUTIs.map { UTI(rawValue: $0) }
    }
    
    public static func UTIs(fromFileExtension filenameExtension: String, conformingTo: UTI? = nil) -> Array<UTI> {
        return UTIs(for: kUTTagClassFilenameExtension as String, tag: filenameExtension, conformingTo: conformingTo)
    }
    
    public static func UTIs(fromMimeType mimeType: String, conformingTo: UTI? = nil) -> Array<UTI> {
        return UTIs(for: kUTTagClassMIMEType as String, tag: mimeType, conformingTo: conformingTo)
    }
    
    private let rawCFValue: CFString
    
    public var rawValue: String { return rawCFValue as String }
    public var hashValue: Int { return rawValue.hashValue }
    public var description: String {
        let rawDescription = UTTypeCopyDescription(rawCFValue)?.takeRetainedValue()
        return rawDescription.map({ $0 as String }) ?? rawValue
    }
    public var debugDescription: String { return rawValue }
    
    public lazy var declaringBundle: Bundle? = { [unowned self] in
        let cfURL = UTTypeCopyDeclaringBundleURL(self.rawCFValue)?.takeRetainedValue()
        return cfURL.flatMap { Bundle(url: $0 as URL) }
    }()
    
    public lazy var declaration: Declaration = { [unowned self] in
        return Declaration(uti: self.rawCFValue)
    }()
    
    public lazy var isDynamic: Bool = { [unowned self] in
        return UTTypeIsDynamic(self.rawCFValue)
    }()
    
    public lazy var isDeclared: Bool = { [unowned self] in
        return UTTypeIsDeclared(self.rawCFValue)
    }()
    
    public lazy var preferredMIMEType: String? = { [unowned self] in
        return self.preferredTag(for: kUTTagClassMIMEType)
    }()
    
    public lazy var preferredFileExtension: String? = { [unowned self] in
        return self.preferredTag(for: kUTTagClassFilenameExtension)
    }()
    
    public lazy var mimeTypes: Array<String> = { [unowned self] in
        return self.tags(for: kUTTagClassMIMEType)
    }()
    
    public lazy var fileExtensions: Array<String> = { [unowned self] in
        return self.tags(for: kUTTagClassFilenameExtension)
    }()
    
    public lazy var iconPath: AbsolutePath? = {
        var utisToCheck = [self]
        var checked = Set<UTI>()
        
        while utisToCheck.isEmpty == false {
            let first = utisToCheck.removeFirst()
            guard checked.contains(first) == false else { continue }
            checked.insert(first)
            
            guard let thisBundle = first.declaringBundle else { continue }
            
            if let iconName = first.declaration.iconFile {
                let url = thisBundle.url(forResource: iconName, withExtension: nil) ??
                    thisBundle.url(forResource: iconName, withExtension: "icns")
                return url.map { AbsolutePath($0) }
            } else if let iconPath = first.declaration.iconPath {
                return thisBundle.path.appending(path: RelativePath(path: iconPath))
            }
            
            utisToCheck.append(contentsOf: first.declaration.conformsTo)
        }
        
        return nil
    }()
    
    public init(rawValue: String) {
        self.rawCFValue = rawValue as CFString
    }
    
    public init(_ cfValue: CFString) {
        self.rawCFValue = cfValue
    }
    
    private convenience init?(tagClass: CFString, tag: String, conformingTo: UTI?) {
        guard let raw = UTTypeCreatePreferredIdentifierForTag(tagClass, tag as CFString, conformingTo?.rawCFValue) else { return nil }
        let rawCFString = raw.takeRetainedValue()
        self.init(rawCFString)
    }
    
    public convenience init?(fileExtension: String, conformingTo: UTI? = nil) {
        self.init(tagClass: kUTTagClassFilenameExtension, tag: fileExtension, conformingTo: conformingTo)
    }
    
    public convenience init?(mimeType: String, conformingTo: UTI? = nil) {
        self.init(tagClass: kUTTagClassMIMEType, tag: mimeType, conformingTo: conformingTo)
    }
    
    public func conformsTo(_ other: UTI) -> Bool {
        return UTTypeConformsTo(rawCFValue, other.rawCFValue)
    }
    
    private func preferredTag(for tagClass: CFString) -> String? {
        guard let raw = UTTypeCopyPreferredTagWithClass(rawCFValue, tagClass) else { return nil }
        return raw.takeRetainedValue() as String
    }
    
    private func tags(for tagClass: CFString) -> Array<String> {
        guard let raw = UTTypeCopyAllTagsWithClass(rawCFValue, tagClass) else { return [] }
        return raw.takeRetainedValue() as? Array<String> ?? []
    }
    
    
    #if BUILDING_FOR_DESKTOP
    public static func UTIs(fromPasteBoardType pasteBoardType: String, conformingTo: UTI? = nil) -> Array<UTI> {
        return UTIs(for: kUTTagClassNSPboardType as String, tag: pasteBoardType, conformingTo: conformingTo)
    }
    
    public static func UTIs(fromOSType OSType: String, conformingTo: UTI? = nil) -> Array<UTI> {
        return UTIs(for: kUTTagClassOSType as String, tag: OSType, conformingTo: conformingTo)
    }
    
    public convenience init?(pasteBoardType: String, conformingTo: UTI? = nil) {
        self.init(tagClass: kUTTagClassNSPboardType, tag: pasteBoardType, conformingTo: conformingTo)
    }
    
    public convenience init?(OSType: String, conformingTo: UTI? = nil) {
        self.init(tagClass: kUTTagClassOSType, tag: OSType, conformingTo: conformingTo)
    }
    
    public lazy var preferredPasteBoardType: String? = { [unowned self] in
        return self.preferredTag(for: kUTTagClassNSPboardType)
    }()
    
    public lazy var preferredOSType: String? = { [unowned self] in
        return self.preferredTag(for: kUTTagClassOSType)
    }()
    
    public lazy var pasteBoardTypes: Array<String> = { [unowned self] in
        return self.tags(for: kUTTagClassNSPboardType)
    }()
    
    public lazy var OSTypes: Array<String> = { [unowned self] in
        return self.tags(for: kUTTagClassOSType)
    }()
    #endif
    
    
    
    public struct Declaration {
        private let raw: Dictionary<String, Any>
        
        public subscript<T>(key: String) -> T? {
            return raw[key] as? T
        }
        
        public subscript<T>(key: CFString) -> T? {
            return raw[key as String] as? T
        }
        
        public var identifier: String? { return self[kUTTypeIdentifierKey] }
        public var iconFile: String? { return self[kUTTypeIconFileKey] }
        public var iconPath: String? { return self["_LSIconPath"] }
        public var version: String? { return self[kUTTypeVersionKey] }
        public var description: String { return raw.description }
        public var debugDescription: String { return raw.debugDescription }
        
        public var exportedTypeDeclarations: Array<Declaration> {
            let rawDeclarations: Array<Dictionary<String, Any>> = self[kUTExportedTypeDeclarationsKey] ?? []
            return rawDeclarations.map { Declaration($0) }
        }
        
        public var importedTypeDeclarations: Array<Declaration> {
            let rawDeclarations: Array<Dictionary<String, Any>> = self[kUTImportedTypeDeclarationsKey] ?? []
            return rawDeclarations.map { Declaration($0) }
        }
        
        public var tagSpecification: Dictionary<String, Any> { return self[kUTTypeTagSpecificationKey] ?? [:] }
        
        public var conformsTo: Array<UTI> {
            switch raw[kUTTypeConformsToKey as String] {
                case let array as Array<String>:
                    return array.map { UTI(rawValue: $0) }
                case let string as String:
                    return [UTI(rawValue: string)]
                default:
                    return []
            }
        }
        
        public var referenceURL: URL? {
            let reference: String? = self[kUTTypeReferenceURLKey]
            return reference.flatMap { URL(string: $0) }
        }
        
        
        public init(uti: CFString) {
            let rawDeclaration = UTTypeCopyDeclaration(uti)?.takeRetainedValue()
            self.raw = rawDeclaration.flatMap { $0 as? Dictionary<String, Any> } ?? [:]
        }
        
        public init(_ declaration: Dictionary<String, Any>) {
            self.raw = declaration
        }
        
        internal func allStringValues() -> Array<String> {
            var found = Array<String>()
            var waiting = Array(self.raw.values)
            while let next = waiting.popLast() {
                if let s = next as? String {
                    found.append(s)
                } else if let d = next as? Dictionary<String, Any> {
                    waiting.append(contentsOf: Array(d.values))
                } else if let a = next as? Array<String> {
                    found.append(contentsOf: a)
                } else if let a = next as? Array<Any> {
                    waiting.append(contentsOf: a)
                }
            }
            return found
        }
        
    }
}

