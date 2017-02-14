dofile("config.lua")

mqttBroker = mqtt_broker 
mqttUser = "none"
mqttPass = "none"
mqttChannel = "/train/1"
deviceID=node.chipid() 
wifi.setmode(wifi.STATION)
wifi.sta.config (wifi_ssid, wifi_password)

-- AI-THINKER:
-- RST      | TXD
-- ADC      | RXD
-- GPIO 16  | GPIO 4
-- GPIO 14  | GPIO 5
-- GPIO 12  | GPIO 0
-- GPIO 13  | GPIO 15
-- VCC      | GND

-- Pin which the train is connected to
trainPin = 4 -- GPIO?
gpio.mode(trainPin, gpio.OUTPUT)
gpio.write(trainPin, gpio.LOW) 
 
-- MQTT led
mqttLed = 3 -- next one (LED on AI-THINKER, probably GPIO4)
gpio.mode(mqttLed, gpio.OUTPUT)
gpio.write(mqttLed, gpio.LOW)

m = mqtt.Client("TrainShield-" .. deviceID, 180, mqttUser, mqttPass)
m:lwt("/lwt", "TrainShield " .. deviceID .. "goodbye.", 0, 0)
m:on("offline", function(con)
    ip = wifi.sta.getip()
    print ("MQTT reconnecting to " .. mqttBroker .. " from " .. ip)
    tmr.alarm(1, 10000, 0, function()
        node.restart();
    end)
end)

function mqtt_update()
    if (gpio.read(trainPin) == 0) then
        m:publish(mqttChannel .. "/state","OFF",0,0)
    else
        m:publish(mqttChannel .. "/state","ON",0,0)
    end
end
  
m:on("message", function(conn, topic, data)
    pwm.stop(mqttLed)
    print("Recieved:" .. topic .. ":" .. data)
    if (data=="ON") then
        print("Enabling Output")
        gpio.write(trainPin, gpio.HIGH)
        gpio.write(mqttLed, gpio.LOW)
    elseif (data=="OFF") then
        print("Disabling Output")                 
        gpio.write(trainPin, gpio.LOW)
        gpio.write(mqttLed, gpio.HIGH)
    else
        print("Invalid command (" .. data .. ")")
    end
    mqtt_update()
end)

function mqtt_sub()
    m:subscribe(mqttChannel,0, function(conn)
        print("MQTT subscribed to " .. mqttChannel)
        pwm.setup(mqttLed, 1, 512)
        pwm.start(mqttLed)
    end)    
end

tmr.alarm(0, 1000, 1, function()
    if wifi.sta.status() == 5 and wifi.sta.getip() ~= nil then  
        tmr.stop(0)
        m:connect(mqttBroker, 1883, 0, function(conn)
            gpio.write(mqttLed, gpio.LOW)
            print("MQTT connected to:" .. mqttBroker)
            m:publish("/home","Train Shield at " .. wifi.sta.getip() .. " listening to channel " .. mqttChannel,0,0)
            mqtt_sub()
        end)
    end
 end)
