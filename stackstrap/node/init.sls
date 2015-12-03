# -*- mode: yaml -*-
# vim: set ft=yaml ts=2 sw=2 et sts=2 :

/usr/local/node:
  archive.extracted:
    - source: https://nodejs.org/dist/v4.2.2/node-v4.2.2-linux-x64.tar.gz
    - source_hash: sha256=5c39fac55c945be3b8ac381a12bdbe3a64a9bdc5376d27e2ce0c72160eff5942
    - archive_format: tar
    - tar_options: --strip-components 1

/usr/local/bin/node:
  file.symlink:
    - target: /usr/local/node/bin/node
    - require:
      - archive: /usr/local/node

/usr/local/bin/npm:
  file.symlink:
    - target: /usr/local/node/lib/node_modules/npm/bin/npm-cli.js
    - require:
      - archive: /usr/local/node
