#!/bin/bash


check_context(){
    # Check current kubectl context
    CURRENT_CONTEXT=$(kubectl config current-context)
    echo "Current kubectl context is: $CURRENT_CONTEXT"

    # Ask for confirmation
    read -p "Do you want to proceed with this cluster? (y/n) " CONFIRMATION

    if [[ "$CONFIRMATION" != "y" && "$CONFIRMATION" != "Y" ]]; then
        echo "Available kubectl contexts:"
        IFS=$'\n' read -r -d '' -a contexts < <(kubectl config get-contexts --no-headers | awk '{print $2}' && printf '\0')

        for i in "${!contexts[@]}"; do
            echo "$((i+1))) ${contexts[$i]}"
        done

        read -p "Select the context by entering the corresponding number: " selection
        selected_index=$((selection-1))

        if [ -z "${contexts[$selected_index]}" ]; then
            echo "Invalid selection, exiting."
            exit 1
        else
            SELECTED_CONTEXT="${contexts[$selected_index]}"
            echo "You have selected context: $SELECTED_CONTEXT"
            read -p "Are you sure you want to proceed with this cluster? (y/n) " final_confirmation
            if [[ "$final_confirmation" != "y" && "$final_confirmation" != "Y" ]]; then
                echo "Operation aborted by the user."
                exit 1
            fi
            kubectl config use-context "$SELECTED_CONTEXT"
            echo "Switched to context: $SELECTED_CONTEXT"
        fi
    fi
}


get_metadata() {
    local file_path="$1"
    local request="$2"

    metadata=$(grep -E "^\s*$request:" "$file_path" | awk '{print $2}' | head -n 1)

    echo $metadata

}

# Function to check if the file is a SealedSecret
is_sealed_secret() {
    local file_path="$1"
    grep -q "kind: SealedSecret" "$file_path"
}

# Function to create a new SealedSecret
create_sealed_secret() {
    local file_path="$1"
    local file_path_dest="sealed-${file_path}"


    # Create a new SealedSecret with the provided key-value pairs
    # TODO: ARE THESE ALL THE OPTIONS THAT WE NEED?
    kubeseal --scope strict --format yaml -f "${file_path}" -w "${file_path_dest}"
    echo "kubeseal executed - file ${file_path_dest} created."
    

}

merge_sealed_secret() {
    local file_path="$1"
    local key_values=("${@:2}")

    local secret_name=$(get_metadata ${file_path} "name")
    local secret_namespace=$(get_metadata ${file_path} "namespace")



    if is_sealed_secret "$file_path"; then

        # Replace commas with spaces and then split into an array
        IFS=' ' read -ra key_value_pairs <<< "${key_values//,/ }"


        for pair in "${key_value_pairs[@]}"; do
            IFS='=' read -r key value <<< "$pair"
            # Trim leading and trailing whitespaces
            key="${key%"${key##*[![:space:]]}"}"
            value="${value%"${value##*[![:space:]]}"}"
            echo -n "${value}" | kubectl  -n "${secret_namespace}" create secret generic "${secret_name}" --dry-run=client --from-file="${key}"=/dev/stdin -o yaml | kubeseal --merge-into $file_path -o yaml
        done

        cat $file_path
        echo "${file_path}" updated
    else
        echo "Error: The specified file is not a SealedSecret."
        exit 1
    fi
    
}


# Check if the correct number of arguments is provided
if [ "$#" -lt 1 ]; then
    echo "Usage:" 
    echo " To merge a secret: $0 <Sealedsecret-file-path> '<key1=value1, key2=value2, key3=value3>'"
    echo " To create a Sealed Secret: $0 <Secret-file-path>"
    exit 1
fi

# Assign arguments to variables
file_path="$1"
key_values=("${@:2}")

check_context

# Check if the file is a SealedSecret and perform the appropriate action
if is_sealed_secret "$file_path"; then
    merge_sealed_secret "$file_path" "${key_values[@]}"
else
    create_sealed_secret "${file_path}"
fi

echo "Script executed"
