#
# Macros for working with users
# 
# Copyright 2014 Evan Borgstrom
#

{#
 # skeleton sets up a group, user & home dirs
 #}
{% macro skeleton(name, uid, gid, password=None, groups=[], remove_groups=True) -%}
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
{% endmacro %}

# vim: set ft=yaml ts=2 sw=2 et sts=2 :
