import math
import numpy as np
import sys
import re
import os
import dill


def load_data(file_path, stop_word_file):
    stop_words = set([])

    if stop_word_file is not None:
        with open(stop_word_file) as f:
            stop_words = set([line.strip() for line in f.readlines()])

    with open(file_path) as f:
        txt = f.read()
    raw_words = []
    # A little cleanup for punctuations and case
    for unclean_word in filter(None, re.split("[\]\[\)\(\"\'\n,\-\.!?: ]+", txt)):
        word = str.lower(unclean_word.strip())
        # Random codecs can mess this
        if len(word) > 2:
            raw_words.append(word)

    # Unigrams
    unigrams = [word for word in raw_words if word not in stop_words]
    bigrams = ["%s %s" % (raw_words[i], raw_words[i+1]) for i in range(len(raw_words) - 1)]
    trigrams = ["%s %s %s" % (raw_words[i], raw_words[i+1], raw_words[i+2]) for i in range(len(raw_words) - 2)]
    words = unigrams + bigrams + trigrams

    return np.array(words)


def evaluate(x, P, Pc):
    lnps = [0, 0]
    for i in range(0, 2):
        lnps[i] = math.log(Pc[i]) + np.sum(np.log([P[word][i] for word in x]))
    return np.argmax(lnps)


if __name__ == "__main__":
    PAR_DIR = os.path.join(os.path.dirname(__file__), "..")
    STOP_WORD_FILE = os.path.join(PAR_DIR, "stop-word-list.txt")

    if len(sys.argv) != 2:
        print("Usage: python prog.py <TEXT_FILE_PATH>")
        sys.exit(1)

    with open(os.path.join(PAR_DIR, "model", "P.p")) as f:
        P = dill.load(f)

    with open(os.path.join(PAR_DIR, "model", "Pc.p")) as f:
        Pc = dill.load(f)

    X = load_data(sys.argv[1], STOP_WORD_FILE)
    print evaluate(X, P, Pc)
