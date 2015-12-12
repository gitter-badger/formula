# vim: set ft=yaml ts=2 sw=2 et sts=2 :

{% macro docker(user) -%}

docker_group_members:
  group.present:
    - name: docker
    - members:
      - {{ user }} 

run_docker:
  service.running:
    - name: docker
    - enable: True
    - require:
      - pkg: docker

{% endmacro %}
