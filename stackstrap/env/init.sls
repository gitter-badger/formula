#
# Base environment
#

env-packages:
  pkg:
    - installed
    - names:
      - vim
      - tree
      - ack-grep
      - bc
      - python-dev
      - python-pip
      - python-git
      - unzip

hjson:
  pip.installed

/usr/local/bin/ack:
  file.symlink:
    - target: /usr/bin/ack-grep

# vim: set ft=yaml ts=2 sw=2 et sts=2 :
