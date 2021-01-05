//
//  ConsentManager.h
//
//
//  Created by Poq Xert on 04.10.2020.
//

#ifndef ConsentManager_h
#define ConsentManager_h

#include "core/object.h"
#include "core/dictionary.h"

class GAConsentManager : public Object {
    GDCLASS(GAConsentManager, Object);
    
    static void _bind_methods();
    
public:
    GAConsentManager();
    ~GAConsentManager();
    
    void synchronize(const String &appKey);
    void synchronizeWithParams(const String &appKey, Dictionary params);
    bool shouldShowConsentDialog();
    void loadConsentDialog();
    bool isConsentDialogReady();
    void showConsentDialog();
    bool isConsentDialogPresenting();
    int getRegulation();
    int getStatus();
    bool getConsent();
    String getIABConsentString();
    bool hasConsentForVendor(const String &bundle);
    void enableIABStorage();
};

#endif /* ConsentManager_h */
