#
# MySQL Macros SLS module
#
# Copyright 2014 Evan Borgstrom
#

{% macro mysql_user_db(name, password,
                       database=False,
                       dump=False) -%}

{% set database_name = database if database else name %}

{{ name }}_mysql_user_db:
  mysql_database:
    - present
    - name: {{ database_name }}

  mysql_user:
    - present
    - name: {{ name }}
    - password: '{{ password }}'
    - host: 'localhost'

  mysql_grants:
    - present
    - name: {{ name }}
    - grant: all privileges
    - database: '{{ database_name }}.*'
    - user: {{ name }}
    - host: 'localhost'
    - require:
      - mysql_user: {{ name }}
      - mysql_database: {{ database_name }}

{% if dump and dump != salt['grains.get']('stackstrap.mysql.dump', '') %}

stackstrap.mysql.dump:
  grains.present:
    - value: {{ dump }}

import_mysql_dump:
  cmd:
    - run
    - name: mysql --user={{ name }} --password={{ password }} {{ database_name }} < {{ dump }}

{% endif %}

{%- endmacro %}

# vim: set ft=yaml ts=2 sw=2 et sts=2 :
