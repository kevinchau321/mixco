script.xponent
==============

Mixxx script file for the **M-Audio Xponent** controller.  The
script is based on the [**Mixco** framework](../index.html).

  ![Xponent Layout](../pic/xponent.png)

License
-------

>  Copyright (C) 2013 Juan Pedro Bolívar Puente
>
>  This program is free software: you can redistribute it and/or
>  modify it under the terms of the GNU General Public License as
>  published by the Free Software Foundation, either version 3 of the
>  License, or (at your option) any later version.
>
>  This program is distributed in the hope that it will be useful,
>  but WITHOUT ANY WARRANTY; without even the implied warranty of
>  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>  GNU General Public License for more details.
>
>  You should have received a copy of the GNU General Public License
>  along with this program.  If not, see <http://www.gnu.org/licenses/>.

Dependencies
------------

First, we have to import he *Mixco* modules that we are going to use.

    {assert}  = require '../mixco/util'
    script    = require '../mixco/script'
    control   = require '../mixco/control'
    behaviour = require '../mixco/behaviour'
    value     = require '../mixco/value'

The script
----------

### Declaration

We start defining the script by creating a class that is called like
the file but with
[*CamelCase*](http://en.wikipedia.org/wiki/CamelCase) and inherits
from `script.Script`. We have to register it too, and in CoffeeScript
we can do this all in one line.

    script.register module, class Xponent extends script.Script

### Metadata

Then we fill out the metadata. This will be shown to the user in the
preferences window in Mixxx when he selects the script.

        info:
            name: '[mixco] M-Audio Xponent'
            author: 'Juan Pedro Bolivar Puente <raskolnikov@gnu.org>'
            description:
                """
                Controller mapping for the M-Audio Xponent DJ controller.
                """
            forums: ''
            wiki: ''

### Basic deck controls

Lets define these couple of shortcuts.

        c = control
        b = behaviour
        v = value

### Constructor

        constructor: ->
            super

Transport section.

            id = (cc) -> c.midiId cc, 2
            g  = "[Master]"
            @add c.slider(id 0x07).does g, "crossfader"

### Per deck controls.

            @addDeck 0
            @addDeck 1

        addDeck: (i) ->
            assert i in [0, 1]
            g  = "[Channel#{i+1}]"
            id = (cc) -> c.midiId cc, i

The mixer section.

            @add c.slider(id 0x07).does g, "volume"
            @add c.knob(id 0x08).does g, "filterLow"
            @add c.knob(id 0x09).does g, "filterMid"
            @add c.knob(id 0x0A).does g, "filterHigh"
            @add c.knob(id 0x0B).does b.soft g, "pregain"
