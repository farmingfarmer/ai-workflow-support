#!/usr/bin/env python3
"""Precision/recall scorer for the Contract Review Agent.

Compares the agent's findings on an ORIGINAL document against the gold-standard set of
expected findings derived from the human RED-LINE of that same document.

Inputs (JSON):
  ground_truth : [{"id","clause","direction","desc", "aliases":[...]}]
      One entry per change the human reviewers made (insertion/deletion/qualifier). This is
      what *should* be caught.
  agent        : [{"id","clause","direction","verdict","playbook_grounded":true|false, "aliases":[...]}]
      The agent's actual findings. 'playbook_grounded' marks a flag the agent tied to a real
      playbook rule (used to judge extras the humans did not make).

Metrics:
  recall    = expected findings the agent caught / total expected findings
  precision = correct agent findings / total agent findings
              (correct = matched an expected finding OR a valid playbook-grounded extra)
  F1        = harmonic mean
Extras that are playbook-grounded but not in the gold set are reported as EXCEED (a catch the
humans did not make). Spurious/ungrounded extras are false positives.

Usage:
  python3 score_redline.py <ground_truth.json> <agent.json> [--label NAME]
  python3 score_redline.py --aggregate scorecards/*.json     # combine saved scorecards
"""
import json, sys, re, glob

def norm_clause(c):
    c = str(c).lower()
    c = re.sub(r'(section|clause|art\.?|article|§|sec\.?|no\.)', '', c)
    c = re.sub(r'[^0-9a-z.]', '', c)
    return c.strip('.')

def dir_compat(gt_dir, ag_dir, ag_aliases):
    if not gt_dir or not ag_dir:
        return True
    gt_dir = gt_dir.lower(); ag_dir = ag_dir.lower()
    if gt_dir == ag_dir:
        return True
    pool = set(a.lower() for a in (ag_aliases or [])) | {ag_dir}
    return gt_dir in pool

def match(gt_item, ag_item):
    gc = norm_clause(gt_item.get('clause', ''))
    ac = norm_clause(ag_item.get('clause', ''))
    alias_clauses = {norm_clause(x) for x in (gt_item.get('aliases', []) + ag_item.get('aliases', []))}
    clause_ok = bool(gc) and (gc == ac or ac in alias_clauses or gc in alias_clauses)
    return clause_ok and dir_compat(gt_item.get('direction'), ag_item.get('direction'), ag_item.get('aliases'))

def score(ground_truth, agent, label='document'):
    matched_gt, missed_gt = [], []
    used_agent = set()
    for gt in ground_truth:
        hit = next((i for i, ag in enumerate(agent) if i not in used_agent and match(gt, ag)), None)
        if hit is not None:
            used_agent.add(hit); matched_gt.append(gt)
        else:
            missed_gt.append(gt)
    exceed, false_pos = [], []
    for i, ag in enumerate(agent):
        if i in used_agent:
            continue
        (exceed if ag.get('playbook_grounded') else false_pos).append(ag)
    total_gt = len(ground_truth)
    total_ag = len(agent)
    correct_ag = len(used_agent) + len(exceed)
    recall = len(matched_gt) / total_gt if total_gt else 1.0
    precision = correct_ag / total_ag if total_ag else 1.0
    f1 = (2 * precision * recall / (precision + recall)) if (precision + recall) else 0.0
    return {
        'label': label, 'recall': round(recall, 3), 'precision': round(precision, 3), 'f1': round(f1, 3),
        'expected': total_gt, 'caught': len(matched_gt), 'agent_total': total_ag,
        'missed': [g.get('id') or g.get('clause') for g in missed_gt],
        'exceed': [a.get('id') or a.get('clause') for a in exceed],
        'false_positives': [a.get('id') or a.get('clause') for a in false_pos],
    }

def pct(x): return f"{x*100:.0f}%"

def report(sc):
    bar = "PASS" if (sc['recall'] >= 0.8 and sc['precision'] >= 0.8) else "BELOW 80%"
    print(f"\n=== {sc['label']} ===")
    print(f"  recall    {pct(sc['recall'])}  ({sc['caught']}/{sc['expected']} expected findings caught)")
    print(f"  precision {pct(sc['precision'])}  ({sc['agent_total']} agent findings)")
    print(f"  F1        {pct(sc['f1'])}   -> {bar} (target >= 80% each)")
    if sc['missed']:          print(f"  MISSED (recall gaps): {sc['missed']}")
    if sc['exceed']:          print(f"  EXCEED (valid catches humans did not make): {sc['exceed']}")
    if sc['false_positives']: print(f"  FALSE POSITIVES: {sc['false_positives']}")

def aggregate(paths):
    cards = [json.load(open(p)) for p in paths]
    exp = sum(c['expected'] for c in cards); caught = sum(c['caught'] for c in cards)
    agt = sum(c['agent_total'] for c in cards)
    # precision aggregated as correct/total; reconstruct correct from precision*total
    correct = sum(round(c['precision'] * c['agent_total']) for c in cards)
    R = caught / exp if exp else 1.0
    P = correct / agt if agt else 1.0
    F = (2*P*R/(P+R)) if (P+R) else 0.0
    print(f"\n=== AGGREGATE over {len(cards)} documents ===")
    print(f"  recall    {pct(R)}  ({caught}/{exp})")
    print(f"  precision {pct(P)}  ({correct}/{agt})")
    print(f"  F1        {pct(F)}   -> {'PASS' if (R>=0.8 and P>=0.8) else 'BELOW 80%'}")

if __name__ == '__main__':
    args = sys.argv[1:]
    if args and args[0] == '--aggregate':
        paths = []
        for a in args[1:]:
            paths += glob.glob(a)
        aggregate(paths); sys.exit(0)
    label = 'document'
    if '--label' in args:
        i = args.index('--label'); label = args[i+1]; args = args[:i] + args[i+2:]
    if len(args) < 2:
        print(__doc__); sys.exit(1)
    gt = json.load(open(args[0])); ag = json.load(open(args[1]))
    sc = score(gt, ag, label)
    report(sc)
    print("\nJSON:", json.dumps(sc))
