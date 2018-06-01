#!/usr/bin/env python3
"""Split one csv file with multiple VNIR measurements into multiple tsv files.

This program takes a comma separated value file with a wavelength column and
one or more reflectance measurement columns and splits it into a tab
separated for each reflectance measurement containing a wavelenght and a
reflectance measurement separated by one tab. It is primarily used to
generate input ascii files for the Modified Gaussian Model.

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

import csv
import sys
import os

__author__ = 'Carey Legett'
__copyright__ = 'Copyright 2018, Carey Legett'
__credits__ = 'Carey Legett'
__license__ = 'GPLv3'
__version__ = '0.1a'
__maintainer__ = 'Carey Legett'
__email__ = 'carey.legett@stonybrook.edu'
__date__ = '30 May 2018'
__status__ = 'Development'

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

if __name__ == '__main__':
    input_file = 'temple_matlab_format.csv'
    try:
        with open(input_file, 'r') as infile:
            reader = csv.reader(infile)
            data = list(reader)
    except IOError as e:
        sys.exit(f'IOError on file {input_file}: {e}')

    runs = list(map(list, zip(*data)))
    run_names = data[0][1:]
    print(f'run names: {run_names}')
    wls = runs[0][251:-800]
    print(f'wls: {wls}')
    runs = [sublist[251:-800] for sublist in runs[1:]]
    print(f'runs: {runs[0]}')

    for run_num, name in enumerate(run_names):
        os.makedirs(os.path.dirname(f'{run_map[name]}{os.sep}{run_map[name]}'
                                    f'.asc'), exist_ok=True)

        try:
            with open(f'{run_map[name]}{os.sep}{run_map[name]}.asc', 'w') as \
                    out:
                writer = csv.writer(out, delimiter='\t')
                writer.writerows(zip(wls, runs[run_num]))
        except IOError as e:
            sys.exit(f'IOError on file {run_map[name]}.asc: {e}')
