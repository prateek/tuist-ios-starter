// ABOUTME: Network path monitoring for detecting connectivity state changes
// ABOUTME: Uses NWPathMonitor to provide real-time network status updates

import ComposableArchitecture
import Foundation
import Network

@DependencyClient
public struct NetworkMonitor: Sendable {
    public var isConnected: @Sendable () async -> Bool = { true }
    public var pathUpdates: @Sendable () -> AsyncStream<NWPath.Status> = {
        AsyncStream { _ in }
    }
}

extension NetworkMonitor: DependencyKey {
    public static let liveValue = NetworkMonitor(
        isConnected: {
            await withCheckedContinuation { continuation in
                let monitor = NWPathMonitor()
                monitor.pathUpdateHandler = { path in
                    continuation.resume(returning: path.status == .satisfied)
                    monitor.cancel()
                }
                let queue = DispatchQueue(label: "NetworkMonitor")
                monitor.start(queue: queue)
            }
        },
        pathUpdates: {
            AsyncStream { continuation in
                let monitor = NWPathMonitor()
                monitor.pathUpdateHandler = { path in
                    continuation.yield(path.status)
                }
                let queue = DispatchQueue(label: "NetworkMonitor")
                monitor.start(queue: queue)

                continuation.onTermination = { _ in
                    monitor.cancel()
                }
            }
        }
    )

    public static let testValue = NetworkMonitor(
        isConnected: { true },
        pathUpdates: {
            AsyncStream { continuation in
                continuation.yield(.satisfied)
                continuation.finish()
            }
        }
    )

    public static let previewValue = testValue
}

public extension DependencyValues {
    var networkMonitor: NetworkMonitor {
        get { self[NetworkMonitor.self] }
        set { self[NetworkMonitor.self] = newValue }
    }
}
