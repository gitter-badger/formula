#
# Environment
#

{% macro stackstrap_env(name, user, group) -%}

/home/{{ user }}/.bashrc:
  file.managed:
    - user: {{ user }}
    - group: {{ group }}
    - mode: 644
    - source: salt://stackstrap/env/files/.bashrc 

/home/{{ user }}/.tmux.conf:
  file.managed:
    - user: {{ user }}
    - group: {{ group }}
    - mode: 644
    - source: salt://stackstrap/env/files/.tmux.conf

/home/{{ user }}/.vimrc:
  file.managed:
    - user: {{ user }}
    - group: {{ group }}
    - mode: 644
    - source: salt://stackstrap/env/files/.vimrc 

/home/{{ user }}/.vim:
  file.directory:
    - user: {{ user }}
    - group: {{ group }}
    - mode: 755

/home/{{ user }}/.vim/autoload:
  file.directory:
    - user: {{ user }}
    - group: {{ group }}
    - mode: 755

/home/{{ user }}/.vim/autoload/pathogen.vim:
  file.managed:
    - user: {{ user }}
    - group: {{ group }}
    - mode: 644
    - source: salt://stackstrap/env/files/.vim/autoload/pathogen.vim 

/home/{{ user }}/.vim/bundle:
  file.directory:
    - user: {{ user }}
    - group: {{ group }}
    - mode: 755

{{ user }}_vim_bundle_html5:
  archive.extracted:
    - name: /home/{{ user }}/.vim/bundle
    - source: https://github.com/othree/html5.vim/archive/0.27.tar.gz
    - source_hash: md5=cff0f00e978b7e18ce9c54df214a1533
    - archive_format: tar
    - if_missing: /home/{{ user }}/.vim/bundle/html5.vim-0.27
    - user: {{ user }}
    - group: {{ group }}

{%- endmacro %}

# vim: set ft=yaml ts=2 sw=2 et sts=2 :
