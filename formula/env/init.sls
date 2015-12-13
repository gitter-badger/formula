#
# Base environment
#

{% from "formula/env/map.jinja" import env with context %}

env-packages:
  pkg:
    - installed
    - names:
      - vim
      - tree
      - {{ env.ack }}
      - bc
      - tmux

/usr/local/bin/ack:
  file.symlink:
    - target: /usr/bin/ack-grep

python_requirements:
  pip.installed:
    - pkgs:
      - awscli
      - bitbucket-api
      - boto
      - bunch
      - fabric
      - jedi
      - legit
      - pprintpp
      - pyyaml
      - requests
      - ruamel.yaml

# vim: set ft=yaml ts=2 sw=2 et sts=2 :
