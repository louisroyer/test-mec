#!/usr/bin/env python3

def j2_environment_params():
    '''Extra parameters for the Jinja2 Environment'''
    return dict(
            trim_blocks = True,
            #lstrip_blocks = True,
            line_statement_prefix='#~',
    )
