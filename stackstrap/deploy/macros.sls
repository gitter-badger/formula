#
# Deployments
#

{% macro deploy(user, group,
                repo=False,
                identity=None) -%}

{% set home = '/home/'+user -%}

{{ home }}/shared:
  file.directory:
    - owner: {{ user }}
    - group: {{ group }} 
    - mode: 755

{{ home }}/shared/assets:
  file.directory:
    - owner: {{ user }}
    - group: {{ group }} 
    - mode: 755

{{ home }}/shared/static:
  file.directory:
    - owner: {{ user }}
    - group: {{ group }} 
    - mode: 755

{{ home }}/shared/storage:
  file.directory:
    - owner: {{ user }}
    - group: {{ group }} 
    - mode: 755

{{ home }}/shared/vendor:
  file.directory:
    - owner: {{ user }}
    - group: {{ group }} 
    - mode: 755

{{ home }}/releases:
  file.directory:
    - owner: {{ user }}
    - group: {{ group }} 
    - mode: 755

{{ home }}/tmp:
  file.directory:
    - owner: {{ user }}
    - group: {{ group }} 
    - mode: 755

{% if repo %}
{{ user }}_repo:
  git.latest:
    - name: {{ repo }}
    {% if identity %}
    - identity: {{ identity }}
    {% endif %}
    - user: {{ user }}
    - target: {{ home }}/source
{% endif %}

{%- endmacro %}

# vim: set ft=yaml ts=2 sw=2 et sts=2 :
