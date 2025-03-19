#!/bin/bash
# SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

echo "THIS IS ONLY MEANT TO BE RUN FROM THE ROOT OF cs523/ repo EXIT NOW IF NOT" 
sleep 3 

tags_to_check=("v6.13" "v6.12" "v6.11" "v6.10" "v6.9" "v6.8" "v6.7" "v6.6" "v6.5" "v6.4" "v6.3" "v6.2" "v6.1" "v6.0")
# tags_to_check=("v6.13")

# TODO maybe add this back if needed 
# git clone https://github.com/torvalds/linux.git

mkdir -p output_all/
touch output_all/times.txt

for tag in "${tags_to_check[@]}"; do 
    echo Starting tag: $tag

    # Grab vmlinux 
    cd linux 
    git checkout tags/$tag 
    make defconfig
    make -j`nproc`
    echo "address,name" > all_text_symbols_6.6-rc4-default.txt && nm vmlinux | grep -e " t " -e " T " | awk '{print "0x"$1 "," $3}' >> all_text_symbols_6.6-rc4-default.txt
    cd .. 

    echo "TAG: $tag" &> output_all/times.txt
    time ./vigilante analyze --config config_all.yaml --address-list linux/all_text_symbols_6.6-rc4-default.txt --output output_all/out_$tag linux/vmlinux &> output_all/times.txt

    # clean linux 
    cd linux 
    make clean 
    cd .. 
done