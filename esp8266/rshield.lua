dofile("config.lua")

mqttBroker = mqtt_broker 
mqttUser = "none"
mqttPass = "none"
mqttChannel = "/train/1"
deviceID=node.chipid() 
wifi.setmode(wifi.STATION)
wifi.sta.config (wifi_ssid, wifi_password)

-- Pin which the train is connected to
trainPin = 4 -- GPIO2 on AI-THINKER
gpio.mode(trainPin, gpio.OUTPUT)
gpio.write(trainPin, gpio.LOW) 
 
-- MQTT led
mqttLed = 3 -- next one (LED on AI-THINKER)
gpio.mode(mqttLed, gpio.OUTPUT)
gpio.write(mqttLed, gpio.LOW)

m = mqtt.Client("TrainShield-" .. deviceID, 180, mqttUser, mqttPass)
m:lwt("/lwt", "TrainShield " .. deviceID, 0, 0)
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
            mqtt_sub()
        end)
    end
 end)
