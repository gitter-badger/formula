#
# Deployments
#

{% macro deploy(project_name, user, group,
                        project_path='/project') -%}

{{ project_path }}/shared:
  file.directory:
    - owner: {{ user }}
    - group: {{ group }} 
    - mode: 755

{{ project_path }}/shared/assets:
  file.directory:
    - owner: {{ user }}
    - group: {{ group }} 
    - mode: 755

{{ project_path }}/shared/vendor:
  file.directory:
    - owner: {{ user }}
    - group: {{ group }} 
    - mode: 755

{{ project_path }}/releases:
  file.directory:
    - owner: {{ user }}
    - group: {{ group }} 
    - mode: 755

{{ project_path }}/tmp:
  file.directory:
    - owner: {{ user }}
    - group: {{ group }} 
    - mode: 755

{%- endmacro %}

# vim: set ft=yaml ts=2 sw=2 et sts=2 :
