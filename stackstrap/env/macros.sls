#
# Environment
#

{% macro stackstrap_env(name, user, group) -%}

{{ user }}_download_dot_files:
  git.latest:
    - name: https://github.com/stackstrap/dot-files.git
    - rev: master
    - target: /home/{{ user }}/dot-files
    - submodules: True

{%- endmacro %}

# vim: set ft=yaml ts=2 sw=2 et sts=2 :
