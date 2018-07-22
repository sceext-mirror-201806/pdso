<!-- README.md, pdso/doc/en/ -->

# pdso: Page DOM Snapshot for Offline
<https://bitbucket.org/eisf/pdso/>

(An extension for **Desktop** and **Android** `Firefox`)

Take a static snapshot of the page DOM,
 (modify and) save it for offline viewing,
 including CSS styles and images, no script.


## Features

+ *(TODO)* Save the page as HTML, not picture.

+ *(TODO)* Keep all the styles and images, what you see is what you get.

+ *(TODO)* Remove all the scripts in saved HTML.

+ *(TODO)* Pack all the files (the HTML file, images, CSS files)
  in a zip archive.


## Installation and usage

TODO


## How it works

TODO


## Roadmap

+ *(TODO)* Add support for `<frame>` and `<iframe>`.

+ *(TODO)* Add support for resources loaded by CSS, such as background image,
  web font, etc.  (parse CSS)

+ *(TODO)* Capture `<canvas>` and save it as picture.

+ *(TODO)* Save other resources such as video and audio.


## CHANGELOG

[CHANGELOG.md](CHANGELOG.md)


## Build from source

1. Install [`node.js`](https://nodejs.org/en/) and
  [`yarn`](https://yarnpkg.com/en/).

2. Run the following commands in the project root directory:

  ```
  > yarn install

  > yarn run build-lib

  > yarn run build

  ```


## LICENSE

```
pdso: Page DOM Snapshot for Offline
Copyright (C) 2018  sceext

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
```
