//
//  STPPinMap.m
//  iSouvenir
//
//  Created by Nanook on 10/06/2014.
//  Copyright (c) 2014 SaveThePlan. All rights reserved.
//

#import "STPPinMap.h"
#import "CLPlacemark+STPAddressString.h"

@interface STPPinMap() {
    BOOL hasPlacemark;
    BOOL hasContact;
}

@end

@implementation STPPinMap

-(id)initWithTitle:(NSString *)title andCoordinate:(CLLocationCoordinate2D)coordinate
{
    self = [self init];
    if(self) {
        [self setTitle:title];
        [self setCoordinate:coordinate];
        hasPlacemark = NO;
        hasContact = NO;
    }
    return self;
}

-(id)initWithPlacemark:(CLPlacemark *)placemark
{
    self = [self init];
    if(self){
        [self setPlacemark:placemark];
        hasContact = NO;
    }
    return self;
}



-(BOOL)contactIsNotEmpty {
    return hasContact;
}

/* ----- */
@synthesize title = _title;
-(void)setTitle:(NSString *)title {
    [_title release];
    _title = [title copy];
}
-(NSString *)title {
    if(hasPlacemark) {
        return [[[_placemark formatAddress] retain] autorelease];
    }
    return _title;
}

@synthesize subtitle = _subtitle;
-(void)setSubtitle:(NSString *)subtitle {
    [_subtitle release];
    _subtitle = [subtitle copy];
}
-(NSString *)subtitle {
    if(hasContact) {
        return [self contactFullName];
    }
    return _subtitle;
}

@synthesize coordinate = _coordinate;
-(void)setCoordinate:(CLLocationCoordinate2D)coordinate {
    _coordinate = coordinate;
}
-(CLLocationCoordinate2D)coordinate {
    if(hasPlacemark) {
        return [[_placemark location] coordinate];
    }
    return _coordinate;
}

@synthesize placemark = _placemark;
-(void)setPlacemark:(CLPlacemark *)placemark {
    if(placemark == nil) {
        [_placemark release]; _placemark = nil;
        hasPlacemark = NO;
        return;
    }
    _placemark = [placemark copy];
    hasPlacemark = YES;
}
-(CLPlacemark *)placemark {
    return _placemark;
}

@synthesize contact = _contact;
-(void)setContact:(ABRecordRef)contact {
    [self willChangeValueForKey:@"subtitle"];
    _contact = contact;
    hasContact = (_contact != nil);
    [self didChangeValueForKey:@"subtitle"];
}
-(ABRecordRef)contact {
    return _contact;
}

/* ----- */

-(NSString *)contactFullName
{
    NSMutableString * fullname = [[NSMutableString alloc] init];
    
    NSString * firstname = ((NSString *) ABRecordCopyValue(_contact, kABPersonFirstNameProperty));
    NSString * lastname = ((NSString *) ABRecordCopyValue(_contact, kABPersonLastNameProperty));
    
    if (firstname) {
        [fullname appendFormat:@"%@ ", firstname];
    }
    
    if (lastname) {
        [fullname appendString:lastname];
    }
    
    return [fullname autorelease];
}

-(NSString *)titleForSort
{
    if (hasPlacemark) {
        return [_placemark formatAddress];
    }
    
    return _title;
}




-(void)dealloc
{
    [_title release]; _title = nil;
    [_subtitle release]; _subtitle = nil;
    [_placemark release]; _placemark = nil;
    
    [super dealloc];
}

@end
