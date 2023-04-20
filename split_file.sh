# Split the given file at every n-th line

dirname=${1%.txt}.split
mkdir ${dirname}
split -d -l"$2" --additional-suffix=.txt "$1" "${dirname}/article_split-"
echo "Wrote article splits to ${dirname}"
