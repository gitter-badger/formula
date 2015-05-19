#
# PHP5 macros SLS module
# 
# Copyright 2014 Evan Borgstrom
#

{% macro php5_fpm_instance(user, group, port,
                           name=False,
                           envs=False) -%}

{% if name %}
{% php_name = user + '-' + name -%}
{% else %}
{% php_name = user -%}
{% endif %}

/etc/php5/fpm/pool.d/{{ php_name }}.conf:
  file:
    - managed
    - owner: root
    - group: root
    - mode: 0644
    - source: salt://stackstrap/php5/files/fpm-template.conf
    - template: jinja
    - defaults:
        php_name: {{ php_name }}
        port: {{ port }}
        user: {{ user }}
        group: {{ group }}
        {% if envs %}
        envs:
          {% for env in envs %}
          {{ env }}: {{ envs[env] }}
          {% endfor %}
        {% else %}
        envs: {}
        {% endif %}
    - require:
      - pkg: php5-fpm
      - user: {{ user }}
    - watch_in:
      - service: php5-fpm
{%- endmacro %}

# vim: set ft=yaml ts=2 sw=2 et sts=2 :
