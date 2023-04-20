BOLD := \033[1m
DIM := \033[2m
RESET := \033[0m

INPUT_FILE=/data/articles.txt
OUTPUT_FILE=/results/linked_articles.jsonl
TMP_OUTPUT_SPLIT_DIR=/results/tmp_linked_articles_split/
SPLIT_SIZE=40

help:
	@echo "${BOLD}link_benchmark:${RESET}"
	@echo "		Link all articles in the INPUT_FILE file using Gupta et al.'s CDTE model."
	@echo "		Results are written to OUTPUT_FILE"
	@echo "		Time to run: ~ 5 min | required RAM: 65GB${RESET}"

link_benchmark:
	python3 neuralel.py --config=configs/config.ini --model_path=/data/models/CDTE.model --in_file=${INPUT_FILE} --out_file=${OUTPUT_FILE}

disambiguate_benchmark:
	python3 neuralel.py --config=configs/config.ini --model_path=/data/models/CDTE.model --in_file=${INPUT_FILE} --out_file=${OUTPUT_FILE} --contains_ner=True

split_articles:
	./split_file.sh ${INPUT_FILE} ${SPLIT_SIZE}

link_split_benchmark:
	# Create tmp output directory if it does not exist already
	[ -d ${TMP_OUTPUT_SPLIT_DIR} ] || mkdir ${TMP_OUTPUT_SPLIT_DIR}
	# Remove previous article split
	[ -z "$$(ls -A ${TMP_OUTPUT_SPLIT_DIR}*.jsonl 2>/dev/null)" ] || rm ${TMP_OUTPUT_SPLIT_DIR}*.jsonl
	for f in ${INPUT_FILE}/*.txt; do \
	  filename=$$(basename $${f} .txt); \
	  echo "filename: $${filename}"; \
	  python3 neuralel.py --config=configs/config.ini --model_path=/data/models/CDTE.model --in_file=$${f} --out_file=${TMP_OUTPUT_SPLIT_DIR}linked_$${filename}.jsonl; \
	done
	cat ${TMP_OUTPUT_SPLIT_DIR}linked_article_split-*.jsonl > ${OUTPUT_FILE}

disambiguate_split_benchmark:
	# Create tmp output directory if it does not exist already
	[ -d ${TMP_OUTPUT_SPLIT_DIR} ] || mkdir ${TMP_OUTPUT_SPLIT_DIR}
	# Remove previous article split
	[ -z "$$(ls -A ${TMP_OUTPUT_SPLIT_DIR}*.jsonl 2>/dev/null)" ] || rm ${TMP_OUTPUT_SPLIT_DIR}*.jsonl
	for f in ${INPUT_FILE}/*.txt; do \
	  filename=$$(basename $${f} .txt); \
	  echo "filename: $${filename}"; \
	  python3 neuralel.py --config=configs/config.ini --model_path=/data/models/CDTE.model --in_file=$${f} --out_file=${TMP_OUTPUT_SPLIT_DIR}linked_$${filename}.jsonl --contains_ner=True; \
	done
	cat ${TMP_OUTPUT_SPLIT_DIR}linked_article_split-*.jsonl > ${OUTPUT_FILE}
