#!/usr/bin/env python3
"""Create startup fit files for Modified Gaussian Model input.

This module can be used to generate startup fit files for the Modified
Gaussian Model. When run as a script, it will generate one or more runs. It
can also be imported as a module and used in other code.

Classes:
    Gaussian
    ContinuumType
    MGMrun

This program is free software: you can redistribute it and/or modify it under
the terms of the GNU General Public License as published by the Free Software
Foundation, either version 3 of the License, or (at your option) any later
version.
This program is distributed in the hope that it will be useful, but WITHOUT
ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
You should have received a copy of the GNU General Public License along with
this program. If not, see <http://www.gnu.org/licenses/>.
"""

from enum import Enum
import os
import sys

__author__ = 'Carey Legett'
__copyright__ = 'Copyright 2018, Carey Legett'
__credits__ = 'Carey Legett'
__license__ = 'GPLv3'
__version__ = '0.1a'
__maintainer__ = 'Carey Legett'
__email__ = 'carey.legett@stonybrook.edu'
__date__ = '30 May 2018'
__status__ = 'Development'


class Gaussian(object):
    def __init__(self, position, width=0.200E+02, intensity=-0.1E+00,
                 pos_uncertainty=100, w_uncertainty=100,
                 intensity_uncertainty=100):
        self.position = position
        self.width = width
        self.intensity = intensity
        self.pos_uncertainty = pos_uncertainty
        self.w_uncertainty = w_uncertainty
        self.intensity_uncertainty = intensity_uncertainty

    def get_two_line_tabbed(self):
        return f'{self.position:1.2E}\t{self.width:1.2E}\t'\
               f'{self.intensity:1.2E}\n{self.pos_uncertainty:f}\t'\
               f'{self.w_uncertainty:f}\t{self.intensity_uncertainty:f}'


class ContinuumType(Enum):
    NONE = 0
    POLY_WL = 1
    POLY_WN = 2
    GAUSS = 3
    STR_WL = 4
    STR_WN = 5


types = {ContinuumType.NONE: 'N', ContinuumType.POLY_WL: 'P',
         ContinuumType.POLY_WN: 'Q', ContinuumType.GAUSS: 'G',
         ContinuumType.STR_WL: 'S', ContinuumType.STR_WN: 'T'}

run_map = {'Avg-1': 'Ol', 'Avg-2': 'Ol05', 'Avg-3': 'Ol1', 'Avg-4': 'Ol2',
           'Avg-5': 'Ol5', 'Avg-6': 'Bad1', 'Avg-6-2': 'Px', 'Avg-7': 'Px05',
           'Avg-8': 'Px1', 'Avg-9': 'Px2', 'Avg-10': 'Bad2', 'Avg-10-2':
           'Px5', 'Avg-11': 'Bad3', 'Avg-11-2': 'Fs', 'Avg-12': 'Fs05',
           'Avg-13': 'Fs1', 'Avg-14': 'Fs2', 'Avg-15': 'Fs5', 'Avg-16':
           'Fs01Ol', 'Avg-17': 'Fs01Ol05', 'Avg-18': 'Fs01Ol1', 'Avg-19':
           'Fs01Ol2', 'Avg-20': 'Fs01Ol5', 'Avg-21': 'Fs05Ol', 'Avg-22':
           'Fs05Ol05', 'Avg-23': 'Fs05Ol1', 'Avg-24': 'Fs05Ol2', 'Avg-25':
           'Fs05Ol5', 'Avg-26': 'Fs1Ol', 'Avg-27': 'Fs1Ol05', 'Avg-28':
           'Fs1Ol1', 'Avg-29': 'Fs1Ol2', 'Avg-30': 'Fs1Ol5', 'Avg-31':
           'Fs2Ol', 'Avg-32': 'Fs2Ol05', 'Avg-33': 'Fs2Ol1', 'Avg-34':
           'Fs2Ol2', 'Avg-35': 'Fs2Ol5', 'Avg-36': 'Fs5Ol', 'Avg-37':
           'Fs5Ol05', 'Avg-38': 'Fs5Ol1', 'Avg-39': 'Fs5Ol2', 'Avg-40':
           'Fs5Ol5', 'Avg-41': 'Fs01Px', 'Avg-42': 'Fs01Px05', 'Avg-43':
           'Fs01Px1', 'Avg-44': 'Fs01Px2', 'Avg-45': 'Fs01Px5', 'Avg-46':
           'Fs05Px', 'Avg-47': 'Fs05Px05', 'Avg-48': 'Fs05Px1', 'Avg-49':
           'Fs05Px2', 'Avg-50': 'Fs05Px5', 'Avg-51': 'Fs1Px', 'Avg-52':
           'Fs1Px05', 'Avg-53': 'Fs1Px1', 'Avg-54': 'Fs1Px2', 'Avg-55':
           'Fs1Px5', 'Avg-56': 'Fs2Px', 'Avg-57': 'Fs2Px05', 'Avg-58':
           'Fs2Px1', 'Avg-59': 'Fs2Px2', 'Avg-60': 'Fs2Px5', 'Avg-61': 'Fs5Px',
           'Avg-62': 'Fs5Px05', 'Avg-63': 'Fs5Px1', 'Avg-64': 'Fs5Px2',
           'Avg-65': 'Fs5Px5'}


