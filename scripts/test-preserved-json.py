#!/usr/bin/env python3
"""Test modify templates against disposable local state, without reading credentials."""
import json
from pathlib import Path
import subprocess
import tempfile

source = Path(__file__).resolve().parents[1]
fixtures = {
    '.pi/agent/settings.json': {
        'defaultModel': 'local-choice', 'packages': [],
        'pi-a2a': {'hub': {'apiKey': 'test-only-hub-key', 'autoRegister': False}},
        'localOnly': {'enabled': False},
    },
    '.pi/agent/models.json': {'providers': {
        'bifrost': {'apiKey': 'test-only-bifrost-key'},
        'ollama-cloud': {'apiKey': 'test-only-ollama-key', 'models': []},
        'local-only': {'apiKey': 'test-only-extra-key', 'baseUrl': 'http://localhost:1234'},
    }},
    '.claude/settings.json': {
        'hooks': {'SessionStart': [{'hooks': [{'type': 'command', 'command': 'true'}]}]},
        'statusLine': {'type': 'command', 'command': 'true'},
        'tui': 'local-choice', 'localOnly': False,
    },
}


def assert_subset(expected, actual):
    if isinstance(expected, dict):
        for key, value in expected.items():
            assert key in actual, key
            assert_subset(value, actual[key])
    else:
        assert expected == actual


with tempfile.TemporaryDirectory(prefix='chezmoi-preserve-test-') as directory:
    dest = Path(directory)
    for name, fixture in fixtures.items():
        target = dest / name
        target.parent.mkdir(parents=True, exist_ok=True)
        target.write_text(json.dumps(fixture))
        command = ['chezmoi', '--source', str(source), '--destination', str(dest), 'cat', str(target)]
        rendered = subprocess.check_output(command, text=True)
        result = json.loads(rendered)
        assert_subset(fixture, result)
        target.write_text(rendered)
        assert json.loads(subprocess.check_output(command, text=True)) == result
        print('PASS preserve live values and idempotence:', name)
    target = dest / '.pi/agent/settings.json'
    target.unlink()
    result = json.loads(subprocess.check_output([
        'chezmoi', '--source', str(source), '--destination', str(dest), 'cat', str(target)
    ], text=True))
    assert result['npmCommand'][-1] == 'pnpm@11.17.0'
    assert 'apiKey' not in result['pi-a2a']['hub']
    print('PASS fresh Pi settings contain defaults but no fabricated credentials')
