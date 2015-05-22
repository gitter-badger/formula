#
# Environment
#

{% from "stackstrap/utils/users.sls" import skeleton %}

{% macro env(user, group,
             skeleton=True,
             uid=None,
             gid=None,
             password=None,
             groups=[],
             remove_groups=True) -%}

{% if skeleton %}

{% set name = user -%}

{{ name }}:
  group:
    - present
{% if gid %}
    - gid: {{ gid }}
{% endif %}

  user:
    - present
{% if uid %}
    - uid: {{ uid }}
{% endif %}
{% if gid %}
    - gid: {{ gid }}
{% else %}
    - gid: {{ name }}
{% endif %}
    - shell: /bin/bash
    - home: /home/{{ name }}{% if password %}
    - password: '{{ password }}'{% endif %}
    - remove_groups: {{ remove_groups }}
    - require:
      - group: {{ name }}
    - groups:
      {% for group in groups -%}
      - {{ group }}
      {%- endfor %}

{{ name }}-dirs:
  file:
    - directory
    - user: {{ name }}
    - group: {{ name }}
    - mode: 755
    - require:
      - user: {{ name }}
    - names:
      - /home/{{ name }}

{% endif %}

{{ user }}_download_dot_files:
  git.latest:
    - name: https://github.com/stackstrap/dot-files.git
    - user: {{ user }}
    - rev: master
    - target: /home/{{ user }}/dot-files
    - submodules: True

{{ user }}_install_dot_files:
  cmd.run:
    - name: sh dot-files/install-dot-files.sh
    - user: {{ user }}
    - cwd: /home/{{ user }}
    - require:
      - git: {{ user }}_download_dot_files

{%- endmacro %}


# vim: set ft=yaml ts=2 sw=2 et sts=2 :
