//
//  NSError+Localization.m
//  BOW
//
//  Created by A101 on 7/21/16.
//  Copyright © 2016 A101. All rights reserved.
//

#import "NSError+Localization.h"

@implementation NSError (Localization)

- (NSString *)localizedCodeDescription {
	switch (self.code) {
		case NSURLErrorUnknown:
			return @"Unknown error.";
			break;
			
		case NSURLErrorCancelled:
			return @"Request is cancelled.";
			break;
			
		case NSURLErrorBadURL:
			return @"Bad URL.";
			break;
			
		case NSURLErrorTimedOut:
			return @"Request timed out.";
			break;
			
		case NSURLErrorUnsupportedURL:
			return @"Unsupported URL.";
			break;
			
		case NSURLErrorCannotConnectToHost:
			return @"Cannot connect to host.";
			break;
			
		case NSURLErrorNetworkConnectionLost:
			return @"Network connection is lost.";
			break;
			
		case NSURLErrorDNSLookupFailed:
			return @"Failed to lookup DNS.";
			break;
			
		case NSURLErrorHTTPTooManyRedirects:
			return @"HTTP too many redirects.";
			break;
			
		case NSURLErrorResourceUnavailable:
			return @"Resource is unavailable";
			break;
			
		case NSURLErrorNotConnectedToInternet:
			return @"No internet connection.";
			break;
			
		case NSURLErrorRedirectToNonExistentLocation:
			return @"Redirect to non existent location";
			break;
			
		case NSURLErrorBadServerResponse:
			return @"Bad server response.";
			break;
			
		case NSURLErrorUserCancelledAuthentication:
			return @"Authentication is cancelled.";
			break;
			
		case NSURLErrorUserAuthenticationRequired:
			return @"Authentication is required.";
			break;
			
		case NSURLErrorZeroByteResource:
			return @"Zero byte resource";
			break;
			
		case NSURLErrorCannotDecodeRawData:
			return @"Cannot decode raw data.";
			break;
			
		case NSURLErrorCannotDecodeContentData:
			return @"Cannot decode content data.";
			break;
			
		case NSURLErrorCannotParseResponse:
			return @"Cannot parse response.";
			break;
			
		case NSURLErrorFileDoesNotExist:
			return @"File does not exist.";
			break;
			
		case NSURLErrorFileIsDirectory:
			return @"File is directory.";
			break;
			
		case NSURLErrorNoPermissionsToReadFile:
			return @"No permission to read file.";
			break;
			
		case NSURLErrorDataLengthExceedsMaximum:
			return @"Data length exceeds maximum.";
			break;
			
		case NSURLErrorSecureConnectionFailed:
			return @"Failed to secure connection.";
			break;
			
		case NSURLErrorServerCertificateHasBadDate:
			return @"Server certificate has bad date.";
			break;
			
		case NSURLErrorServerCertificateUntrusted:
			return @"Untrusted server certificate.";
			break;
			
		case NSURLErrorServerCertificateHasUnknownRoot:
			return @"Server certificate has unknown root.";
			break;
			
		case NSURLErrorServerCertificateNotYetValid:
			return @"Invalid server certificate.";
			break;
			
		case NSURLErrorClientCertificateRejected:
			return @"Client certificate is rejected.";
			break;
			
		case NSURLErrorClientCertificateRequired:
			return @"Client certificate is required.";
			break;
			
		case NSURLErrorCannotLoadFromNetwork:
			return @"Cannot load from network.";
			break;
			
		case NSURLErrorInternationalRoamingOff:
			return @"International roaming is off.";
			break;
			
		case NSURLErrorCallIsActive:
			return @"Call is active.";
			break;
			
		case NSURLErrorDataNotAllowed:
			return @"Data is not allowed.";
			break;
			
		case NSURLErrorRequestBodyStreamExhausted:
			return @"Request body stream is exhausted.";
			break;
			
		default:
			return [NSString stringWithFormat:@"Request failed with error code %li", (long)self.code];
			break;
	}
}

@end
