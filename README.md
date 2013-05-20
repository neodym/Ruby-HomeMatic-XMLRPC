Ruby-Homematic-XMLRPC
=====================

A simple Ruby script that lets you take control over your Homematic home automation system.<br>
It is using the XMLRPC-API provided by the CCU.

## Getting Started

1. Set the IP adress of the CCU: <code>CCUIP = '0.0.0.0'</code>
2. Set up the <code>HCHomeControl.instance.actors</code> Hash with your device names, adresses and types.<br>
Currently there are two different device types supported:<br>
  <ul><li><code>HCHomeControl::HCRANGEDEVICE</code> is a dimmable device (LEVEL value between 0.0 and 1.0).</li>
  <li><code>HCHomeControl::HCBINARYDEVICE</code> is a device with two states.</li></ul>

## Usage

<code>./hmxml.rb 0</code><br>
Turns off all devices.<br>

<code>./hmxml.rb status</code><br>
Gives back the system status.<br>

<code>./hmxml.rb DEVICE</code><br>
Toggles the DEVICE state.<br>

<code>./hmxml.rb DEVICE VALUE</code><br>
Set a state value for a DEVICE.<br>

## Copyright / License

Copyright (c) 2013 Dennis Röhrs<br>
<p>Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:</p>
<p>The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.</p>
<p>THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.</p>
