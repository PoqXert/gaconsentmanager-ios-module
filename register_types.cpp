#include "register_types.h"
#include "ios/src/ConsentManager.h"
#include "core/class_db.h"
#include "core/engine.h"

void register_gaconsentmanager_types() {
    Engine::get_singleton()->add_singleton(Engine::Singleton("GAConsentManager", memnew(GAConsentManager)));
}

void unregister_gaconsentmanager_types() {
    
}
