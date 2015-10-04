#
# MySQL Macros SLS module
#
# Copyright 2014 Evan Borgstrom
#

{% macro mysql_user_db(name, password,
                       database=False,
                       host='localhost',
                       connection=False,
                       dump=False,
                       dump_format="textfile") -%}

{% set database_name = database if database else name %}

{{ name }}_mysql_user_db:
  mysql_database:
    - present
    - name: {{ database_name }}
    {% if connection %}
    - connection_user: {{ connection['user'] }}
    - connection_pass: {{ connection['pass'] }}
    - connection_host: {{ connection['host'] }}
    {% endif %}

  mysql_user:
    - present
    - name: {{ name }}
    - password: '{{ password }}'
    - host: '{{ host }}'
    {% if connection %}
    - connection_user: {{ connection['user'] }}
    - connection_pass: {{ connection['pass'] }}
    - connection_host: {{ connection['host'] }}
    {% endif %}

  mysql_grants:
    - present
    - name: {{ name }}
    - grant: all privileges
    - database: '{{ database_name }}.*'
    - user: {{ name }}
    - host: '{{ host }}'
    - require:
      - mysql_user: {{ name }}
      - mysql_database: {{ database_name }}
    {% if connection %}
    - connection_user: {{ connection['user'] }}
    - connection_pass: {{ connection['pass'] }}
    - connection_host: {{ connection['host'] }}
    {% endif %}

import_mysql_dump:
  cmd:
    - run
    {% if dump_format == "zip" %}
    - name: unzip -p {{ dump }} | mysql --user={{ name }} --password={{ password }} {{ database_name }}
    {% else %}
    - name: cat {{ dump }} | mysql --user={{ name }} --password={{ password }} {{ database_name }}
    {% endif %}
    - unless: [[ -z "$(mysql --user={{ name }} --password={{ password }} -e "use '{{ database_name }}'; show tables;")" ]] && { exit 1; }

# vim: set ft=yaml ts=2 sw=2 et sts=2 :
