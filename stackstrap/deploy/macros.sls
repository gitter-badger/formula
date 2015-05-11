#
# Deployments
#

{% macro deploy(project_name, user, group,
                repo=False,
                identity=None) -%}

{% set deploy_path = '/home/'+user+'/deployments' -%}

{{ deploy_path }}:
  file.directory:
    - makedirs: True
    - user: {{ user }}
    - group: {{ group }}
    - mode: 755

{{ deploy_path }}/shared:
  file.directory:
    - owner: {{ user }}
    - group: {{ group }} 
    - mode: 755

{{ deploy_path }}/shared/assets:
  file.directory:
    - owner: {{ user }}
    - group: {{ group }} 
    - mode: 755

{{ deploy_path }}/shared/static:
  file.directory:
    - owner: {{ user }}
    - group: {{ group }} 
    - mode: 755

{{ deploy_path }}/shared/storage:
  file.directory:
    - owner: {{ user }}
    - group: {{ group }} 
    - mode: 755

{{ deploy_path }}/shared/vendor:
  file.directory:
    - owner: {{ user }}
    - group: {{ group }} 
    - mode: 755

{{ deploy_path }}/releases:
  file.directory:
    - owner: {{ user }}
    - group: {{ group }} 
    - mode: 755

{{ deploy_path }}/tmp:
  file.directory:
    - owner: {{ user }}
    - group: {{ group }} 
    - mode: 755

{% if repo %}
{{ project_name }}_repo:
  git.latest:
    - name: {{ repo }}
    {% if identity %}
    - identity: {{ identity }}
    {% endif %}
    - user: {{ user }}
    - target: {{ project_path }}/source
{% endif %}

{%- endmacro %}

# vim: set ft=yaml ts=2 sw=2 et sts=2 :
