import Foundation

/// Service responsible for localization file downloads and model localizations
final class DownloadTranslationService {
    private let networks: [ApplicableNetwork]
    private let accounts: [AccountRegistration]
    private let sharedTranslationProvider: TranslationProvider
    
    private let localizationQueue = OperationQueue()
    
    private var downloadNetworkOperations = [DownloadTranslationOperation<ApplicableNetwork>]()
    private var downloadAccountsOperations = [DownloadTranslationOperation<AccountRegistration>]()
    
    // MARK: Output
    
    class Translations {
        fileprivate(set) var networks: [TranslatedModel<ApplicableNetwork>] = .init()
        fileprivate(set) var accounts: [TranslatedModel<AccountRegistration>] = .init()
    }
    
    init(networks: [ApplicableNetwork], accounts: [AccountRegistration], sharedTranslation: SharedTranslationProvider) {
        self.networks = networks
        self.accounts = accounts
        self.sharedTranslationProvider = sharedTranslation
    }
    
    func localize(using connection: Connection, completion: @escaping (Result<Translations, Error>) -> Void) {
        // We should never call that method twice but we need to protect from that situation
        localizationQueue.cancelAllOperations()
        downloadNetworkOperations = .init()
        downloadAccountsOperations = .init()

        // That operation is called after all localizations were downloaded
        let completionOperation = BlockOperation { [makeTranslatedModels] in
            do {
                let translations = try makeTranslatedModels()
                completion(.success(translations))
            } catch {
                completion(.failure(error))
            }
        }
                
        do {
            // Download translations for each network
            for network in networks {
                let downloadTranslation = try DownloadTranslationOperation(for: network, using: connection)
                downloadNetworkOperations.append(downloadTranslation)
                
                completionOperation.addDependency(downloadTranslation)
                localizationQueue.addOperation(downloadTranslation)
            }
            
            // Download translation for each registered account
            for account in accounts {
                let downloadTranslation = try DownloadTranslationOperation(for: account, using: connection)
                downloadAccountsOperations.append(downloadTranslation)
                
                completionOperation.addDependency(downloadTranslation)
                localizationQueue.addOperation(downloadTranslation)
            }
        } catch {
            localizationQueue.cancelAllOperations()
            completion(.failure(error))
            return
        }
        
        localizationQueue.addOperation(completionOperation)
    }
    
    /// Create `Translations` object with models and translators to return it as class' outupt
    private func makeTranslatedModels() throws -> Translations {
        let translations = Translations()

        for operation in downloadNetworkOperations {
            switch operation.result {
            case .some(.success(let translation)):
                let combinedProvider = CombinedTranslationProvider(priorityTranslation: translation, otherProvider: sharedTranslationProvider)
                let translatedNetwork = TranslatedModel(model: operation.model, translator: combinedProvider)
                translations.networks.append(translatedNetwork)
            case .some(.failure(let error)):
                // If translation wasn't downloaded don't proceed anymore, throw an error and exit
                throw error
            case .none:
                // Should never happen, but if...
                throw InternalError(description: "Download localization operation wasn't completed")
            }
        }
        
        for operation in downloadAccountsOperations {
            switch operation.result {
            case .some(.success(let translation)):
                let combinedProvider = CombinedTranslationProvider(priorityTranslation: translation, otherProvider: sharedTranslationProvider)
                let translatedAccount = TranslatedModel(model: operation.model, translator: combinedProvider)
                translations.accounts.append(translatedAccount)
            case .some(.failure(let error)):
                // If translation wasn't downloaded don't proceed anymore, throw an error and exit
                throw error
            case .none:
                // Should never happen, but if...
                throw InternalError(description: "Download localization operation wasn't completed")
            }
        }
        
        return translations
    }
}

// MARK: - DownloadTranslationOperation

private class DownloadTranslationOperation<T>: SendRequestOperation<DownloadLocalization> where T: Network {
    let model: T
     
    init(for model: T, using connection: Connection) throws {
        guard let localizationURL = model.localizationURL else {
            throw InternalError(description: "Model doesn't contain a localization URL. Model: %@", objects: model)
        }
        
        self.model = model
        
        let downloadRequest = DownloadLocalization(from: localizationURL)
        super.init(connection: connection, request: downloadRequest)
    }
 }

private protocol Network {
    var code: String { get }
    var localizationURL: URL? { get }
}

extension ApplicableNetwork: Network {
    var localizationURL: URL? { self.links?["lang"] }
}

extension AccountRegistration: Network {
    var localizationURL: URL? { self.links["lang"] }
}
