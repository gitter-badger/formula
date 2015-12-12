{% macro rvmruby(user, group,
                 project_path='/project',
                 defaults={},
                 ruby_version='2.1.4',
                 rvm_version='latest',
                 rvm_globals=None,
                 ruby_gemset=False,
                 bundle_install=True,
                 custom=None) -%}

rvm_gpg_key:
  cmd:
    - run
    - name: command curl -sSL https://rvm.io/mpapis.asc | gpg --import - 
    - user: {{ user }}

install_rvm:
  cmd:
    - run
    - name: curl -sSL https://get.rvm.io | bash -s -- --version {{ rvm_version }}
    - unless: /bin/bash -c "source ~/.rvm/scripts/rvm; type rvm | head -n 1 | grep 'rvm is a function'"
    - user: {{ user }}
    - require:
      - pkg: rvm_deps
      - cmd: rvm_gpg_key

install_rvm_requirements:
  cmd:
    - run
    - name: /bin/bash -c "source ~/.rvm/scripts/rvm; rvm requirements"
    - user: {{ user }}
    - require:
      - cmd: install_rvm

install_ruby:
  cmd:
    - run
    - name: /bin/bash -c "source ~/.rvm/scripts/rvm; rvm install --autolibs=read {{ ruby_version }} && rvm --default use {{ ruby_version }}"
    - unless: /bin/bash -c "source ~/.rvm/scripts/rvm; rvm list rubies | grep '{{ ruby_version }}'"
    - user: {{ user }}
    - require:
      - cmd: install_rvm
      - cmd: install_rvm_requirements

{% if ruby_gemset %}
install_gemset:
  cmd:
    - run
    - name: /bin/bash -c "source ~/.rvm/scripts/rvm; rvm gemset create {{ ruby_gemset }} && rvm --default gemset use {{ ruby_gemset }}"
    - unless: /bin/bash -c "source ~/.rvm/scripts/rvm; rvm gemset list | grep '{{ ruby_gemset }}'"
    - user: {{ user }}
    - require:
      - cmd: install_rvm
      - cmd: install_ruby
{% endif %}

{% if rvm_globals is iterable %}{% for global in rvm_globals %}
rvm_global_{{ global }}:
  cmd:
    - run
    - name: /bin/bash -c "source ~/.rvm/scripts/rvm; rvm @global do gem install {{ global }}"
    - unless: /bin/bash -c "source ~/.rvm/scripts/rvm; rvm @global do gem list | grep '{{ global }}'"
    - user: {{ user }}
    - require:
      - cmd: install_rvm
      - cmd: install_ruby
{% endfor %}{% endif %}

{% if bundle_install %}
bundle_install_gems:
  cmd:
    - run
    - name: "source ~/.rvm/scripts/rvm; bundle install"
    - cwd: {{ project_path }}
    - user: {{ user }}
    - onlyif: test -f {{ project_path }}/Gemfile.lock
{% endif %}

{% endmacro %}

# vim: set ft=yaml ts=2 sw=2 et sts=2 :
