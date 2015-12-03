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
  archive.extracted:
    - source: https://github.com/othree/html5.vim/archive/ad38231df6845562f569512fd250c5660aadeb64.tar.gz
    - source_hash: md5=c570bb345d6dea49164c843825052e5b
    - tar_options: --strip-components 1
    - archive_format: tar
    - user: {{ user }}
    - group: {{ group }}

{{ home }}/.vim/bundle/jedi-vim:
  archive.extracted:
    - source: https://github.com/davidhalter/jedi-vim/archive/dc23f0b859d3b5c087921b68cf7cd66803ecca83.tar.gz
    - source_hash: md5=075e2d62e8442dd37ad67cdcbe191667
    - tar_options: --strip-components 1
    - archive_format: tar
    - user: {{ user }}
    - group: {{ group }}

{{ home }}/.vim/bundle/vim-colors-solarized:
  archive.extracted:
    - source: https://github.com/altercation/vim-colors-solarized/archive/528a59f26d12278698bb946f8fb82a63711eec21.tar.gz
    - source_hash: md5=c0bc1042e8b05ca8a770a283648c6b77
    - tar_options: --strip-components 1
    - archive_format: tar
    - user: {{ user }}
    - group: {{ group }}

{{ home }}/.vim/bundle/vim-javascript:
  archive.extracted:
    - source: https://github.com/pangloss/vim-javascript/archive/1d8c2677d26d6b3950b90dc1636e63334c8efc3b.tar.gz
    - source_hash: md5=62a5b9ea24f82419c87915166a961263
    - tar_options: --strip-components 1
    - archive_format: tar
    - user: {{ user }}
    - group: {{ group }}

{{ home }}/.vim/bundle/vim-python-pep8-indent:
  archive.extracted:
    - source: https://github.com/hynek/vim-python-pep8-indent/archive/f4f95ee041370e3e79bb72cb9b360a4ec5707785.tar.gz
    - source_hash: md5=af7d76432e84039b5a0f75d333a88170
    - tar_options: --strip-components 1
    - archive_format: tar
    - user: {{ user }}
    - group: {{ group }}

{{ home }}/.vim/bundle/syntastic:
  archive.extracted:
    - source: https://github.com/scrooloose/syntastic/archive/70c723ac16fee7b4093d3d16a90544d877dea89e.tar.gz
    - source_hash: md5=540bd29c713eae0f2ae3b9646dd70ecc
    - tar_options: --strip-components 1
    - archive_format: tar
    - user: {{ user }}
    - group: {{ group }}

{{ home }}/.vim/bundle/todo.txt-vim:
  archive.extracted:
    - source: https://github.com/freitass/todo.txt-vim/archive/b3d9e18b081bfdfeec50af58fa7eb5a353a10675.tar.gz
    - source_hash: md5=a99d093f67c9910670ee0e209317f64a
    - tar_options: --strip-components 1
    - archive_format: tar
    - user: {{ user }}
    - group: {{ group }}

{{ home }}/.vim/bundle/ctrlp.vim:
  archive.extracted:
    - source: https://github.com/kien/ctrlp.vim/archive/564176f01d7f3f7f8ab452ff4e1f5314de7b0981.tar.gz
    - source_hash: md5=8eaa3be4335b929b8fd497ac812a10e6
    - tar_options: --strip-components 1
    - archive_format: tar
    - user: {{ user }}
    - group: {{ group }}

{%- endmacro %}

# vim: set ft=yaml ts=2 sw=2 et sts=2 :
