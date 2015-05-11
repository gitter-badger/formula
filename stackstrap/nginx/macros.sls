#
# Nginx macros
#
# Copyright 2014 Evan Borgstrom
#

{% macro nginxsite(project_name, user, group,
                   project_path='/project',
                   auth=False,
                   cors=False,
                   template='standard-server.conf',
                   defaults={},
                   listen='80',
                   server_name=None,
                   static=False,
                   root='public',
                   create_root=False,
                   enabled=True,
                   enabled_name=None,
                   ssl=False,
                   ssl_alias=False,
                   custom=None) -%}

# if ssl_alias is true then we want to setup an identical site with ssl enabled
# as well, you still need to supply ssl_certificate and ssl_certificate_key to
# the defaults
{% if ssl_alias %}
{{ nginxsite(project_name, user, group,
          auth=auth,
          cors=cors,
          project_path=project_path,
          template=template,
          defaults=defaults,
          listen='443',
          server_name=server_name,
          static=static,
          root=root,
          create_root=False,
          enabled=enabled,
          enabled_name=enabled_name,
          ssl=True,
          ssl_alias=False,
          custom=custom) }}
{% endif %}

{% if create_root %}
{{ project_path }}/{{ root }}:
  file:
    - directory
    - user: {{ user }}
    - group: {{ group or user }}
    - mode: 755
{% endif %}

# if we're being run in a VirtualBox instance we turn sendfile off
# this requires that the macros file be imported `with context`, but to avoid
# having the high state run error out if it's not imported with context we 
# check to make sure grains is defined first
{% if grains is defined %}
{% if grains.get('virtual') == 'VirtualBox' %}{% do defaults.update({'sendfile_off': True}) %}{% endif %}
{% endif %}

/etc/nginx/sites-available/{{ user }}-{{ project_name }}.{{ listen }}.conf:
  file:
    - managed
    - user: root
    - group: root
    - mode: 444
    - source: {{ template }}
    - watch_in:
      - service: nginx
    - template: jinja
    - defaults:
        project_name: '{{ project_name }}'
        project_path: '{{ project_path }}'
        auth: {{ auth }}
        cors: '{{ cors }}'
        server_name: '{{ server_name or project_name }}'
        listen: "{{ listen }}"
        owner: {{ user }}
        group: {{ group }}
        root: {{ root }}
        static: {{ static }}
        ssl: {{ ssl }}{% if custom %}
        custom: "sites-available/{{ user }}-{{ project_name }}.{{ listen }}-custom"{% endif %}{% for n in defaults %}
        {{ n }}: "{{ defaults[n] }}"{% endfor %}

{% if custom %}
/etc/nginx/sites-available/{{ user }}-{{ project_name }}.{{ listen }}-custom:
  file:
    - managed
    - user: root
    - group: root
    - mode: 444
    - source: {{ custom }}
{% endif %}

/etc/nginx/sites-enabled/{{ user }}-{{ project_name }}.{{ listen }}.conf:
  file:
{% if enabled %}
    - symlink
    - target: /etc/nginx/sites-available/{{ user }}-{{ project_name }}.{{ listen }}.conf
    - require:
      - file: /etc/nginx/sites-available/{{ user }}-{{ project_name }}.{{ listen }}.conf
{% else %}
    - absent
{% endif %}
    - watch_in:
      - service: nginx

{% endmacro %}

# vim: set ft=yaml ts=2 sw=2 et sts=2 :
