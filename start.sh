#!/bin/bash
exec mysqld_safe
exec rsyslogd -c5
