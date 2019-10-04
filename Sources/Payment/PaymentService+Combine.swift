import Foundation

#if canImport(Combine)
//import Combine
//
//@available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
//extension PaymentService: Publisher {
//	public typealias Output = PaymentSession
//	public typealias Failure = Error
//
//	public func receive<S>(subscriber: S) where S : Subscriber, PaymentService.Failure == S.Failure, PaymentService.Output == S.Input {
//		subscriber.receive(subscription: Subscriptions.empty)
//		
//		loadPaymentSession(from: paymentSessionURL) { result in
//			switch result {
//			case .success(let session): _ = subscriber.receive(session)
//			case .failure(let error): subscriber.receive(completion: .failure(error))
//			}
//		}
//	}
//	
//}
#endif
