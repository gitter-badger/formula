#
# App
#

{% macro stackstrap_app(name, user, group,
                           envs=False) -%}
/home/{{ user }}/domains/{{ name }}/shared:
  file.directory:
    - owner: {{ user }}
    - group: {{ group }} 
    - makedirs: True
    - mode: 755

/home/{{ user }}/domains/{{ name }}/releases:
  file.directory:
    - owner: {{ user }}
    - group: {{ group }} 
    - makedirs: True
    - mode: 755

/home/{{ user }}/domains/{{ name }}/tmp:
  file.directory:
    - owner: {{ user }}
    - group: {{ group }} 
    - makedirs: True
    - mode: 755
{%- endmacro %}

# vim: set ft=yaml ts=2 sw=2 et sts=2 :
