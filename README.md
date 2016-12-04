# homebridge-plugin-rshield

This is simple [homebridge](https://github.com/nfarina/homebridge) plugin for Wemos D1 with single Relay Shield.

## Prerequisites

* ESPTool (to load LUA code to Wemos D1)
* Wemos D1 with NodeMCU firmware
* Wemos Relay shield or any other relay conencted to pin D1 (configurable)
* Homebridge on local WiFi

## Installation

```
    git clone https://github.com/suculent/homebridge-plugin-rshield.git
    cd homebridge-plugin-rshield
    npm install -g .
```

Edit config.lua in the esp8266 folder with your wifi credentials and load all the lua files to your Wemos D1 ESP8266 (using ESPTool).

Restart your Wemos. It should start listening to your MQTT channel. You can test it by sending `ON` or `OFF` to MQTT channel `/relay/1` with default configuration.

Edit your Homebridge configuration based on sample-config.json file.

Restart your homebridge and add the new device.
