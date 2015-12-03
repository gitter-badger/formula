# -*- mode: yaml -*-
# vim: set ft=yaml ts=2 sw=2 et sts=2 :

/usr/local/node:
  archive.extracted:
    - source: https://iojs.org/download/release/v3.3.1/iojs-v3.3.1-linux-x86.tar.gz
    - source_hash: sha256=88e44af1eb6c020f3107c91c39b1b839ec3aa1a77affdf74225c8b8ceca7f6dc
    - archive_format: tar
    - tar_options: --strip-components 1

/usr/local/bin/node:
  file.symlink:
    - target: /usr/local/node/bin/node

/usr/local/bin/npm:
  file.symlink:
    - target: /usr/local/node/lib/node_modules/npm/bin/npm-cli.js
