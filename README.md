# README

#### This application provides weather forecast information based on the input of a zipcode.

1. Accepts an address, including zip code, as input.

2. Displays the weather forecast for the given zip code.

example
```
Country	DZ
City	Mesmoulata
Temperature	11.04 C
Maximum temperature	11.04 C
Minimum temperature	11.04 C
Humidity	83 C
Pressure	1015 C
Cached	Result pulled from API.

```

3. It also caches the forecast for 30 minutes for all subsequent requests by zip codes.

4. Displays text to indicate if the result is pulled from the cache.

##### Notes

- App is using the gem `open-weather-ruby-client` which in turn uses `openweathermap API`
- App is built in such a way that the client library can be changed and respective classes can be added as per the need without changing much code in main controller/service classes
- Due to time constraint, could not cover all the rspec test cases  


* Ruby version - 3.0.5
* Rails version - 7.1.3
* This app is no database app

##### Instruction to run the app

* Install ruby 3.0.5
* clone this repository
* Install bundle
* Run the app using `rails s`
* Server will start on `localhost:3000`



##### How to run the test suite
  * run `rspec` on project directory
