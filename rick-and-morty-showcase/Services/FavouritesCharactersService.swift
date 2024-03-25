//
//  FavouritesCharactersService.swift
//  rick-and-morty-showcase
//
//  Created by Igor Tomilin on 24.03.24.
//

import Foundation
import CoreData
import Combine

protocol FavouritesCharactersService {
    typealias Character = CharactersListRequest.SuccessfullResponse.Character
    var chagesPublisher: AnyPublisher<FavouritesCharactersServiceChange, Never> { get }
    func getAllFavouriteCharacters() async throws -> [Character]
    func isCharacterFavourite(id: Int) async throws -> Bool
    func save(character: FavouritesCharactersService.Character, sender: Any?) async throws
    func deleteCharacter(_ character: FavouritesCharactersService.Character, sender: Any?) async throws
    func getCharacter(byId id: Int) async throws -> Character?
}
struct FavouritesCharactersServiceChange {
    enum Action {
        case add
        case delete
    }
    let character: FavouritesCharactersService.Character
    let action: Action
    let sender: Any?
    var senderObject: AnyObject? { sender as? AnyObject }
}

final class CoreDataFavouritesCharactersService: FavouritesCharactersService {
    private let manager: CoreDataManager
    private lazy var changesSubject = PassthroughSubject<FavouritesCharactersServiceChange, Never>()
    var chagesPublisher: AnyPublisher<FavouritesCharactersServiceChange, Never> { changesSubject.eraseToAnyPublisher() }
    init(manager: CoreDataManager) {
        self.manager = manager
    }
    func getAllFavouriteCharacters() async throws -> [FavouritesCharactersService.Character] {
        try await manager.performOnBackgroundContext { [weak self] ctx in
            guard let self else {
                throw DevError("CoreDataFavouritesCharactersService is deinited.")
            }
            let characters = try ctx.fetch(FavouriteCharacterCD.fetchRequest())
            return characters.compactMap { try? self.map($0) }
        }
    }
    func isCharacterFavourite(id: Int) async throws -> Bool {
        try await manager.performOnBackgroundContext { context in
            let request = makeObject(FavouriteCharacterCD.fetchRequest()) {
                $0.predicate = NSPredicate(format: "id = %i", id)
                $0.fetchLimit = 1
            }
            return try !context.fetch(request).isEmpty
        }
    }
    func save(character: FavouritesCharactersService.Character, sender: Any?) async throws {
        try await manager.performOnBackgroundContext { [weak self] ctx in
            let characterCD = FavouriteCharacterCD(context: ctx)
            characterCD.id = Int64(character.id)
            characterCD.name = character.name
            characterCD.type = character.type
            characterCD.image = character.image
            try ctx.save()
            self?.changesSubject.send(.init(character: character, action: .add, sender: sender))
        }
    }
    func deleteCharacter(_ character: FavouritesCharactersService.Character, sender: Any?) async throws {
        try await manager.performOnBackgroundContext { [weak self] ctx in
            let fetchRequest = makeObject(FavouriteCharacterCD.fetchRequest()) {
                $0.fetchLimit = 1
                $0.predicate = NSPredicate(format: "id = %i", character.id)
            }
            guard let characterCD = try ctx.fetch(fetchRequest).first else {
                throw DevError("No favourite character with id \(character.id).")
            }
            ctx.delete(characterCD)
            try ctx.save()
            self?.changesSubject.send(.init(character: character, action: .delete, sender: sender))
        }
    }
    func getCharacter(byId id: Int) async throws -> FavouritesCharactersService.Character? {
        try await manager.performOnBackgroundContext { [weak self] ctx in
            guard let self else {
                throw DevError("CoreDataFavouritesCharactersService is deinited.")
            }
            let request = makeObject(FavouriteCharacterCD.fetchRequest()) {
                $0.fetchLimit = 1
            }
            guard let character = try ctx.fetch(request).first else {
                return nil
            }
            return try map(character)
        }
    }
    // MARK: -
    private func map(_ character: FavouriteCharacterCD) throws ->  FavouritesCharactersService.Character {
        let id = character.id
        guard (Int64(Int.min) ... Int64(Int.max)).contains(id) else {
            throw DevError("Incorrect saved id \(id).")
        }
        guard let name = character.name else { throw DevError("Undefined name.") }
        guard let type = character.type else { throw DevError("Undefined type.") }
        guard let image = character.image else { throw DevError("Undefined image.") }
        return .init(id: Int(id), name: name, type: type, image: image)
    }
}
