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
  git.latest:
    - repo: https://github.com/othree/html5.vim
    - rev: master
    - target: /home/{{ user }}/.vim/bundle/html5

{{ user }}_vim_bundle_jedi-vim:
  git.latest:
    - target:{{ user }}/.vim/bundle/jedi-vim
    - rev: master
    - repo: https://github.com/davidhalter/jedi-vim.git

{{ user }}_vim_bundle_vim-colors-solarized:
  git.latest:
    - target:{{ user }}/.vim/bundle/vim-colors-solarized
    - rev: master
    - repo: https://github.com/altercation/vim-colors-solarized.git

{{ user }}_vim_bundle_vim-javascript:
  git.latest:
    - target:{{ user }}/.vim/bundle/vim-javascript
    - rev: master
    - repo: https://github.com/pangloss/vim-javascript.git

{{ user }}_vim_bundle_vim-python-pep8-indent:
  git.latest:
    - target:{{ user }}/.vim/bundle/vim-python-pep8-indent
    - rev: master
    - repo: https://github.com/hynek/vim-python-pep8-indent.git

{{ user }}_vim_bundle_syntastic:
  git.latest:
    - target:{{ user }}/.vim/bundle/syntastic
    - rev: master
    - repo: https://github.com/scrooloose/syntastic.git

{{ user }}_vim_bundle_todo.txt-vim:
  git.latest:
    - target:{{ user }}/.vim/bundle/todo.txt-vim
    - rev: master
    - repo: https://github.com/freitass/todo.txt-vim

{{ user }}_vim_bundle_vim-go:
  git.latest:
    - target:{{ user }}/.vim/bundle/vim-go
    - rev: master
    - repo: https://github.com/fatih/vim-go.git

{{ user }}_vim_bundle_ctrlp.vim:
  git.latest:
    - target:{{ user }}/.vim/bundle/ctrlp.vim
    - rev: master
    - repo: https://github.com/kien/ctrlp.vim.git

{%- endmacro %}

# vim: set ft=yaml ts=2 sw=2 et sts=2 :
