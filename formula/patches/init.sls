#
# https://wiki.echocat.org/display/ECHOCAT/2012/04/20/CentOS+6+and+slow+DNS
#

{% if grains['os'] == 'CentOS' %}
/etc/resolv.conf:
  file:
    - append
    - text:
      - options single-request-reopen
{% endif %}
