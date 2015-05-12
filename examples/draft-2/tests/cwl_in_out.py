import json

with open('job.cwl.json') as fp:
    inp = json.load(fp)['inputs']['inp']
with open('result.cwl.json', 'w') as fp:
    json.dump({'out': inp}, fp)
