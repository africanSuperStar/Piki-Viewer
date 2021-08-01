//
//  Session.swift
//  Mindira
//
//  Created by Cameron de Bruyn on 2021/08/01.
//

import Foundation
import Combine


open class Session : URLSession
{
    // MARK: - Properties

    public static var defaultTestBundle: Bundle?
    {
        return Bundle.allBundles.first { $0.bundlePath.hasSuffix(".xctest") }
    }

    open var outputDirectory: String
    open var recordingEnabled = true
    
    public let cassetteName:   String
    public let backingSession: URLSession

    private let testBundle:     Bundle
    private let headersToCheck: [String]

    private var recording             = false
    private var needsPersistence      = false
    private var outstandingTasks      = [URLSessionDataTask]()
    private var completedInteractions = [Interaction]()
    
    private var completionBlock: (() -> Void)?

    override open var delegate: URLSessionDelegate?
    {
        return backingSession.delegate
    }

    // MARK: - Initializers

    public init(
        outputDirectory: String = "$HOME/Desktop/DVR/",
        cassetteName:    String,
        testBundle:      Bundle = Session.defaultTestBundle!,
        backingSession:  URLSession,
        headersToCheck:  [String] = []
    ) {
        self.outputDirectory = outputDirectory
        self.cassetteName    = cassetteName
        self.testBundle      = testBundle
        self.backingSession  = backingSession
        self.headersToCheck  = headersToCheck
        
        let configuration = URLSessionConfiguration.default
        
        configuration.waitsForConnectivity       = true
        configuration.timeoutIntervalForRequest  = 15
        configuration.timeoutIntervalForResource = 15
    }

    // MARK: - URLSession
    
    open override func dataTask(with url: URL) -> URLSessionDataTask
    {
        /// Tag: - This is actually a dataTaskPublisher
        
        return addDataTask(URLRequest(url: url))
    }

    open override func invalidateAndCancel()
    {
        recording = false
        outstandingTasks.removeAll()
        backingSession.invalidateAndCancel()
    }

    // MARK: - Recording

    /// You don’t need to call this method if you're only recoding one request.
    open func beginRecording()
    {
        if recording
        {
            return
        }

        recording             = true
        needsPersistence      = false
        outstandingTasks      = []
        completedInteractions = []
        completionBlock       = nil
    }

    /// This only needs to be called if you call `beginRecording`. `completion` will be called on the main queue after
    /// the completion block of the last task is called. `completion` is useful for fulfilling an expectation you setup
    /// before calling `beginRecording`.
    open func endRecording(_ completion: (() -> Void)? = nil)
    {
        if !recording
        {
            return
        }

        recording       = false
        completionBlock = completion

        if outstandingTasks.count == 0
        {
            finishRecording()
        }
    }

    // MARK: - Internal

    var cassette: Cassette?
    {
        guard
            let path = testBundle.path(forResource: cassetteName, ofType: "json"),
            let data = try? Data(contentsOf: URL(fileURLWithPath: path)),
            let raw  = try? JSONSerialization.jsonObject(with: data, options: []),
            let json = raw as? [String: Any]
        else
        {
            return nil
        }

        return Cassette(dictionary: json)
    }

    func finishTask(_ task: URLSessionDataTask, interaction: Interaction, playback: Bool)
    {
        needsPersistence = needsPersistence || !playback

        if let index = outstandingTasks.firstIndex(of: task)
        {
            outstandingTasks.remove(at: index)
        }

        completedInteractions.append(interaction)

        if !recording && outstandingTasks.count == 0
        {
            finishRecording()
        }

        if let delegate = delegate as? URLSessionDataDelegate,
           let data     = interaction.responseData
        {
            delegate.urlSession?(self, dataTask: task, didReceive: data as Data)
        }

        if let delegate = delegate as? URLSessionTaskDelegate
        {
            delegate.urlSession?(self, task: task, didCompleteWithError: nil)
        }
    }


    // MARK: - Private

    private func addDataTask(
        _ request:         URLRequest,
        completionHandler: ((Data?, Foundation.URLResponse?, NSError?) -> Void)? = nil
    )
    -> URLSessionDataTask
    {
        let modifiedRequest = backingSession.configuration.httpAdditionalHeaders.map(request.appending) ?? request
        
        if let task = SessionDataTask(session: self, request: modifiedRequest, headersToCheck: headersToCheck, completion: completionHandler)
        {
            addTask(task)
            return task
        }
        
        return URLSessionDataTask()
    }

    private func addTask(_ task: URLSessionDataTask)
    {
        let shouldRecord = !recording
        
        if shouldRecord
        {
            beginRecording()
        }

        outstandingTasks.append(task)

        if shouldRecord
        {
            endRecording()
        }
    }

    private func persist(_ interactions: [Interaction])
    {
        defer
        {
            abort()
        }

        // Create directory
        let outputDirectory = (self.outputDirectory as NSString).expandingTildeInPath
        
        let fileManager = FileManager.default
        
        if !fileManager.fileExists(atPath: outputDirectory)
        {
            do {
              try fileManager.createDirectory(atPath: outputDirectory, withIntermediateDirectories: true, attributes: nil)
            }
            catch
            {
              print("[VHR] Failed to create cassettes directory.")
            }
        }

        let cassette = Cassette(name: cassetteName, interactions: interactions)

        // Persist

        do {
            let outputPath = ((outputDirectory as NSString).appendingPathComponent(cassetteName) as NSString).appendingPathExtension("json")!
            let data = try JSONSerialization.data(withJSONObject: cassette.dictionary, options: [.prettyPrinted])

            // Add trailing new line
            guard var string = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
                else
            {
                print("[VHR] Failed to persist cassette.")
                return
            }
            
            string = string.appending("\n") as NSString

            if let data = string.data(using: String.Encoding.utf8.rawValue)
            {
                try? data.write(to: URL(fileURLWithPath: outputPath), options: [.atomic])
                print("[VHR] Persisted cassette at \(outputPath). Please add this file to your test target")
                return
            }

            print("[VHR] Failed to persist cassette.")
        }
        catch
        {
            print("[VHR] Failed to persist cassette.")
        }
    }

    private func finishRecording()
    {
        if needsPersistence
        {
            persist(completedInteractions)
        }

        // Clean up
        completedInteractions = []

        // Call session’s completion block
        completionBlock?()
    }
}
