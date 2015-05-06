#
# Node.js & NVM macros
#

{% macro nvmnode(domain, user='vagrant', group='vagrant',
                 defaults={},
                 node_globals=None,
                 node_packages=None,
                 node_version='stable',
                 nvm_git_rev='v0.24.1',
                 ignore_package_json=False,
                 custom=None) -%}

{{ user }}_clone_nvm_repo:
  git.latest:
    - name: https://github.com/creationix/nvm.git
    - rev: {{ nvm_git_rev }}
    - target: /home/{{ user }}/.nvm
    - user: {{ user }}
    - require:
      - pkg: nvm_deps

{{ user }}_install_node:
  cmd:
    - run
    - name: /bin/bash -c "source ~/.nvm/nvm.sh; nvm install {{ node_version }} && nvm alias default {{ node_version }} && nvm use {{ node_version }}"
    - onlyif: /bin/bash -c "source ~/.nvm/nvm.sh; nvm ls {{ node_version }} | grep 'N/A'"
    - user: {{ user }}
    - require:
      - git: {{ user }}_clone_nvm_repo

{% if node_globals is iterable %}{% for global in node_globals %}
{{ user }}_node_global_{{ global }}:
  cmd:
    - run
    - names:
      - /bin/bash -c "source ~/.nvm/nvm.sh; npm install -g {{ global }}"
    - unless: /bin/bash -c "source ~/.nvm/nvm.sh; npm -g ls {{ global }} | grep {{ global }}"
    - user: {{ user }}
    - require:
      - cmd: {{ user }}_install_node
{% endfor %}{% endif %}

{% if not ignore_package_json %}
{{ user }}_install_package_json:
  cmd:
    - run
    - name: "source ~/.nvm/nvm.sh; npm install"
    - cwd: /home/{{ user }}/apps/{{ domain }}
    - user: {{ user }}
    - onlyif: test -f /home/{{ user }}/apps/{{ domain }}/package.json
    - unless: test -d /home/{{ user }}/apps/{{ domain }}/node_modules
{% endif %}

{% if node_packages is iterable %}{% for pkg in node_packages %}
{{ user }}_node_package_{{ pkg }}:
  cmd:
    - run
    - names:
      - /bin/bash -c "source ~/.nvm/nvm.sh; npm install {{ pkg }}"
    - unless: /bin/bash -c "source ~/.nvm/nvm.sh; npm list {{ pkg }}"
    - cwd: /home/{{ user }}/apps/{{ domain }}
    - user: {{ user }}
    - require:
      - cmd: {{ user }}_install_node
{% endfor %}{% endif %}

{% endmacro %}

# vim: set ft=yaml ts=2 sw=2 et sts=2 :
