# homebridge-plugin-trainshield

This is simple [homebridge](https://github.com/nfarina/homebridge) plugin for Wemos D1 with Train Controller.

First project target is to control a relay that powers the train itself. Future functions could involve input sensors, logic and some PWM or GPIO-3VTTL outputs.

Basic implementation covers only ON/OFF in /train/1 MQTT channel.

## Prerequisites

* ESPTool (to load LUA code to Wemos D1)
* ESP8266 with NodeMCU firmware (Legacy AI-THINKER used in this case, with USB-FTDI interface)
* Wemos Relay shield connected to pin D1<->GPIO2 (configurable) controlling the train power
* External (e.g. 0-20V AC) power supply for the model train
* Homebridge on local WiFi

## Installation

```
    git clone https://github.com/suculent/homebridge-plugin-trainshield.git
    cd homebridge-plugin-trainshield
    npm install -g .
```

Edit config.lua in the esp8266 folder with your wifi credentials and load all the lua files to your ESP8266 (using ESPTool).

Restart your Wemos. It should start listening to your MQTT channel. You can test it by sending `ON` or `OFF` to MQTT channel `/train/1` with default configuration.

Edit your Homebridge configuration based on sample-config.json file.

Restart your homebridge and add the new device.
