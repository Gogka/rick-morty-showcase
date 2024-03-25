//
//  UIControl+.swift
//  rick-and-morty-showcase
//
//  Created by Igor Tomilin on 24.03.24.
//

import UIKit
import Combine

extension UIControl: PublishedControl {}

protocol PublishedControl: AnyObject { }
extension PublishedControl where Self: UIControl {
    func publisher(forEvent event: UIControl.Event = .primaryActionTriggered) -> Publishers.Control<Self> {
        .init(control: self, event: event)
    }
}

extension Publishers {
    final class Control<C: UIControl>: Publisher {
        typealias Output = C
        typealias Failure = Never
        
        private let control: C
        private let event: UIControl.Event
        
        init(control: C, event: UIControl.Event) {
            self.control = control
            self.event = event
        }
        
        func receive<S>(subscriber: S) where S : Subscriber, S.Failure == Never, S.Input == C {
            subscriber.receive(subscription: Subscription(subscriber, control, event))
        }
        
        private class Subscription<S>: NSObject, Combine.Subscription where S: Subscriber, S.Input == C, S.Failure == Never {
            private var subscriber: S?
            private weak var control: C?
            private let event: UIControl.Event
            private var unconsumedDemand = Subscribers.Demand.none
            private var unconsumedEvents = 0
            
            init(_ subscriber: S, _ control: C, _ event: UIControl.Event) {
                self.subscriber = subscriber
                self.control = control
                self.event = event
                super.init()
                
                control.addTarget(self, action: #selector(onEvent), for: event)
            }
            
            deinit {
                control?.removeTarget(self, action: #selector(onEvent), for: event)
            }
                        
            func request(_ demand: Subscribers.Demand) {
                unconsumedDemand += demand
                consumeDemand()
            }
            
            func cancel() {
                subscriber = nil
            }
            
            private func consumeDemand() {
                guard let control else { return }
                while let subscriber = subscriber, unconsumedDemand > 0, unconsumedEvents > 0 {
                    unconsumedDemand -= 1
                    unconsumedEvents -= 1
                    unconsumedDemand += subscriber.receive(control)
                }
            }

            @objc
            private func onEvent() {
                unconsumedEvents += 1
                consumeDemand()
            }
        }
    }
}
