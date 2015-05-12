#
# Environment
#

{% from "stackstrap/utils/users.sls" import skeleton %}

{% macro env(project_name, user, group,
             project_path='/project',
             skeleton=True,
             uid=None,
             gid=None,
             password=None,
             groups=[],
             remove_groups=True) -%}

{% if skeleton %}

{{ skeleton(user, uid, gid) }}

{% endif %}

{{ project_path }}:
  file.directory:
    - user: {{ name }}
    - group: {{ name }}
    - mode: 755
    - require:
      - user: {{ name }}

{{ user }}_download_dot_files:
  git.latest:
    - name: https://github.com/stackstrap/dot-files.git
    - user: {{ user }}
    - rev: master
    - target: /home/{{ user }}/dot-files
    - submodules: True

{{ user }}_install_dot_files:
  cmd.run:
    - name: sh dot-files/install-dot-files.sh
    - user: {{ user }}
    - cwd: /home/{{ user }}
    - require:
      - git: {{ user }}_download_dot_files

{%- endmacro %}


# vim: set ft=yaml ts=2 sw=2 et sts=2 :
