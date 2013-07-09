#!/usr/bin/env ruby

require 'singleton'
require 'xmlrpc/client'
require 'rainbow'


class HCHomeControl
    include Singleton

    attr_accessor :actors

    CCUIP          = '0.0.0.0'
    # BidCos-Wired = 2000, BidCos-RF = 2001, Internal = 2002
    CCUWIREDPORT   = 2000
    CCURFPORT      = 2001

    HCRANGEDEVICE  = :HCRangeDevice
    HCBINARYDEVICE = :HCBinaryDevice

    HCWIREDBUS     = :HCWiredBus
    HCRFBUS        = :HCRfBus


    def initialize
        # connect to server (CCU)
        @wiredServer = XMLRPC::Client.new(CCUIP, '/', CCUWIREDPORT)
        @rfServer    = XMLRPC::Client.new(CCUIP, '/', CCURFPORT)

        # clear actors
        @actors = {}
    end


    def setValues(newSetting)
        newSetting.each do |deviceKey, value|
            if !@actors.has_key?(deviceKey) then next end
            deviceServer = (@actors[deviceKey][:bustype] == HCRFBUS) ? @rfServer : @wiredServer
            if @actors[deviceKey][:devicetype] == HCBINARYDEVICE
                deviceServer.call('setValue', @actors[deviceKey][:adress], 'STATE', value.to_i.to_s)
            elsif @actors[deviceKey][:devicetype] == HCRANGEDEVICE
                deviceServer.call('setValue', @actors[deviceKey][:adress], 'LEVEL', value.to_f.to_s)
            end
        end
    end


    def setValue(deviceKey, value=nil)
        if !@actors.has_key?(deviceKey.to_sym) then return end
        deviceServer = (@actors[deviceKey.to_sym][:bustype] == HCRFBUS) ? @rfServer : @wiredServer
        if @actors[deviceKey.to_sym][:devicetype] == HCBINARYDEVICE
            if value == nil
                newValue = deviceServer.call('getValue', @actors[deviceKey.to_sym][:adress], 'STATE') ? 0 : 1
            else
                newValue = value.to_i
            end
            deviceServer.call('setValue', @actors[deviceKey.to_sym][:adress], 'STATE', (newValue==1 ? '1' : '0'))
        elsif @actors[deviceKey.to_sym][:devicetype] == HCRANGEDEVICE
            if value == nil
                newValue = deviceServer.call('getValue', @actors[deviceKey.to_sym][:adress], 'LEVEL') > 0 ? 0.0 : 1.0
            else
                newValue = (value.to_i >= 0 || value.to_i <= 100) ? (value.to_f / 100) : 0.0
            end
            deviceServer.call('setValue', @actors[deviceKey.to_sym][:adress], 'LEVEL', newValue.to_s)
        end
    end


    def getValues
        result = {}
        actors.each do |deviceKey, device|
            currentValue = nil
            deviceServer = (device[:bustype] == HCRFBUS) ? @rfServer : @wiredServer
            if device[:devicetype] == HCBINARYDEVICE
                currentValue = deviceServer.call('getValue', device[:adress], 'STATE') ? 1 : 0
            elsif device[:devicetype] == HCRANGEDEVICE
                currentValue = deviceServer.call('getValue', device[:adress], 'LEVEL')
            end
            result[deviceKey.to_sym] = currentValue
        end
        result
    end
end



HCHomeControl.instance.actors = 
         {:bedroom1 => {:adress => 'IEQ0XXXXXX:XX', :bustype => HCHomeControl::HCWIREDBUS, :devicetype => HCHomeControl::HCRANGEDEVICE},
          :bedroom2 => {:adress => 'IEQ0XXXXXX:XX', :bustype => HCHomeControl::HCWIREDBUS, :devicetype => HCHomeControl::HCRANGEDEVICE},
          :living1  => {:adress => 'IEQ0XXXXXX:XX', :bustype => HCHomeControl::HCWIREDBUS, :devicetype => HCHomeControl::HCRANGEDEVICE},
          :living2  => {:adress => 'IEQ0XXXXXX:XX', :bustype => HCHomeControl::HCWIREDBUS, :devicetype => HCHomeControl::HCRANGEDEVICE},
          :kitchen1 => {:adress => 'IEQ0XXXXXX:XX', :bustype => HCHomeControl::HCWIREDBUS, :devicetype => HCHomeControl::HCBINARYDEVICE},
          :kitchen2 => {:adress => 'IEQ0XXXXXX:XX', :bustype => HCHomeControl::HCWIREDBUS, :devicetype => HCHomeControl::HCBINARYDEVICE},
          :gallery1 => {:adress => 'IEQ0XXXXXX:XX', :bustype => HCHomeControl::HCWIREDBUS, :devicetype => HCHomeControl::HCBINARYDEVICE},
          :gallery2 => {:adress => 'IEQ0XXXXXX:XX', :bustype => HCHomeControl::HCWIREDBUS, :devicetype => HCHomeControl::HCBINARYDEVICE},
          :studio   => {:adress => 'IEQ0XXXXXX:XX', :bustype => HCHomeControl::HCWIREDBUS, :devicetype => HCHomeControl::HCBINARYDEVICE},
          :outdoors => {:adress => 'IEQ0XXXXXX:XX', :bustype => HCHomeControl::HCWIREDBUS, :devicetype => HCHomeControl::HCBINARYDEVICE},
          :maindoor => {:adress => 'JEQ0XXXXXX:XX', :bustype => HCHomeControl::HCRFBUS,    :devicetype => HCHomeControl::HCBINARYDEVICE}}


if ARGV.first == '0' || ARGV.first == 'off'
    HCHomeControl.instance.setValues({:outdoors => 0,   :studio   => 0, :gallery1 => 0,   :gallery2 => 0,
                                      :kitchen1 => 0,   :kitchen2 => 0, :living2  => 0.0, :living1  => 0.0,
                                      :bedroom1 => 0.0, :bedroom2 => 0.0})

elsif ARGV.first == '1'
    HCHomeControl.instance.setValues({:living3  => 0.0, :living2  => 0.6, :living1  => 1.0})

elsif ARGV.first == '99'
    HCHomeControl.instance.setValues({:outdoors => 1,   :studio   => 1, :gallery1 => 1,   :gallery2 => 1,
                                      :kitchen1 => 1,   :kitchen2 => 1, :living2  => 1.0, :living1  => 1.0,
                                      :bedroom1 => 1.0, :bedroom2 => 1.0})

elsif ARGV.first == 'status'
    HCHomeControl.instance.getValues.each do |device, state|
        printf("%18s %s\n", device.to_s, (state == 0 ? state.to_s.color(:red) : state.to_s.color(:green)))
    end

elsif ARGV[0] != nil
    HCHomeControl.instance.setValue(ARGV[0], ARGV[1])
end
