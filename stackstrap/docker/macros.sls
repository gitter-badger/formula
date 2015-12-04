# vim: set ft=yaml ts=2 sw=2 et sts=2 :

{% macro docker(user) -%}

add_user_to_docker_group:
  user:
    - name: {{ user }}
    - groups:
      - docker 
    - require:
      - pkg: docker

docker:
  service.running:
    - enable: True
    - require:
      - pkg: docker

{% endmacro %}
