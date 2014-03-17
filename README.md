SLFramework
============

Framework for boosting iOS application development. Contributions are more than welcome!

### SLModel

Provides the functionality to instantiate objects from dictionaries and serialize them back into them.

Here are some features that are included:

- Object composition including arrays of objects
- Automatic detection and handling for common property types including native data types
- Property name transformations

### SLFunctions

Collection of reusable functions.

- Easy object property introspection
- Retrieving kernel uptime

### SLTicker

Ticker for managing periodically occurring events.

- Supports ticking in the background by reading the kernel uptime

### SLLogger

Logging and debug functionality.

- Macros for wrapping NSLogs and support for logging into file

### NSString+SLFramework

Collection of useful methods on NSString.

- Digests using hashing functions (MD2, MD4, MD5, SHA1, SHA224, SHA256, SHA384, SHA512)
- Conversion to hexadecimal presentation
- Case conversions

### NSObject+SLFramework

Collection of useful methods on NSObject.

- Remove KVO observers without having to worry about it throwing an exception

### UIView+SLFramework

Collection of useful methods on UIView.

- Shorthands for settings and getting the frame

### UIColor+SLFramework

Collection of useful methods on UIColor.

- Converting colors to and from hexadecimal presentation
- Luminosity support
