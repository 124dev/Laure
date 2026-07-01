#!/home/arch12/.local/share/pipx/venvs/pywal/bin/python
import sys
from pywal.__main__ import main
if __name__ == '__main__':
    if sys.argv[0].endswith('.exe'):
        sys.argv[0] = sys.argv[0][:-4]
    sys.exit(main())
