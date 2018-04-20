The Blue Alliance - iOS App
=====================

An iOS app for accessing information about the FIRST Robotics Competition.

Setup
-----
1. Install all [React Native](https://facebook.github.io/react-native) dependencies
	* `brew install node watchman`
	* `npm install -g react-native-cli`
	* `cd js && npm install && cd ..`
2. Install [Cocoapods](http://guides.cocoapods.org/using/getting-started.html#getting-started) to install package dependencies
	* `sudo gem install cocoapods`
	* `pod install`
	* Open the project (`the-blue-alliance-ios.xcworkspace`)
3. (Optional) Run the React Native server
	* `cd js && react-native start`
	* To view RN logs, `react-native log-ios`
4. Build and run The Blue Alliance for iOS in Xcode!

Generating Swagger code for TBA API
----
If you want to bump the version of the API code we're using in TBA for iOS, you'll have to regenerate the wrapper. Be careful - bumping the generated code version could have side effects. Do this with caution.

1. [install `swagger-codegen`](https://github.com/swagger-api/swagger-codegen)
	* ` brew install swagger-codegen`
2. Generate the new library
	* `swagger-codegen generate -i https://www.thebluealliance.com/swagger/api_v3.json -l swift4 -c swagger-codegen/swagger-codegen.config.json --model-name-prefix TBA -o swagger-codegen`
3. Install the new library
	* `pod install`
4. We don't yet have MatchTimeseries or EventInsights working - you'll have to comment those methods out in the development pod in order to get TBA for iOS building

Shipping
-----
1. Be sure to compile a local React Native bundle to be used offline

```
$ cd js
$ react-native bundle --platform ios --dev false --entry-file index.ios.js --bundle-output ../the-blue-alliance-ios/React\ Native/main.jsbundle --assets-dest ../the-blue-alliance-ios/React\ Native/
```
