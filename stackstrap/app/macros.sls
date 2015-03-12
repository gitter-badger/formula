#
# App
#

{% macro stackstrap_app(domain, user, group,
                           envs=False) -%}
/home/{{ user }}/domains/{{ domain }}/shared:
  file.directory:
    - owner: {{ user }}
    - group: {{ group }} 
    - makedirs: True
    - mode: 755

/home/{{ user }}/domains/{{ domain }}/releases:
  file.directory:
    - owner: {{ user }}
    - group: {{ group }} 
    - makedirs: True
    - mode: 755
{%- endmacro %}

# vim: set ft=yaml ts=2 sw=2 et sts=2 :
