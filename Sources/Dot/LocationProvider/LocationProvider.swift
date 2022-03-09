//
//  LocationProvider.swift
//  Dot
//
//  Created by Alex Nagy on 10.08.2021.
//

import Foundation
import CoreLocation
import Combine

#if !os(macOS)
import UIKit
#endif

#if os(iOS)
public let defaultCLAuthorizationStatus = CLAuthorizationStatus.authorizedWhenInUse
#else
public let defaultCLAuthorizationStatus = CLAuthorizationStatus.authorizedAlways
#endif

#if os(iOS)
public let allowedCLAuthorizationStatuses : Set<CLAuthorizationStatus> = Set([.authorizedWhenInUse, .authorizedAlways])
#elseif os(macOS)
public let allowedCLAuthorizationStatuses : Set<CLAuthorizationStatus> = Set([.authorized, .authorizedAlways])
#endif

/**
 A Combine-based CoreLocation provider.
 
 On every update of the device location from a wrapped `CLLocationManager`,
 it provides the latest location as a published `CLLocation` object and
 via a `PassthroughSubject<CLLocation, Never>` called `locationWillChange`.
 */

public class LocationProvider: NSObject, ObservableObject {
    
    public let lm = CLLocationManager()
    
    /// Is emitted when the `location` property changes.
    public let locationWillChange = PassthroughSubject<CLLocation, Never>()
    
    /**
     The latest location provided by the `CLLocationManager`.
     
     Updates of its value trigger both the `objectWillChange` and the `locationWillChange` PassthroughSubjects.
     */
    @Published public private(set) var location: CLLocation? {
        willSet {
            locationWillChange.send(newValue ?? CLLocation())
        }
    }
    
    /// The authorization status for CoreLocation.
    @Published public var authorizationStatus: CLAuthorizationStatus?
    

    /// A function that is executed when the `CLAuthorizationStatus` changes to `Denied`.
    public var onAuthorizationStatusDenied: () -> Void
    
    public var monitorsSignificantLocationChanges: Bool
    
    public var shouldLogLocationUpdates: Bool
    
    public var status: CLAuthorizationStatus = defaultCLAuthorizationStatus
    
    /// The LocationProvider intializer.
    ///
    /// Creates a CLLocationManager delegate and sets the CLLocationManager properties.
    public init(desiredAccuracy: CLLocationAccuracy = kCLLocationAccuracyBest,
                activityType: CLActivityType = .fitness,
                distanceFilter: CLLocationDistance = 10,
                allowsBackgroundLocationUpdates: Bool = false,
                pausesLocationUpdatesAutomatically: Bool = true,
                showsBackgroundLocationIndicator: Bool = false,
                monitorsSignificantLocationChanges: Bool = false,
                shouldLogLocationUpdates: Bool = false,
                onAuthorizationStatusDenied: @escaping () -> Void = { }) {
        self.shouldLogLocationUpdates = shouldLogLocationUpdates
        self.monitorsSignificantLocationChanges = monitorsSignificantLocationChanges
        self.onAuthorizationStatusDenied = onAuthorizationStatusDenied
        
        super.init()
        
        self.lm.delegate = self
        
        self.lm.desiredAccuracy = desiredAccuracy
        self.lm.activityType = activityType
        self.lm.distanceFilter = distanceFilter
        self.lm.allowsBackgroundLocationUpdates = allowsBackgroundLocationUpdates
        self.lm.pausesLocationUpdatesAutomatically = pausesLocationUpdatesAutomatically
        #if os(iOS)
        self.lm.showsBackgroundLocationIndicator = showsBackgroundLocationIndicator
        #endif
        if self.monitorsSignificantLocationChanges {
            self.lm.pausesLocationUpdatesAutomatically = true
            self.lm.startMonitoringSignificantLocationChanges()
        }
    }
    
    deinit {
        if self.monitorsSignificantLocationChanges {
            self.lm.stopMonitoringSignificantLocationChanges()
        }
    }
    
    /**
     Request location access from user.
     
     Per default, `authorizedWhenInUse` is requested.
     In case, the access has already been denied, execute the `onAuthorizationDenied` closure.
     The default behavior is to present an alert that suggests going to the settings page.
     */
    public func requestAuthorization(status: CLAuthorizationStatus) -> Void {
        if self.authorizationStatus == CLAuthorizationStatus.denied {
            onAuthorizationStatusDenied()
        }
        else {
            switch status {
            case .authorizedWhenInUse:
                self.lm.requestWhenInUseAuthorization()
            case .authorizedAlways:
                self.lm.requestAlwaysAuthorization()
            default:
                print("WARNING: Only `when in use` and `always` types can be requested.")
            }
        }
    }
    
    /// Start the Location Provider.
    public func start(status: CLAuthorizationStatus = defaultCLAuthorizationStatus) throws -> Void {
        self.status = status
        self.requestAuthorization(status: status)
        
        if let status = self.authorizationStatus {
            guard allowedCLAuthorizationStatuses.contains(status) else {
                throw LocationProviderError.noAuthorization
            }
        }
        else {
            /// no authorization set by delegate yet
            #if DEBUG
            print(#function, "WARNING: No location authorization status set by delegate yet. Try to start updates anyhow.")
            #endif
            /// In principle, this should throw an error.
            /// However, this would prevent start() from running directly after the LocationProvider is initialized.
            /// This is because the delegate method `didChangeAuthorization`,
            /// setting `authorizationStatus` runs only after a brief delay after initialization.
            //throw LocationProviderError.noAuthorization
        }
        self.lm.startUpdatingLocation()
    }
    
    /// Stop the Location Provider.
    public func stop() -> Void {
        self.lm.stopUpdatingLocation()
    }
    
}

/// Error which is thrown for lacking localization authorization.
public enum LocationProviderError: Error {
    case noAuthorization
}

extension LocationProvider: CLLocationManagerDelegate {
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.authorizationStatus = status
        #if DEBUG
        print(#function, status.name)
        #endif
    }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.location = location
        if shouldLogLocationUpdates {
            print(location)
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if let clErr = error as? CLError {
            switch clErr {
            case CLError.denied : do {
                print(#function, "Location access denied by user.")
                self.stop()
                self.requestAuthorization(status: self.status)
            }
            case CLError.locationUnknown : print(#function, "Location manager is unable to retrieve a location.")
            default: print(#function, "Location manager failed with unknown CoreLocation error.")
            }
        }
        else {
            print(#function, "Location manager failed with unknown error", error.localizedDescription)
        }
    }
}

extension CLAuthorizationStatus {
    /// String representation of the CLAuthorizationStatus
    var name: String {
        switch self {
        case .notDetermined: return "notDetermined"
        case .authorizedWhenInUse: return "authorizedWhenInUse"
        case .authorizedAlways: return "authorizedAlways"
        case .restricted: return "restricted"
        case .denied: return "denied"
        default: return "unknown"
        }
    }
}