class MGMrun(object):
    def __init__(self, path=None, datafile=None, ylims=None, xlims=None,
                 errors=None, cont_type=None, cont_val=None, cont_err=None,
                 gaussian_list=None):
        if path is None:
            self.path = '.'
        else:
            self.path = path
        if datafile is None:
            self.datafile = 'data'
        else:
            self.datafile = datafile
        if ylims is None:
            self.ylims = [-170, 25, 10]
        else:
            self.ylims = ylims
        if xlims is None:
            self.xlims = [350, 2500, 1]
        else:
            self.xlims = xlims
        if errors is None:
            self.errors = [0.002, 1E-06]
        else:
            self.errors = errors
        if cont_type is None:
            self.cont_type = ContinuumType.NONE
        else:
            self.cont_type = cont_type
        if cont_val is None:
            self.cont_val = [0, 0, 0, 0]
        else:
            self.cont_val = cont_val
        if cont_err is None:
            self.cont_err = [0, 0, 0, 0]
        else:
            self.cont_err = cont_err
        if gaussian_list is None:
            self.gaussian_list = []
        else:
            self.gaussian_list = gaussian_list
        self.num_gaussian = len(self.gaussian_list)

    def write_startup_file(self, filename=None):
        if filename is None:
            filename = os.path.join(self.path, 'startup.fit')

        try:
            with open(filename, 'w') as out:
                print(f'{self.path}{os.sep}', file=out)
                print(self.datafile, file=out)
                print(*self.ylims, sep=',', file=out)
                print(*self.xlims, sep=',', file=out)
                print(*['%4.3E' % err for err in self.errors], sep=',',
                      file=out)
                print(types[self.cont_type], file=out)
                print(*self.cont_val, sep='\t', file=out)
                print(*self.cont_err, sep='\t', file=out)
                print(self.num_gaussian, file=out)
                for gauss in self.gaussian_list:
                    print(gauss.get_two_line_tabbed(), file=out)
        except IOError as e:
            sys.exit(f'I/O error: file {filename}: {e}')


if __name__ == '__main__':
    run_names = [value for key, value in run_map.items()]
    print(run_names)
    bands = [950, 1000, 1050]
    continuum = ContinuumType.STR_WN
    cont_vals = [0.86E+00, -0.1E-05, 0.0E+00, 0.0E+00]
    cont_errs = [100.0, 0.1E-2, 0.1E-6, 0.1E-6]

    for run in run_names[38:43]:
        gaussians = []
        for band in bands:
                gaussians.append(Gaussian(band))
        this_run = MGMrun(path=run, datafile=run, xlims=[600, 1700, 1],
                          cont_type=continuum, cont_val=cont_vals,
                          cont_err=cont_errs, gaussian_list=gaussians)
        this_run.write_startup_file(f'{run}.fit')
