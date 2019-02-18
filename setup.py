"""
This is a setup.py script generated by py2applet

Usage:
    python setup.py py2app
"""
from setuptools import setup

from vm.const import VERSION

APP = ['VocabMate.py', ]
DATA_FILES = []
OPTIONS = dict(
    dist_dir='.',
    argv_emulation=True,
    optimize=2,
    compressed=True,
    frameworks=[
        '_env/lib/python3.6/site-packages/shiboken2/libshiboken2.abi3.5.12.dylib',
        '_env/lib/python3.6/site-packages/PySide2/libpyside2.abi3.5.12.dylib',
    ],
    packages=['shiboken2'],
    includes=[],
    resources=['qml'],
    excludes=['py2app', 'cx-freeze', 'PyInstaller', 'pkg_resources', 'pydoc_data', 'unittest', 'xmlrpc',
              'PySide2.Qt'],
    qt_plugins=["imageformats", "platforms", "mediaservice", "audio"],
    use_faulthandler=True,
    iconfile='qml/res/img/icon.icns',
    plist={
        'LSPrefersPPC': False,
        # 'LSArchitecturePriority': ['i386'],
        'CFBundleIdentifier': 'com.kuangkuang.vocabmate',
        'CFBundleName': 'VocabMate',
        'CFBundleDisplayName': 'Vocabulary Mate',
        'CFBundleVersion': VERSION
    }
)

setup(
    app=APP,
    data_files=DATA_FILES,
    options={'py2app': OPTIONS},
    setup_requires=['py2app'],
)
