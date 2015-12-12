#
# Deployments
#

{% macro deploy(user, group,
                repo=False,
                rev=False,
                git_name=False,
                git_email=False,
                identity=None,
                bower=False,
                node=False,
                remote_name=None) -%}

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
    
{% if bower %}
{{ home }}/shared/bower_components:
  file.directory:
    - owner: {{ user }}
    - group: {{ group }} 
    - mode: 755
{% endif %}

{% if node %}
{{ home }}/shared/node_modules:
  file.directory:
    - owner: {{ user }}
    - group: {{ group }} 
    - mode: 755
{% endif %}

{% if repo %}
{{ user }}_repo:
  git.latest:
    - name: {{ repo }}
    {% if identity %}
    - identity: {{ identity }}
    {% endif %}
    {% if rev %}
    - rev: {{ rev }}
    {% endif %}
    {% if remote_name %}
    - remote_name: {{ remote_name }}
    {% endif %}
    - user: {{ user }}
    - target: {{ home }}/source
{% endif %}

{% if git_name %}
{{ user }}_git_config_name:
  git.config:
    - name: user.name
    - value: {{ git_name }}
    - repo: {{ home }}/source
    - user: {{ user }}
    - require:
      - git: {{ user }}_repo
{% endif %}

{% if git_email %}
{{ user }}_git_config_email:
  git.config:
    - name: user.email
    - value: {{ git_email }}
    - repo: {{ home }}/source
    - user: {{ user }}
    - require:
      - git: {{ user }}_repo
{% endif %}

{%- endmacro %}

# vim: set ft=yaml ts=2 sw=2 et sts=2 :
