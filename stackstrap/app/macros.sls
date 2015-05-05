#
# App
#

{% macro stackstrap_app(name, user, group,
                           envs=False) -%}
/home/{{ user }}/apps/{{ name }}/shared:
  file.directory:
    - owner: {{ user }}
    - group: {{ group }} 
    - mode: 755

/home/{{ user }}/apps/{{ name }}/shared/assets:
  file.directory:
    - owner: {{ user }}
    - group: {{ group }} 
    - mode: 755

/home/{{ user }}/apps/{{ name }}/shared/vendor:
  file.directory:
    - owner: {{ user }}
    - group: {{ group }} 
    - mode: 755

/home/{{ user }}/apps/{{ name }}/releases:
  file.directory:
    - owner: {{ user }}
    - group: {{ group }} 
    - mode: 755

/home/{{ user }}/apps/{{ name }}/tmp:
  file.directory:
    - owner: {{ user }}
    - group: {{ group }} 
    - mode: 755
{%- endmacro %}

# vim: set ft=yaml ts=2 sw=2 et sts=2 :
