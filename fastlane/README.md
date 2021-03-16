fastlane documentation
================
# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```
xcode-select --install
```

Install _fastlane_ using
```
[sudo] gem install fastlane -NV
```
or alternatively using `brew install fastlane`

# Available Actions
## iOS
### ios test
```
fastlane ios test
```
Build framework and run tests
### ios build_example
```
fastlane ios build_example
```
Build example app
### ios browserstack
```
fastlane ios browserstack
```
Upload binary to Browserstack
### ios ui_test
```
fastlane ios ui_test
```
Run UI tests
### ios develop_testflight
```
fastlane ios develop_testflight
```
Upload to TestFlight

----

This README.md is auto-generated and will be re-generated every time [fastlane](https://fastlane.tools) is run.
More information about fastlane can be found on [fastlane.tools](https://fastlane.tools).
The documentation of fastlane can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
