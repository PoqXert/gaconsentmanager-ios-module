//
//  helper.h
//  
//
//  Created by Poq Xert on 13.07.2020.
//

#ifndef helper_h
#define helper_h

#include "core/object.h"
#import <Foundation/Foundation.h>

Variant nsobjectToVariant(NSObject *object);

NSObject *variantToNSObject(Variant v);

Dictionary nsdictionaryToDictionary(NSDictionary *dict);

NSDictionary *dictionaryToNSDictionary(Dictionary dict);

Array nsarrayToArray(NSArray *arr);

NSArray *arrayToNSArray(Array arr);

#endif /* helper_h */
