import os
import sys
import copy
import json
import logging

import yaml
import docopt

__doc__ = """
CWL test suite runner.

Usage:
  run_tests.py [--tools-only] [--cmd-only] <executor> [<requirement>...]

"""


class Test(object):
    def __init__(self, data):
        self.data = data
        self._app = None

    @property
    def app(self):
        if not self._app:
            with open(self.data['app']) as fp:
                self._app = yaml.load(fp)
        return self._app

    @property
    def req_types(self):
        return set(r['class'] for r in self.app.get('requirements', []))

    @property
    def app_type(self):
        return self._app['class']

    @property
    def name(self):
        return self.data['name']

    def check_result(self, result, cmd_only=False):
        if not cmd_only:
            assert self.data['outputs'] == self._clean_out_files(result['outputs'])
        if not self.data.get('cmd'):
            return
        if self.app_type != 'CommandLineTool':
            return  # TODO: Workflow cmd matching
        expected = self.data.get('cmd').replace('{input_dir}', result['input_dir'])
        assert expected == result['cmd']

    def _clean_out_files(self, obj):
        if not isinstance(obj, (dict, list)):
            return obj
        if isinstance(obj, list):
            return [self._clean_out_files(item) for item in obj]
        if obj.get('class') != 'File':
            return {k: self._clean_out_files(v) for k, v in obj.iteritems()}
        return {'class': 'File', 'name': os.path.basename(obj['path'])}


def run_test(test, executable, cmd_only=False):
    job = {
        'app': test.data['app'],
        'inputs': test.data['inputs'],
        'allocatedResources': test.data['resources'],
    }
    with open('job.json', 'w') as fp:
        json.dump(job, fp, indent=2)
    retcode = os.system('%s %s job.json > result.json' % (executable, '--cmd-only' if cmd_only else ''))
    assert retcode, 'Program exit code: %s' % retcode
    with open('result.json') as fp:
        result = json.load(fp)
    assert test.check_result(result)


def main():
    with open('tests.yaml') as fp:
        tests = map(Test, yaml.load(fp))
    args = docopt.docopt(__doc__)
    suite = [t for t in tests if t.req_types.issubset(set(args['<requirement>']))]
    if args['--tools-only'] or args['--cmd-only']:
        suite = [t for t in suite if t.app_type == 'CommandLineTool']
    print('Running %s tests: %s' % (len(suite), [t.name for t in suite]))
    for test in suite:
        try:
            run_test(test, args['<executable>'], cmd_only=args['--cmd-only'])
        except AssertionError:
            logging.exception('Test failed.')


if __name__ == '__main__':
    main()
