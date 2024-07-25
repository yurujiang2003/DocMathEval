#!/bin/bash

prompt_types=(
    "cot"
    "pot"
)
subsets=(
    "compshort_testmini"
    "compshort_test"
    "simpshort_testmini"
    "simpshort_test"
    "simplong_testmini"
    "simplong_test"
    "complong_testmini"
    "complong_test"
    "complong_testmini-rag"
    "complong_test-rag"
)

api_base="TODO"
api_key="TODO"

for prompt_type in "${prompt_types[@]}"; do
    for subset in "${subsets[@]}"; do
        echo "Evaluating $prompt_type on $subset set"
        raw_dir="outputs/$subset/raw_${prompt_type}_outputs"
        processed_dir="outputs/$subset/processed_${prompt_type}_outputs"
        result_file="outputs/${subset}_${prompt_type}_results.json"

        # remove result file if it exists
        if [ -f "$result_file" ]; then
            rm "$result_file"
        fi

        # Iterate over each file in the raw output directory
        for raw_file in "$raw_dir"/*; do
            filename=$(basename "$raw_file")
            
            python evaluation.py \
                --prediction_path "$raw_file" \
                --evaluation_output_dir "$processed_dir" \
                --prompt_type "$prompt_type" \
                --result_file "$result_file" \
                --api_base "$api_base" \
                --api_key "$api_key"

            echo "Finished evaluating $filename"
        done

        echo "Finished evaluating $prompt_type on $subset set"
    done
done