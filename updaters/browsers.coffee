# Copyright 2013 Andrey Sitnik <andrey@sitnik.ru>,
# sponsored by Evil Martians.
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

updater = require('../lib/autoprefixer/updater')

updater.caniuse 'data.json', (data) ->
  normalize = (array) -> array.reverse().filter (i) -> i

  intervals = (array) ->
    result = []
    for interval in array
      splited = interval.split('-')
      sub     = ([i, interval, splited.length] for i in splited)
      result  = result.concat(sub)
    result

  agent = (name) ->
    info     = data.agents[name]
    future   = normalize(info.versions[-2..-1]).map (i) -> parseFloat(i)
    versions = intervals(normalize(info.versions[0..-3]))
    result   =
      prefix:  "-#{info.prefix}-"
      versions: versions.map (i) -> parseFloat(i[0])
    result.future     = future if future.length
    result.popularity = versions.map (i) -> info.usage_global[i[1]] / i[2]
    result

  updater.save 'browsers.js',
    chrome:  agent('chrome')
    ff:      agent('firefox')
    ie:      agent('ie')
    safari:  agent('safari')
    opera:   agent('opera')
    ios:     agent('ios_saf')