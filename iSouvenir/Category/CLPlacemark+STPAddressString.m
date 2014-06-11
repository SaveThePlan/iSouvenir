//
//  CLPlacemark+STPAddressString.m
//  iSouvenir
//
//  Created by Nanook on 11/06/2014.
//  Copyright (c) 2014 SaveThePlan. All rights reserved.
//

#import "CLPlacemark+STPAddressString.h"


@implementation CLPlacemark (STPAddressString)

-(NSString *)formatAddress {
    NSMutableString * titleMaker = [[NSMutableString alloc] init];
    /*
     placemark addressDictionary keys :
     Name,
     Street, ZIP, City,
     Country, CountryCode,
     FormattedAddressLines,
     State, SubAdministrativeArea, SubLocality, Thoroughfare
     */
    NSString * street = [[[self addressDictionary] valueForKey:@"Street"] retain];
    NSString * zip = [[[self addressDictionary] valueForKey:@"Zip"] retain];
    NSString * city = [[[self addressDictionary] valueForKey:@"City"] retain];
    NSString * country = [[[self addressDictionary] valueForKey:@"Country"] retain];
    
    if(street) {
        [titleMaker appendString:street];
        if(zip || city) {
            [titleMaker appendString:@", "];
        }
    }
    if(zip) {
        [titleMaker appendString:zip];
    }
    if(city) {
        if(zip) {
            [titleMaker appendString:@" "];
        }
        [titleMaker appendString:city];
    }
    if(country) {
        if(street || zip || city) {
            [titleMaker appendString:@" - "];
        }
        [titleMaker appendString:country];
    }
    
    [street release]; street = nil;
    [zip release]; zip = nil;
    [city release]; city = nil;
    [country release]; country = nil;
    
    return [titleMaker autorelease];
}

@end
