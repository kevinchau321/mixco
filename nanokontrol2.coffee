#
#  File:       nanokontrol2.coffee
#  Author:     Juan Pedro Bolívar Puente <raskolnikov@es.gnu.org>
#  Date:       Mon May 20 15:27:56 2013
#
#  Mixxx script file for the NanoKontrol2
#

#
#  Copyright (C) 2013 Juan Pedro Bolívar Puente
#
#  This program is free software: you can redistribute it and/or
#  modify it under the terms of the GNU General Public License as
#  published by the Free Software Foundation, either version 3 of the
#  License, or (at your option) any later version.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with this program.  If not, see <http://www.gnu.org/licenses/>.
#

core = require "./core.nodejs"

class NanoKontrol2 extends core.Script
    codename: 'NanoKontrol2'
    info:
        name: 'Korg Nanokontrol 2 - JPB'
        author: 'Juan Pedro Bolivar Puente <raskolnikov@gnu.org>'
        description:
            """
            Controller mapping for Korg Nanokontrol 2 that is
            targetted at being used as main interface for Mixxx.
            """
        forums: 'Not yet'
        wiki: 'Not yet'

exports.nanokontrol2 = new NanoKontrol2
exports.nanokontrol2.main()
