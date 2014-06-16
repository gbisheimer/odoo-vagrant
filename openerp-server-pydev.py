#!/usr/bin/env python
import sys
sys.path.append( 'pysrc' )
sys.path.append( 'odoo' )

import pydevd
pydevd.settrace('10.0.2.2', stdoutToServer=False, stderrToServer=False, suspend=False)

execfile( "odoo/openerp-server" )
# vim:expandtab:smartindent:tabstop=4:softtabstop=4:shiftwidth=4:
