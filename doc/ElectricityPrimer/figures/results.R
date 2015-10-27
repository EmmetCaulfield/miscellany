## Common setup:
source('header.R')

## Format a potentially complex value:
fmt <- function(value) {
    if( is.complex(value) ) {
        paste(format(Re(value), digits=3), '+\\mathrm{j}', format(Im(value), digits=3), sep='') 
    } else {
        format(value, digits=3)
    }
}

## Write TeX macro for raw number and value with units:
tex <- function(name, value, unit) {
    write(paste('\\newcommand*\\rn', name, '{',
                fmt(value), '\\xspace}', sep=''),
          'results.tex', append=TRUE)
    if( ! missing(unit) ) {
        write(paste('\\newcommand*\\ru', name, '{',
                    fmt(value), '\\,\\unit{', unit, '}\\xspace}', sep=''),
              'results.tex', append=TRUE)
    }
}

## Common values/constants:
tex('Vdc',     Vdc,                 'V'      )
tex('Vm',      Vm,                  'V'      )
tex('Vp',      Vp,                  'V'      )
tex('Vpp',     2*Vp,                'V'      )
tex('F',       f,                   'Hz'     )
tex('R',       R,                   '\\Omega')
tex('L',       L*1000,              'mH'     )
tex('C',       C*1e6,               '\\mu F' )
tex('Xl',      Xl,                  '\\Omega')
tex('Xc',      Xc,                  '\\Omega')
tex('Z',       Zl,                  '\\Omega')

## Current in pure inductance/capacitance:
tex('ImC',     (Vm/Xc)*1000,        'mA'     )
tex('ImL',     Vm/Xl,               'A'      )
tex('IpL',     Vp/Xl,               'A'      )

## Time-constants for series RC and RL circuit step responses:
tex('TauC',    1e6*R*C,             '\\mu s' )
tex('TauL',    1000*L/R,            'ms'     )

## Series RL circuit AC response:
## Impedance:
tex('ArgZ',    Arg(Zl)*180/pi,      '\\deg'  )
tex('ModZ',    Mod(Zl),             '\\Omega')
tex('AbsArgZ', abs(Arg(Zl)*180/pi), '\\deg'  )
## Current:
I <- Vp / Zl
tex('ArgI',    Arg(I)*180/pi,       '\\deg'  )
tex('ModI',    Mod(I),              'A'      )
tex('AbsArgI', abs(Arg(I)*180/pi),  '\\deg'  )
## Power factor:
tex('PF',      cos(Arg(Zl)))
