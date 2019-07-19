# homebridge-plugin-trainshield

[![Greenkeeper badge](https://badges.greenkeeper.io/suculent/homebridge-plugin-trainshield.svg)](https://greenkeeper.io/)

This is simple [homebridge](https://github.com/nfarina/homebridge) plugin for ESP8266 as a Model Train Controller.

First project target is to control a relay that powers the train itself. Future functions could involve input sensors, logic and some PWM or GPIO-3VTTL outputs.

Basic implementation covers only ON/OFF in /train/1 MQTT channel.

## Prerequisites

* ESPTool (to load LUA code for ESP8266)
* ESP8266 with NodeMCU firmware (Legacy AI-THINKER used in this case, with USB-FTDI interface)
* (Wemos) Relay shield connected to pin D1<->GPIO2 (configurable) controlling the train power
* 220V/5VDC converter to power the ESP and Relay
* External (e.g. 0-20V AC) power supply for the model train (switched using the relay)
* MQTT Server and Homebridge on local WiFi

## Installation

```
    git clone https://github.com/suculent/homebridge-plugin-trainshield.git
    cd homebridge-plugin-trainshield
    npm install -g .
```

Edit config.lua in the esp8266 folder with your wifi credentials and load all the lua files to your ESP8266 (using ESPTool).

Restart your ESP. It should start listening to your MQTT channel. You can test it by sending `ON` or `OFF` to MQTT channel `/train/1` with default configuration.

Edit your Homebridge configuration based on sample-config.json file.

Restart your homebridge and add the new device.
