//
//  SessionDataTask.swift
//  Mindira
//
//  Created by Cameron de Bruyn on 2021/08/01.
//

import Foundation


final class SessionDataTask : URLSessionDataTask
{
    // MARK: - Types

    typealias Completion = (Data?, Foundation.URLResponse?, NSError?) -> Void

    // MARK: - Properties

    weak var session: Session!
    
    var request:        URLRequest?
    var headersToCheck: [String]?
    
    var completion: Completion?
    
    private let queue = DispatchQueue(label: "com.cdebruyn.VHR.sessionDataTaskQueue", attributes: [])
    
    private var interaction: Interaction!
    
    // MARK: - Initializers

    convenience init?(
        session:        Session,
        request:        URLRequest,
        headersToCheck: [String] = [],
        completion:     (Completion)? = nil)
    {
        self.init(session: session, request: request)
        
        self.session        = session
        self.request        = request
        self.headersToCheck = headersToCheck
        self.completion     = completion
    }

    // MARK: - URLSessionTask
    
    func receive()
    {
        let cassette = session.cassette

        guard let _request = request,
              let _headersToCheck = headersToCheck
        else
        {
            return
        }
        
        // Find interaction
        if let interaction = session.cassette?.interactionForRequest(_request, headersToCheck: _headersToCheck)
        {
            self.interaction = interaction
        
            // Forward completion
            if let completion = completion
            {
                queue.async
                {
                    completion(interaction.responseData, interaction.response, nil)
                }
            }
            
            session?.finishTask(self, interaction: interaction, playback: true)
            
            return
        }

        if cassette != nil
        {
            fatalError("[VHR] Invalid request. The request was not found in the cassette.")
        }

        // Cassette is missing. Record.
        if session?.recordingEnabled == false
        {
            fatalError("[VHR] Recording is disabled.")
        }

        session?.backingSession.dataTaskPublisher(for: _request)
            .sink(receiveCompletion: { _ in },
                  receiveValue:
            {
                [weak self] result in
            
                guard let this = self else { return }
                
                // Still call the completion block so the user can chain requests while recording.
                this.queue.async
                {
                    this.completion?(result.data, result.response, nil)
                }
                
                // Create interaction
                this.interaction = Interaction(request: _request, response: result.response, responseData: result.data)
                this.session?.finishTask(this, interaction: this.interaction, playback: false)
            })
            .cancel()
    }
}
