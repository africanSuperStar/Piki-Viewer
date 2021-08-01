//
//  NSManagedObject+Ext.swift
//  Mindira
//
//  Created by Cameron de Bruyn on 2021/07/31.
//

import Combine
import CoreData

// MARK: - NSManagedObjectContext + PerformPublisher

extension NSManagedObjectContext
{
    public func publisher <T> (
        _ block: @escaping () throws -> T
    )
    -> AnyPublisher <T, Error>
    {
        PerformPublisher<T>(
            managedObjectContext: self,
            block: block
        )
        .eraseToAnyPublisher()
    }

    public func fetchPublisher <T> (
        _ fetchRequest: NSFetchRequest<T>
    )
    -> AnyPublisher <[T], Error> where T: NSFetchRequestResult
    {
        PerformPublisher <[T]> (managedObjectContext: self)
        {
            try fetchRequest.execute()
        }
        .eraseToAnyPublisher()
    }
}

private struct PerformPublisher <Output> : Publisher
{
    typealias Failure = Error

    let managedObjectContext: NSManagedObjectContext

    let block: () throws -> Output

    func receive<S>(
        subscriber: S
    )
    where S: Subscriber, Failure == S.Failure, Output == S.Input
    {
        let subscription = PerformSubscription<Output>(
            subscriber: AnySubscriber(subscriber),
            publisher: self
        )
        
        subscriber.receive(subscription: subscription)
    }
}

private final class PerformSubscription <Output> : Subscription, CustomStringConvertible
{
    private var subscriber: AnySubscriber <Output, Error>?
    
    private let publisher: PerformPublisher<Output>
    
    var description: String { "PerformPublisher" }
    
    init(
        subscriber: AnySubscriber <Output, Error>,
        publisher: PerformPublisher <Output>
    ) {
        self.subscriber = subscriber
        self.publisher  = publisher
    }

    func request(_ demand: Subscribers.Demand)
    {
        guard demand != .none, subscriber != nil else { return }

        publisher.managedObjectContext.perform
        {
            guard let subscriber = self.subscriber else { return }
        
            do {
                let output = try self.publisher.block()
                _ = subscriber.receive(output)
            
                subscriber.receive(completion: .finished)
            }
            catch
            {
                subscriber.receive(completion: .failure(error))
            }
        }
    }

    func cancel()
    {
        subscriber = nil
    }
}
