Ruby-Homematic-XMLRPC
=====================

A simple Ruby script that lets you take control over your Homematic home automation system.<br>
It is using the XMLRPC-API provided by the CCU.

## Getting Started

1. Set the IP adress of the CCU: <code>CCUIP = '0.0.0.0'</code>
2. Set up the <code>HCHomeControl.instance.actors</code> Hash.<br>
<code>HCHomeControl::HCRANGEDEVICE</code> is a dimmable device (LEVEL value between 0.0 and 1.0).<br>
<code>HCHomeControl::HCBINARYDEVICE</code> is a device with two states.

## Usage

<code>./hmxml.rb 0</code><br>
Turns off all devices.<br>

<code>./hmxml.rb status</code><br>
Gives back the systems status.<br>

<code>./hmxml.rb DEVICE</code><br>
Toggles the DEVICE status.<br>

<code>./hmxml.rb DEVICE VALUE</code><br>
Set a value for a DEVICE.<br>
