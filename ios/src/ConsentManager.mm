//
//  ConsentManager.mm
//  
//
//  Created by Poq Xert on 04.10.2020.
//

#include "ConsentManager.h"
#import <StackConsentManager/StackConsentManager.h>
#include "helper.h"

static GAConsentManager *gaConsentManagerInstance = NULL;

@interface GAConsentManagerDialog : NSObject<STKConsentManagerDisplayDelegate>

- (void)consentManagerWillShowDialog:(STKConsentManager *)consentManager;
- (void)consentManager:(STKConsentManager *)consentManager didFailToPresent:(NSError *)error;
- (void)consentManagerDidDismissDialog:(STKConsentManager *)consentManager;

@end

@implementation GAConsentManagerDialog

- (void)consentManagerWillShowDialog:(STKConsentManager *)consentManager {
    gaConsentManagerInstance->emit_signal("dialog_shown");
}

- (void)consentManager:(STKConsentManager *)consentManager didFailToPresent:(NSError *)error {
    gaConsentManagerInstance->emit_signal("dialog_failed");
}

- (void)consentManagerDidDismissDialog:(STKConsentManager *)consentManager {
    gaConsentManagerInstance->emit_signal("dialog_closed");
}

@end

GAConsentManager::GAConsentManager() {
    gaConsentManagerInstance = this;
}

GAConsentManager::~GAConsentManager() {
    
}

void GAConsentManager::synchronize(const String &appKey) {
    NSString *nsAppKey = (NSString *)variantToNSObject(appKey);
    [[STKConsentManager sharedManager] synchronizeWithAppKey:nsAppKey completion:^(NSError *error) {
        if (error) {
            gaConsentManagerInstance->emit_signal("synchronization_failed", nsobjectToVariant([error localizedDescription]));
            return;
        }
        gaConsentManagerInstance->emit_signal("synchronized");
    }];
}

void GAConsentManager::synchronizeWithParams(const String &appKey, Dictionary params) {
    NSString *nsAppKey = (NSString *)variantToNSObject(appKey);
    NSDictionary *nsParams = dictionaryToNSDictionary(params);
    [[STKConsentManager sharedManager] synchronizeWithAppKey:nsAppKey customParameters:nsParams completion:^(NSError *error) {
        if (error) {
            NSLog(@"GA SYNC ERROR: %@", error);
            return;
        }
        emit_signal("synchronized");
    }];
}

bool GAConsentManager::shouldShowConsentDialog() {
    return [[STKConsentManager sharedManager] shouldShowConsentDialog] == STKConsentBoolTrue;
}

void GAConsentManager::loadConsentDialog() {
    [[STKConsentManager sharedManager] loadConsentDialog:^(NSError *error) {
        if (error) {
            NSLog(@"GA LOAD DIALOG ERROR: %@", error);
            return;
        }
        emit_signal("dialog_loaded");
    }];
}

bool GAConsentManager::isConsentDialogReady() {
    return [[STKConsentManager sharedManager] isConsentDialogReady];
}

void GAConsentManager::showConsentDialog() {
    UIViewController *vc = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    [[STKConsentManager sharedManager] showConsentDialogFromRootViewController:vc delegate:[[GAConsentManagerDialog alloc] init]];
}

bool GAConsentManager::isConsentDialogPresenting() {
    return [[STKConsentManager sharedManager] isConsentDialogPresenting];
}

int GAConsentManager::getRegulation() {
    STKConsentRegulation regulation = [[STKConsentManager sharedManager] regulation];
    switch (regulation) {
        case STKConsentRegulationNone:
            return 1;
        case STKConsentRegulationGDPR:
            return 2;
        case STKConsentRegulationCCPA:
            return 3;
        default:
            return 0;
    }
}

int GAConsentManager::getStatus() {
    STKConsentStatus status = [[STKConsentManager sharedManager] consentStatus];
    switch (status) {
        case STKConsentStatusNonPersonalized:
            return 1;
        case STKConsentStatusPartlyPersonalized:
            return 2;
        case STKConsentStatusPersonalized:
            return 3;
        default:
            return 0;
    }
}

bool GAConsentManager::getConsent() {
    return getStatus() != 1;
}

String GAConsentManager::getIABConsentString() {
    NSString *str;
    if ([[STKConsentManager sharedManager] regulation] == STKConsentRegulationCCPA) {
        str = [[STKConsentManager sharedManager] iabUSPrivacyString];
    } else {
        str = [[STKConsentManager sharedManager] iabConsentString];
    }
    return (String)nsobjectToVariant(str);
}

bool GAConsentManager::hasConsentForVendor(const String &bundle) {
    return [[STKConsentManager sharedManager] hasConsentForVendorBundle:(NSString *)variantToNSObject(bundle)] == STKConsentBoolTrue;
}

void GAConsentManager::enableIABStorage() {
    STKConsentManager.sharedManager.storage = STKConsentDialogStorageUserDefaults;
}

void GAConsentManager::_bind_methods() {
    ClassDB::bind_method(D_METHOD("synchronize", "app_key"), &GAConsentManager::synchronize);
    ClassDB::bind_method(D_METHOD("synchronizeWithParams", "app_key", "params"), &GAConsentManager::synchronizeWithParams);
    ClassDB::bind_method(D_METHOD("shouldShowConsentDialog"), &GAConsentManager::shouldShowConsentDialog);
    ClassDB::bind_method(D_METHOD("loadConsentDialog"), &GAConsentManager::loadConsentDialog);
    ClassDB::bind_method(D_METHOD("isConsentDialogReady"), &GAConsentManager::isConsentDialogReady);
    ClassDB::bind_method(D_METHOD("showConsentDialog"), &GAConsentManager::showConsentDialog);
    ClassDB::bind_method(D_METHOD("isConsentDialogPresenting"), &GAConsentManager::isConsentDialogPresenting);
    ClassDB::bind_method(D_METHOD("getRegulation"), &GAConsentManager::getRegulation);
    ClassDB::bind_method(D_METHOD("getStatus"), &GAConsentManager::getStatus);
    ClassDB::bind_method(D_METHOD("getConsent"), &GAConsentManager::getConsent);
    ClassDB::bind_method(D_METHOD("getIABConsentString"), &GAConsentManager::getIABConsentString);
    ClassDB::bind_method(D_METHOD("hasConsentForVendor", "bundle"), &GAConsentManager::hasConsentForVendor);
    ClassDB::bind_method(D_METHOD("enableIABStorage"), &GAConsentManager::enableIABStorage);
    
    ADD_SIGNAL(MethodInfo("synchronized"));
    ADD_SIGNAL(MethodInfo("synchronization_failed"));
    ADD_SIGNAL(MethodInfo("dialog_loaded"));
    ADD_SIGNAL(MethodInfo("dialog_shown"));
    ADD_SIGNAL(MethodInfo("dialog_failed"));
    ADD_SIGNAL(MethodInfo("dialog_closed"));
}
