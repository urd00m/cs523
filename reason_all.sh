#!/bin/bash
# SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

echo "THIS IS ONLY MEANT TO BE RUN FROM THE ROOT OF cs523/ repo EXIT NOW IF NOT" 
sleep 3 

tags_to_check=("v6.13" "v6.12" "v6.11" "v6.10" "v6.9" "v6.8" "v6.7" "v6.6" "v6.5" "v6.4" "v6.3" "v6.2" "v6.1" "v6.0")
# tags_to_check=("v6.13")

# TODO maybe add this back if needed 
# git clone https://github.com/torvalds/linux.git

mkdir -p output_all/reason

for tag in "${tags_to_check[@]}"; do 
    echo Starting tag: $tag

    touch output_all/reason/log_$tag.txt
    
    python3 data_aggregator.py output_all/out_$tag/gadgets

    split -l $(($(wc -l < output_all/out_$tag/gadgets/combined.csv) / 2)) output_all/out_$tag/gadgets/combined.csv combined_

    time ./vigilante reason output_all/out_$tag/gadgets/combined_aa.csv output_all/out_$tag/reason_a.txt &> output_all/reason/log_$tag_a.txt
    time ./vigilante reason output_all/out_$tag/gadgets/combined_ab.csv output_all/out_$tag/reason_b.txt &> output_all/reason/log_$tag_b.txt
done
