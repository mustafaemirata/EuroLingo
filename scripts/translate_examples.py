#!/usr/bin/env python3
"""
Extract example sentences from oxford_data.dart and translate them to Turkish.
Then update oxford_data.dart with translations field.
"""

import re
import json
import time
import urllib.request
import urllib.parse
import sys

OXFORD_FILE = '/Users/mustafaemirata/eurolingo/lib/data/oxford_data.dart'
OUTPUT_FILE = '/Users/mustafaemirata/eurolingo/lib/data/oxford_data.dart'

def translate_batch(texts, src='en', dest='tr'):
    """Translate a batch of texts using Google Translate (free endpoint)."""
    translations = []
    for text in texts:
        if not text.strip():
            translations.append('')
            continue
        try:
            url = 'https://translate.googleapis.com/translate_a/single'
            params = urllib.parse.urlencode({
                'client': 'gtx',
                'sl': src,
                'tl': dest,
                'dt': 't',
                'q': text,
            })
            full_url = f'{url}?{params}'
            req = urllib.request.Request(full_url, headers={
                'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36'
            })
            with urllib.request.urlopen(req, timeout=10) as response:
                data = json.loads(response.read().decode('utf-8'))
                translated = ''.join(part[0] for part in data[0] if part[0])
                translations.append(translated)
        except Exception as e:
            print(f'  ⚠ Translation failed for: {text[:50]}... -> {e}')
            translations.append('')
        time.sleep(0.1)  # Rate limiting
    return translations


def parse_oxford_data(filepath):
    """Parse the oxford_data.dart file and extract entries."""
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()

    # Match each entry: 'word': OxfordEntry(...)
    pattern = r"'([^']+)':\s*OxfordEntry\(\s*pronunciation:\s*'([^']*)',\s*examples:\s*\[(.*?)\],?\s*\)"
    entries = []
    for match in re.finditer(pattern, content, re.DOTALL):
        word = match.group(1)
        pronunciation = match.group(2)
        examples_raw = match.group(3)

        # Parse examples - handle escaped quotes
        examples = []
        for ex_match in re.finditer(r"'((?:[^'\\]|\\.)*)'", examples_raw):
            ex = ex_match.group(1).replace("\\'", "'")
            examples.append(ex)

        entries.append({
            'word': word,
            'pronunciation': pronunciation,
            'examples': examples,
        })

    return entries


def generate_dart_file(entries, filepath):
    """Generate the updated oxford_data.dart file with translations."""
    lines = []
    lines.append("// AUTO-GENERATED — Oxford Learner's Dictionary data")
    lines.append(f"// Total: {len(entries)} words with pronunciation + example sentences + Turkish translations")
    lines.append("//")
    lines.append("import 'package:eurolingo/models/word_model.dart';")
    lines.append("")
    lines.append("final Map<String, OxfordEntry> oxfordDataAll = {")

    for entry in entries:
        word = entry['word']
        pron = entry['pronunciation']
        examples = entry['examples']
        translations = entry.get('translations', [])

        # Escape single quotes in examples
        escaped_examples = []
        for ex in examples:
            escaped = ex.replace("'", "\\'")
            escaped_examples.append(f"'{escaped}'")

        escaped_translations = []
        for tr in translations:
            escaped = tr.replace("'", "\\'")
            escaped_translations.append(f"'{escaped}'")

        examples_str = ', '.join(escaped_examples)
        translations_str = ', '.join(escaped_translations)

        lines.append(f"  '{word}': OxfordEntry(")
        lines.append(f"    pronunciation: '{pron}',")
        lines.append(f"    examples: [{examples_str}],")
        lines.append(f"    translations: [{translations_str}],")
        lines.append(f"  ),")

    lines.append("};")
    lines.append("")

    with open(filepath, 'w', encoding='utf-8') as f:
        f.write('\n'.join(lines))


def main():
    print("📖 Parsing oxford_data.dart...")
    entries = parse_oxford_data(OXFORD_FILE)
    print(f"   Found {len(entries)} words")

    total_examples = sum(len(e['examples']) for e in entries)
    print(f"   Total examples to translate: {total_examples}")

    # Translate in batches
    translated_count = 0
    for i, entry in enumerate(entries):
        if entry['examples']:
            print(f"   [{i+1}/{len(entries)}] Translating: {entry['word']} ({len(entry['examples'])} examples)")
            entry['translations'] = translate_batch(entry['examples'])
            translated_count += len(entry['examples'])
        else:
            entry['translations'] = []

        # Progress report every 50 words
        if (i + 1) % 50 == 0:
            print(f"   ✅ Progress: {i+1}/{len(entries)} words, {translated_count}/{total_examples} examples")

    print(f"\n📝 Writing updated oxford_data.dart...")
    generate_dart_file(entries, OUTPUT_FILE)
    print(f"✅ Done! Translated {translated_count} example sentences.")


if __name__ == '__main__':
    main()
