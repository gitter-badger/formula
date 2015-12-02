#
# Environment
#

{% from "stackstrap/utils/users.sls" import skeleton %}

{% macro env(user, group,
             uid=None,
             gid=None,
             password=None,
             groups=[],
             remove_groups=True) -%}

{% set name = user -%}

{% set home = '/home/' + user %}

{{ name }}:
  group:
    - present
{% if gid %}
    - gid: {{ gid }}
{% endif %}

  user:
    - present
{% if uid %}
    - uid: {{ uid }}
{% endif %}
{% if gid %}
    - gid: {{ gid }}
{% else %}
    - gid: {{ name }}
{% endif %}
    - shell: /bin/bash
    - home: /home/{{ name }}{% if password %}
    - password: '{{ password }}'{% endif %}
    - remove_groups: {{ remove_groups }}
    - require:
      - group: {{ name }}
    - groups:
      {% for group in groups -%}
      - {{ group }}
      {%- endfor %}

{{ name }}-dirs:
  file:
    - directory
    - user: {{ name }}
    - group: {{ name }}
    - mode: 755
    - require:
      - user: {{ name }}
    - names:
      - /home/{{ name }}

{{ home }}/.bashrc:
  file.managed:
    - source: salt://stackstrap/env/files/.bashrc
    - user: {{ user }}
    - group: {{ group }}

{{ home }}/.tmux.conf:
  file.managed:
    - source: salt://stackstrap/env/files/.tmux.conf
    - user: {{ user }}
    - group: {{ group }}

{{ home }}/.vimrc:
  file.managed:
    - source: salt://stackstrap/env/files/.vimrc
    - user: {{ user }}
    - group: {{ group }}

{{ home }}/.ssh:
  file.directory:
    - makedirs: True
    - user: {{ user }}
    - group: {{ group }}

{{ home }}/.ssh/rc:
  file.managed:
    - source: salt://stackstrap/env/files/.ssh/rc
    - user: {{ user }}
    - group: {{ group }}

#Vim plugins

{{ home }}/.vim/autoload:
  file.directory:
    - makedirs: True
    - user: {{ user }}
    - group: {{ group }}

{{ home }}/.vim/autoload/pathogen.vim:
  file.managed:
    - source: salt://stackstrap/env/files/.vim/autoload/pathogen.vim
    - user: {{ user }}
    - group: {{ group }}

{{ home }}/.vim/bundle/html5:
  file.directory:
    - makedirs: True
    - user: {{ user }}
    - group: {{ group }}
  archive.extracted:
    - name: {{ home }}/.vim/bundle/html5
    - source: https://github.com/othree/html5/archive/ad38231df6845562f569512fd250c5660aadeb64.tar.gz
    - source_hash: md5=c191088400337360a2fab4c34d0fb6f7
    - archive_format: tar
    - tar_options: --strip-components 1
    - user: {{ user }}
    - group: {{ group }}

{%- endmacro %}

# vim: set ft=yaml ts=2 sw=2 et sts=2 :
