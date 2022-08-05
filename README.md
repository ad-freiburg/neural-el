Neural Entity Linking
=====================
Code for paper
"[Entity Linking via Joint Encoding of Types, Descriptions, and Context](http://cogcomp.org/page/publication_view/817)",
 EMNLP '17

This is a dockered version of the [original code](https://github.com/nitishgupta/neural-el) that has been adjusted to
 be easily usable in combination with [ELEVANT](https://github.com/ad-freiburg/elevant).

<img src="https://raw.githubusercontent.com/nitishgupta/neural-el/master/overview.png" alt="https://raw.githubusercontent.com/nitishgupta/neural-el/master/overview.png">

## Abstract
For accurate entity linking, we need to capture the various information aspects of an entity, such as its description
 in a KB, contexts in which it is mentioned, and structured knowledge. Further, a linking system should work on texts
 from different domains without requiring domain-specific training data or hand-engineered features.
In this work we present a neural, modular entity linking system that learns a unified dense representation for each
 entity using multiple sources of information, such as its description, contexts around its mentions, and
 fine-grained types. We show that the resulting entity linking system is effective at combining these sources, and
 performs competitively, sometimes out-performing current state-of-art-systems across datasets, without requiring any
 domain-specific training data or hand-engineered features. We also show that our model can effectively "embed"
 entities that are new to the KB, and is able to link its mentions accurately.

## Setup
Download the [resources](https://drive.google.com/open?id=0Bz-t37BfgoTuSEtXOTI1SEF3VnM) to a directory
 `<data_directory>` and unzip them.

## Run
Build the docker image with

    docker build -t neural-el-gupta .

Run the docker container with

    docker run -it -v <data_directory>/neural-el_resources:/data:ro -v <results_directory>:/results neural-el-gupta

Within the docker container run `make help` for additional information.

To link benchmark entities you only need to run `make link_benchmark`. This assumes benchmark articles are stored in
 the expected format in the file `<data_directory>/neural-el_resources/articles.txt`.
 To get benchmark articles into Neural EL's expected input format use ELEVANT's `write_articles.py` script
 ([see here](https://github.com/ad-freiburg/elevant/blob/master/write_articles.py)) with the
  following options:

    python3 write_articles.py --output_file <data_directory>/neural-el_resources/articles.txt --one_article_per_line -b <benchmark_name>

The linking results are written to `<results_directory>/linked_articles.jsonl` in
[ELEVANT's simple-jsonl format](https://github.com/ad-freiburg/elevant/blob/master/docs/link_benchmark_articles.md#linking-results-in-a-simple-jsonl-format).

NOTE: RAM requirements currently depend on the number of articles to be linked. For 40 benchmark articles, Neural EL
 requires almost 70GB of RAM. If you don't have enough RAM available, split `articles.txt` into several files and run
 `neural_el.py` for each file separately (simply adjust the link_benchmark target in the Makefile).

Within ELEVANT, the linking results can be converted to ELEVANT's internal format with

    python3 link_benchmark_entities.py neural-el -pfile <results_directory>/linked_articles.jsonl -pformat simple-jsonl -pname neural-el -b <benchmark_name>
