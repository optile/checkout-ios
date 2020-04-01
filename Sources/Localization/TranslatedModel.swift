import Foundation

class TranslatedModel<T> {
    let model: T
    let translator: TranslationProvider
    
    init(model: T, translator: TranslationProvider) {
        self.model = model
        self.translator = translator
    }
}
