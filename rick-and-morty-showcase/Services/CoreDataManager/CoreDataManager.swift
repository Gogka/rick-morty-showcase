//
//  CoreDataManager.swift
//  rick-and-morty-showcase
//
//  Created by Igor Tomilin on 24.03.24.
//

import Foundation
import CoreData

final class CoreDataManager {
    private let persistentContainer: NSPersistentContainer
    private lazy var backgroundContext: NSManagedObjectContext = persistentContainer.newBackgroundContext()
    @MainActor private var isLoaded = false
    init() {
        self.persistentContainer = NSPersistentContainer(name: "LocalStorageModel")
    }
    func performOnBackgroundContext<Returned>(_ action: @escaping (NSManagedObjectContext) throws -> Returned) async throws -> Returned {
        try await performOnContext(context: { backgroundContext }, action)
    }
    private func performOnContext<Returned>(
        context: () -> NSManagedObjectContext,
        schedule: NSManagedObjectContext.ScheduledTaskType = .immediate,
        _ action: @escaping (NSManagedObjectContext) throws -> Returned
    ) async throws -> Returned {
        if await !isLoaded {
            let description = try await load()
            await MainActor.run { isLoaded = true }
            Logger.default.debug("\(description)")
        }
        let ctx = context()
        return try await ctx.perform(schedule: schedule) {
            return try action(ctx)
        }
    }
    private func load() async throws -> NSPersistentStoreDescription {
        try await withUnsafeThrowingContinuation { continuation in
            persistentContainer.loadPersistentStores { description, error in
                if let error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(returning: description)
                }
                
            }
        }
    }
}
