#!/bin/bash

# Environment variable defaults

update_proftpd_setting() {
  conffile="$1"
  setting="$2"
  value="$3"

  sed -i -e 's/^[ \t]*'"$setting"'[ \t].*$/'"$setting $value"'/' "$conffile"
}

[ -n "$PROFTPD_FTP_PORT" ] && \
  update_proftpd_setting /etc/proftpd/proftpd.conf \
   Port "$PROFTPD_FTP_PORT"

# Remove the hyphen
[ -n "$PROFTPD_PASSIVE_PORTS" ] && \
  update_proftpd_setting /etc/proftpd/proftpd.conf \
   PassivePorts "${PROFTPD_PASSIVE_PORTS//-/ }"

[ -n "$PROFTPD_DEBUG_LEVEL" ] && \
  update_proftpd_setting /etc/proftpd/proftpd.conf \
   DebugLevel "$PROFTPD_DEBUG_LEVEL"

[ -n "$PROFTPD_SERVER_NAME" ] && \
  update_proftpd_setting /etc/proftpd/proftpd.conf \
   ServerName "$PROFTPD_SERVER_NAME"

[ -n "$PROFTPD_REQUIRE_VALID_SHELL" ] && \
  update_proftpd_setting /etc/proftpd/proftpd.conf \
   RequireValidShell "$PROFTPD_REQUIRE_VALID_SHELL"

[ -n "$PROFTPD_TIMEOUT_NO_TRANSFER" ] && \
  update_proftpd_setting /etc/proftpd/proftpd.conf \
   TimeoutNoTransfer "$PROFTPD_TIMEOUT_NO_TRANSFER"

[ -n "$PROFTPD_TIMEOUT_STALLED" ] && \
  update_proftpd_setting /etc/proftpd/proftpd.conf \
   TimeoutStalled "$PROFTPD_TIMEOUT_STALLED"

[ -n "$PROFTPD_TIMEOUT_IDLE" ] && \
  update_proftpd_setting /etc/proftpd/proftpd.conf \
   TimeoutIdle "$PROFTPD_TIMEOUT_IDLE"

[ -n "$PROFTPD_DEFAULT_ROOT" ] && \
  update_proftpd_setting /etc/proftpd/proftpd.conf \
   DefaultRoot "$PROFTPD_DEFAULT_ROOT"

[ -n "$PROFTPD_MAX_INSTANCES" ] && \
  update_proftpd_setting /etc/proftpd/proftpd.conf \
   MaxInstances "$PROFTPD_MAX_INSTANCES"

[ -n "$PROFTPD_UMASK" ] && \
  update_proftpd_setting /etc/proftpd/proftpd.conf \
    Umask "$PROFTPD_UMASK"

[ -n "$PROFTPD_AUTH_ORDER" ] && \
  update_proftpd_setting /etc/proftpd/proftpd.conf \
   AuthOrder "$PROFTPD_AUTH_ORDER"

# Turn this on if it's not on
if [ "$PROFTPD_TLS" != "on" ]; then
  sed -i -e '/LoadModule mod_tls/s/^/# /' /etc/proftpd/modules.conf
fi

[ -n "$PROFTPD_TLS_REQUIRED" ] &&
  update_proftpd_setting /etc/proftpd/tls.conf \
   TLSRequired "$PROFTPD_TLS_REQUIRED"

# exec to replace bash
exec proftpd -nc /etc/proftpd/proftpd.conf
